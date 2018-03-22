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
