require 'timeout'

module Timeouter
  class Timer

    attr_reader :started_at, :exhausted_at

    def initialize(timeout = 0, eclass: Timeouter::TimeoutError, emessage: 'execution expired')
      # ensure only positive timeouts
      timeout ||= 0
      timeout = [timeout, 0].max

      @eclass = eclass
      @emessage = emessage

      @started_at = Time.now
      @exhausted_at = timeout > 0 ? @started_at + timeout : nil
    end

    # elapsed time from creation
    def elapsed
      Time.now - @started_at
    end

    # time left to be exhausted or nil if timeout was 0
    def left
      @exhausted_at && [@exhausted_at - Time.now, 0].max
    end

    # is timeout exhausted? or nil when timeout was 0
    def exhausted?
      @exhausted_at && (@exhausted_at < Time.now)
    end

    # is timeout NOT exhausted? or true when timeout was 0
    def running?
      !exhausted?
    end

    # ensure timeout NOT exhausted raise exception otherwise
    def running!(eclass = @eclass, message: @emessage)
      !exhausted? || (raise eclass.new(message))
    end

    # run block in loop until timeout reached. Use break for returning result
    def loop
      yield(self) while self.running?
    end

    def loop!(eclass = @eclass, message: @emessage)
      yield(self) while self.running!(eclass, message: message)
    end

  end
end

