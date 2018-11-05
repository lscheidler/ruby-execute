# Copyright 2018 Lars Eric Scheidler
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require_relative "execute/extended_status"
require_relative "execute/execution_failed_exception"
require_relative "execute/version"

# popen wrapper
module Execute
  # execute command
  #
  # @param cmd [Array] command to execute
  # @param env [Hash] popen environment variables
  # @param io_options [Hash] popen io_options
  # @param dryrun [Bool] do not run command
  # @param print_cmd [Bool] print command, which is going to be executed
  # @param print_lines [Bool] print output lines of command
  # @param raise_exception [Bool] raise an exception, if command doesn't succeeds
  # @return [Execute::ExtendedStatus] exit status of command
  # @raise [Execute::ExecutionFailedException]
  def execute cmd, env: {}, io_options: {}, dryrun: false, print_cmd: false, print_lines: false, raise_exception: false
    Execute.execute cmd, env: env, io_options: io_options, dryrun: dryrun, print_cmd: print_cmd, print_lines: print_lines, raise_exception: raise_exception
  end

  # execute command
  #
  # @param cmd [Array] command to execute
  # @param env [Hash] popen environment variables
  # @param io_options [Hash] popen io_options
  # @param dryrun [Bool] do not run command
  # @param print_cmd [Bool] print command, which is going to be executed
  # @param print_lines [Bool] print output lines of command
  # @param raise_exception [Bool] raise an exception, if command doesn't succeeds
  # @return [Execute::ExtendedStatus] exit status of command
  # @raise [Execute::ExecutionFailedException]
  def self.execute cmd, env: {}, io_options: {}, dryrun: false, print_cmd: false, print_lines: false, raise_exception: false

    STDOUT.sync = true

    print_cmd cmd if print_cmd

    if dryrun
      stdout = cmd.join(" ")
      stdout_lines = [stdout]
      puts stdout
    else
      stdout, stdout_lines = IO.popen([env]+cmd+[io_options]) {|io|
        stdout = ""
        stdout_lines = []
        while io.gets
          stdout += $_
          stdout_lines << $_.delete("\n")

          print $_ if print_lines
        end
        [stdout, stdout_lines]
      }
    end

    status = Execute::ExtendedStatus.new $?
    status.stdout = stdout
    status.stdout_lines = stdout_lines
    if raise_exception and not status.success?
      raise Execute::ExecutionFailedException.new status
    end
    status
  end

  # execute command asynchron
  #
  # @param cmd [Array] command to execute
  # @param env [Hash] popen environment variables
  # @param io_options [Hash] popen io_options
  # @param dryrun [Bool] do not run command
  # @return [IO] IO object
  def execute_start cmd, env: {}, io_options: {}, dryrun: false
    Execute.execute_start cmd, env: env, io_options: io_options, dryrun: dryrun
  end

  # execute command asynchron
  #
  # @param cmd [Array] command to execute
  # @param env [Hash] popen environment variables
  # @param io_options [Hash] popen io_options
  # @param dryrun [Bool] do not run command
  # @return [IO] IO object
  def self.execute_start cmd, env: {}, io_options: {}, dryrun: false
    if dryrun
      puts cmd.join(" ") if dryrun
      return if dryrun
    end

    IO.popen([env]+cmd+[io_options])
  end

  # wait for asynchron execution
  #
  # @param io [IO] IO object, which is returned by execute_start
  # @return [Execute::ExtendedStatus] exit status of command
  def execute_end io
    Execute.execute_end io
  end

  # wait for asynchron execution
  #
  # @param io [IO] IO object, which is returned by execute_start
  # @return [Execute::ExtendedStatus] exit status of command
  def self.execute_end io
    return if io.nil?

    pid, s = Process.waitpid2(io.pid)
    status = Execute::ExtendedStatus.new s
    status.stdout = io.read
    status.stdout_lines = status.stdout.split("\n")
    status
  end

  private
  # print command, which is going to be executed
  #
  # @param cmd [Array] command to print
  def self.print_cmd cmd
    begin
      require 'colorize'
      puts "| ".yellow + cmd.join(" ")
    rescue LoadError
      puts cmd.join(" ")
    end
  end
end
