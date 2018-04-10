module Execute
  # Exception for failed executions
  class ExecutionFailedException < SystemExit
    # @!attribute [r] extended_status
    #   @return [Execute::ExtendedStatus] extended status
    attr_accessor :extended_status

    # @param status [Execute::ExtendedStatus] extended status object
    def initialize status
      super(status.exitstatus)
      @extended_status = status
    end
  end
end
