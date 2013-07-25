include_recipe "sudo"
package "libshadow-ruby1.8"

chef_gem "ruby-shadow" do
  action :install
end

user "vm" do
  action :create
  home "/home/vm"
  password "$6$rR45kuEs$52XtXnmlMRdW4cHZ9mOmTlx/wtqhumRcYYxyecXepF0C1.lVcvkl7UFZJ3HwWDdaAXYu6Mm0e7t0SLzhdXqiN1"
  shell "/bin/bash"
  supports :manage_home => true
end

sudo "vm" do
  user "vm"
  nopasswd true
end
