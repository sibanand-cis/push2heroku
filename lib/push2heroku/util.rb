class Util

  def self.hard_push?(base)
    remote_branch_name = "h#{base.branch_name}"

    # do hard push only when expicitly asked
    # base.hard || !remote_branch_exists?(remote_branch_name)
    base.hard
  end

  def self.new_install?(base)
    remote_branch_name = "h#{base.branch_name}"
    !remote_branch_exists?(remote_branch_name)
  end

  def self.remote_branch_exists?(remote_branch_name)
   out = `cd #{Rails.root.expand_path} && git branch -r`
   out.include?(remote_branch_name)
  end

end
