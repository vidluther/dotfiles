alias brewinstall='ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
alias bu='brew update'
alias bd='brew doctor'


# Vagrant / Vmware stuff

alias 'kl'='kitchen list'
alias cb='rm -rf ~/.berkshelf/'
alias ck='rm -rf .kitchen'
alias kv='kitchen verify '
alias kc='kitchen converge '


alias makebox_vmware='packer build -var 'chef_version=latest' -only=vmware-iso '
alias makebox_virtualbox='packer build -var 'chef_version=latest' -only=virtualbox-iso '
alias boxadd='vagrant box add '
