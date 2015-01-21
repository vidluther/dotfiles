alias brewinstall='ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
alias bu='brew update'
alias bd='brew doctor'

# Aliases for ruby environment

alias newrubies='brew install rbenv ruby-build rbenv-gemset rbenv-vars rbenv-gem-rehash'
alias cleanrubies='brew uninstall rbenv ruby-build rbenv-gemset rbenv-vars rbenv-gem-rehash'
alias newbundler='rbenv exec gem install bundler'

# Vagrant / Vmware stuff

alias kl='kitchen list'
alias cb='rm -rf ~/.berkshelf/'
alias ck='rm -rf .kitchen'
alias kv='kitchen verify '
alias kc='kitchen converge '
alias kd='kitchen destroy'

alias iad='export RACKSPACE_REGION="iad" '
alias ord='export RACKSPACE_REGION="ord" ; export OS_REGION_NAME='ORD' '
alias kr='knife rackspace'

alias kll='kitchen login '

#alias git='hub'

alias rbex='rbenv exec '
alias be='bundle exec '
alias bi='bundle install '

alias makebox_vmware='packer build -var 'chef_version=$chef_client_version' -only=vmware-iso '
alias makebox_virtualbox='packer build -var 'chef_version=$chef_client_version' -only=virtualbox-iso '
alias boxadd='vagrant box add '
