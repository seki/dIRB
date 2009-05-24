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

=begin
 [terminal A] $ ruby irb_d.rb --noreadline
 [terminal B] $ ruby irb_c.rb

 [terminal B]
 irb(main):001:0> A = 'Here'
 => "Here"

 [terminal A]
 irb(main):001:0> A
 => "Here"
 irb(main):002:0> require 'thread'
 => false
 irb(main):003:0> $queue = Queue.new
 => #<Queue:0x446114>

 [terminal B]
 irb(main):002:0> $queue.pop

 [terminal A]
 irb(main):004:0> $queue.push('there')
 => #<Queue:0x446114>

 [terminal B]
 => "there'
=end
