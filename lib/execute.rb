require_relative "execute/extended_status"
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
  # @return [Execute::ExtendedStatus] exit status of command
  def execute cmd, env: {}, io_options: {}, dryrun: false, print_cmd: false, print_lines: false
    Execute.execute cmd, env: env, io_options: io_options, dryrun: dryrun, print_cmd: print_cmd, print_lines: print_lines
  end

  # execute command
  #
  # @param cmd [Array] command to execute
  # @param env [Hash] popen environment variables
  # @param io_options [Hash] popen io_options
  # @param dryrun [Bool] do not run command
  # @param print_cmd [Bool] print command, which is going to be executed
  # @param print_lines [Bool] print output lines of command
  # @return [Execute::ExtendedStatus] exit status of command
  def self.execute cmd, env: {}, io_options: {}, dryrun: false, print_cmd: false, print_lines: false

    STDOUT.sync = true

    if dryrun
      stdout = cmd.join(" ")
      stdout_lines = [stdout]
      puts stdout
    else
      print_cmd cmd if print_cmd

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
