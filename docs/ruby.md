layout: page
title: "Things to do with Ruby"
permalink: /ruby.html


# Getting The right Ruby Working locally. 

### Install Homebrew first

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
````

### Install rbenv

```
 brew install rbenv
 rbenv init 
 curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash
```

Make sure you modify the .zshrc to load rbenv on subsequent shells. Add this to the bottom of your .zshrc 

```
eval "$(rbenv init -)"
```

### Install the latest Ruby
Check what the latest version is at https://www.ruby-lang.org/en/

```
 rbenv install 3.0.1
 rbenv global 3.0.1
 ruby -v 
```
