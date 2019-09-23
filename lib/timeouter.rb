require 'timeouter/timer'


module Timeouter

  TimeoutError = Timeout::Error

  class << self

    def run(timeout = 0, eclass: Timeouter::TimeoutError, emessage: 'execution expired')
      yield(Timeouter::Timer.new(timeout, eclass: eclass, emessage: emessage))
    end

    def loop(timeout = 0, eclass: Timeouter::TimeoutError, emessage: 'execution expired', &block)
      Timeouter::Timer.new(timeout, eclass: eclass, emessage: emessage).loop(&block)
    end

    def loop!(timeout = 0, eclass: Timeouter::TimeoutError, emessage: 'execution expired', &block)
      Timeouter::Timer.new(timeout, eclass: eclass, emessage: emessage).loop!(&block)
    end

  end

end

