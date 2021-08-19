# Vid Luther's Dot Files

This is a collection of scripts and settings I use on my laptop/desktop environments. 

You can use these scripts for yourself but YMMV, if anything, use this is a starting point for your
own custom environment. Just as I have. 

### Inspiration

These settings, files have been curated over the years, and have been inspired by others like.

 - [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)
 - https://github.com/mathiasbynens/dotfiles

### Requirements / Pre-Requisites

Some things may not work on older laptops, as of this update **(December 21st 2020 aka The Great Conjunction)**, the dotfiles work on a default install of MacOS 11.1 Big Sur. 

In order for things to work, you must have your shell be Zsh, and you must have the Oh My Zsh package.

## Installation 

### bin

Some shell/ruby/python scripts that I use very often.

### fonts

Fonts that I use to make my life better in iTerm, these fonts are necessary
for the battery charge/github indicators to show properly in the zsh prompt.

##### Powerline Fonts 
Clone and install the fonts here https://github.com/powerline/fonts


### iterm

My iterm settings, and some themes I like. Basically, it's just the Pastel (Dark
Background colors preset, Incosolata for Powerline font)

### vidluther.zsh-theme

My custom theme for oh-my-zsh, credits/inspiration can be found within the file.

### githooks

Hooks I use/need often with git. 

## goacess.conf 
My config file for goaccess also references maxmind/geo stuff.
```zsh
 gunzip -c *.gz | goaccess - -p ~/dotfiles/goaccess.conf -o report.html 
```
