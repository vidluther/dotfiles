if status is-interactive
 set SSH_AUTH_SOCK ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

    # Commands to run in interactive sessions can go here
end
starship init fish | source

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/vluther/.cache/lm-studio/bin

# Added by Windsurf
fish_add_path /Users/vluther/.codeium/windsurf/bin
