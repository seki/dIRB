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

    def puts(*opts)
      @stdout ? @stdout.puts(*opts) : super
    end
  end
end

class IRb
  def start(input_method, output_method, output)
    IRB.setup(__FILE__)
    irb = IRB::Irb.new(nil, input_method, output_method)
    irb.stdout = output
    Thread.new do
      irb.run()
    end
  end
end

if __FILE__ == $0
DRb.start_service('druby://:54345', IRb.new)
# IRB.start(__FILE__)
DRb.thread.join
end

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
