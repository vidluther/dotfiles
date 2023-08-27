DOTFILES=$HOME/dotfiles
#alias code='code-insiders'
alias wp="docker-compose run --rm wpcli"
alias wip='dig TXT +short o-o.myaddr.l.google.com @ns1.google.com' 
alias brewinstall='ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
alias bu='brew update'
alias bd='brew doctor'
alias getspaceship='git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1'
alias usespaceship='ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"'
alias lcc='php artisan optimize && php artisan view:clear'
alias startmongod='mongod --config /usr/local/etc/mongod.conf'
alias python='/usr/local/bin/python3.11'
# Aliases for ruby environment

alias newrubies='brew install rbenv ruby-build rbenv-gemset rbenv-vars'
alias cleanrubies='brew uninstall rbenv ruby-build rbenv-gemset rbenv-vars'
alias newbundler='rbenv exec gem install bundler'

# Start local jekyll server with dev file as option
alias lj='bundle exec jekyll s --config _config.yml,_config_dev.yml --drafts' 
alias ljnd='bundle exec jekyll s --config _config.yml,_config_dev.yml ' 

#preview test jekyll
alias ptj='export JEKYLL_ENV=test; bundle exec jekyll s --config _config.yml,_config_test.yml' 

# generate test.luther.io
alias build_test='export JEKYLL_ENV=test; bundle exec jekyll build --config _config.yml,_config_test.yml -d ./_to_cloudflare/ ' 

# generate static files to be deployed at cloudflare worker sites https://luther.io
alias build_lio_prod='export JEKYLL_ENV=production; bundle exec jekyll build --config _config.yml,_config_prod.yml -d ./_prod_to_cloudflare/ ' 


# alias code='/usr/local/bin/code-insiders' 
alias sail='[ -f sail ] && bash sail || bash vendor/bin/sail'
source $DOTFILES/aws.cli

# One Password CLI stuff
OP_BIOMETRIC_UNLOCK_ENABLED=true
source /Users/vluther/.config/op/plugins.sh
