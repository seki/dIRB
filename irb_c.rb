require 'drb/drb'
require 'irb'

module IRB
  class Context
    alias org_inspect_mode inspect_mode=
    def inspect_mode=(opt)
      if opt == true
        @inspect_method = @workspace.inspectors[opt]
        @inspect_method.init
        @inspect_mode = opt
      else 
        org_inspect_mode(opt)
      end
    end
  end
end

DRb.start_service

IRB.setup(eval("__FILE__"), argv: [])
ro = DRbObject.new_with_uri('druby://localhost:54345')
workspace = ro.workspace
# STDOUT.print(workspace.code_around_binding)
IRB::Irb.new(workspace).run(IRB.conf)
