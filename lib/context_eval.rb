require 'context_eval/version'

module ContextEval
  def context_eval(*args)
    arg = args.shift

    case arg
    when Symbol
      send(arg)
    when Proc
      if arg.arity == 0
        instance_exec(&arg)
      elsif arg.arity > 0
        instance_exec(*args.take(arg.arity), &arg)
      else
        instance_exec(*args, &arg)
      end
    else
      arg
    end
  end
end

Object.send(:include, ContextEval)
