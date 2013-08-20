#chef-simple-nvm

A really simple chef cookbook for installing nvm on ubuntu.

This cookbook exposes two resources install and node_install.

## Install recipe

```
simple_nvm_install "install-nvm" do
  user  "a-user"
end
```

# Node install

```
simple_nvm_node_install "install-node" do
  user          "a-user"
  version       "v0.10.15"
  make_default  true
end
```
