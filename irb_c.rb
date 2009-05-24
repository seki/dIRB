require 'drb/drb'
require 'irb'
require 'irb/input-method'

STDOUT.sync = true

IRB.setup(__FILE__)

DRb.start_service
im = IRB::StdioInputMethod.new
im.extend(DRbUndumped)

ro = DRbObject.new_with_uri('druby://localhost:54345')
th = ro.start(im, $stdout)
th.join
