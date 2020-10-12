require 'timeout'

module Timeouter
  class Timer

    attr_reader :timeout, :started_at#, :exhausted_at

    def initialize(timeout = 0, eclass: nil, message: nil)
      # ensure only positive timeouts
      timeout ||= 0
      @timeout = [timeout, 0].max

      @eclass = eclass || Timeouter::TimeoutError
      @message = message || 'execution expired'

      @started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end

    # elapsed time from creation
    def elapsed
      Process.clock_gettime(Process::CLOCK_MONOTONIC) - @started_at
    end

    # time left to be exhausted or nil if timeout was 0
    def left
      (@timeout > 0) ? [@timeout - elapsed, 0].max : nil
    end

    # is timeout exhausted? or nil when timeout was 0
    def exhausted?
      (@timeout > 0) ? elapsed > @timeout : nil
    end

    # is timeout NOT exhausted? or true when timeout was 0
    def running?
      !exhausted?
    end

    # ensure timeout NOT exhausted raise exception otherwise
    def running!(eclass = @eclass, message: @message)
      !exhausted? || (raise eclass.new(message))
    end

    # run block in loop until timeout reached. Use break for returning result
    def loop
      yield(self) while self.running?
    end

    def loop!(eclass = @eclass, message: @message)
      yield(self) while self.running!(eclass, message: message)
    end

  end
end

