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

module Execute
  # extended status with stdout of command
  class ExtendedStatus
    # @!attribute [rw] stdout
    #   @return [String] stdout of command
    attr_accessor :stdout
  
    # @!attribute [rw] stdout_lines
    #   @return [Arrays] stdout lines of commands splitted on \n
    attr_accessor :stdout_lines
  
    # @param status [Process::Status] original status object
    def initialize status
      @status = status
    end
  
    # exit status
    #
    # @return [Integer] exit status of command
    def exitstatus
      if @status
        @status.exitstatus
      else
        0
      end
    end
  
    # @return [Bool] if command was successfully (exit status == 0)
    def success?
      if @status
        @status.success?
      else
        true
      end
    end
  
    # call method on original status object, if method is missing
    #
    # @param name [Symbol] name of method
    def method_missing name
      @status.send name
    end
  
    # return string representation of original status object
    def to_s
      @status.to_s
    end
  end
end
