require 'irb'
require 'drb/drb'

module IRB
  class Context
    def prompting?; true; end
  end

  class Irb
    attr_accessor :stdout
    def print(*opts)
      @stdout ? @stdout.print(*opts) : super
    end

    def printf(*opts)
      @stdout ? @stdout.printf(*opts) : super
    end
  end
end

class IRb
  def start(input_method, output)
    irb = IRB::Irb.new(nil, input_method)
    irb.stdout = output
    th = Thread.new do
      catch(:IRB_EXIT) do
        irb.eval_input
      end
    end
  end
end

DRb.start_service('druby://:54345', IRb.new)
IRB.start(__FILE__)

