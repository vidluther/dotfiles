#alias code='code-insiders'
alias wp="docker-compose run --rm wpcli"
alias wip='dig TXT +short o-o.myaddr.l.google.com @ns1.google.com' 
alias brewinstall='ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
alias bu='brew update'
alias bd='brew doctor'

# Aliases for ruby environment

alias newrubies='brew install rbenv ruby-build rbenv-gemset rbenv-vars rbenv-gem-rehash'
alias cleanrubies='brew uninstall rbenv ruby-build rbenv-gemset rbenv-vars rbenv-gem-rehash'
alias newbundler='rbenv exec gem install bundler'

# Start local jekyll server with dev file as option

alias lj='bundle exec jekyll s --config _config.yml,_config_dev.yml' 

