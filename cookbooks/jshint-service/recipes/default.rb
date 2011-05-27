require_recipe "apt"
require_recipe "build-essential"

package "git-core"
package "libssl-dev"
package "curl"

user node[:deploy][:user] do
  shell "/bin/bash"
  home "/home/#{node[:deploy][:user]}"
  system true
end

log "cloning and building node"
execute "clone and build node" do
  command <<-CODE
git clone --depth 1 https://github.com/joyent/node.git
git checkout v0.4.8
cd node
./configure
make
  CODE

  cwd "/tmp"
  user node[:deploy][:user]
end

log "installing node"
execute "install node" do
  command "make install"
  cwd "/tmp/node"
end

log "installing npm"
execute "install npm" do
  command "curl http://npmjs.org/install.sh | clean=yes sh"
  not_if "which npm"
end

# setup deploy directory
directory node[:deploy][:dir] do
  owner node[:deploy][:user]
  recursive true
  not_if "test -e #{node[:deploy][:dir]}"
end

# TODO explodes despite running normally otherwise
log "installing express and deps to deployment directory"
execute "install express" do
  command "npm install express"
  cwd node[:deploy][:dir]
  user node[:deploy][:user]
  creates "#{node[:deploy][:dir]}/node_modules"
end
