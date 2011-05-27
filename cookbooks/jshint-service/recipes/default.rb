require_recipe "apt"
require_recipe "build-essential"

package "git-core"
package "libssl-dev"
package "curl"

execute "get and build node" do
  command <<-CODE
git clone --depth 1 https://github.com/joyent/node.git
git checkout v0.4.8
cd node
./configure
make
  CODE

  user "vagrant"
end

execute "install node" do
  command "make install"
  cwd "/tmp/node"
  user "root"
end

execute "install npm" do
  command <<-CODE
  curl http://npmjs.org/install.sh | sudo clean=yes sh
  CODE

  user "vagrant"
end

execute "install express" do
  command <<-CODE
  npm install express
  CODE

  cwd "/vagrant"
  user "vagrant"
end
