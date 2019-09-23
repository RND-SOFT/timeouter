require 'timeouter/timer'


module Timeouter

  TimeoutError = Timeout::Error

  class << self

    def run(timeout = 0, eclass: Timeouter::TimeoutError, message: 'execution expired')
      yield(Timeouter::Timer.new(timeout, eclass: eclass, message: message))
    end

    def loop(timeout = 0, eclass: Timeouter::TimeoutError, message: 'execution expired', &block)
      Timeouter::Timer.new(timeout, eclass: eclass, message: message).loop(&block)
    end

    def loop!(timeout = 0, eclass: Timeouter::TimeoutError, message: 'execution expired', &block)
      Timeouter::Timer.new(timeout, eclass: eclass, message: message).loop!(&block)
    end

  end

end

