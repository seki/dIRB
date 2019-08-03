require 'irb'
require 'drb/drb'

module IRB
  class WorkSpace
    include DRbUndumped
    def inspectors
      Inspector::INSPECTORS
    end
  end

  class Inspector
    include DRbUndumped
  end
end

class IRb
  def initialize
    # @workspace = IRB::WorkSpace.new(TOPLEVEL_BINDING)
    @workspace = IRB::WorkSpace.new()
  end
  attr_reader :workspace
end

if __FILE__ == $0
IRB.setup(eval("__FILE__"), argv: [])
DRb.start_service('druby://:54345', IRb.new)
DRb.thread.join
end
