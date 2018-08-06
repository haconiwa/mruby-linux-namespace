module Namespace
  FLAG_MAP = {
    :mnt => CLONE_NEWNS,
    :mount => CLONE_NEWNS,
    :uts => CLONE_NEWUTS,
    :ipc => CLONE_NEWIPC,
    :pid => CLONE_NEWPID,
    :net => CLONE_NEWNET,
    :user => CLONE_NEWUSER
  }
  if Namespace.const_defined? :CLONE_NEWCGROUP
    FLAG_MAP[:cgroup] = CLONE_NEWCGROUP
  end
  FLAG_MAP.freeze

  def self.resolve_flag(flg_exp)
    if flg_exp.is_a?(Integer)
      return flg_exp
    else
      FLAG_MAP.fetch(flg_exp.to_sym)
    end
  end
end
