if status is-interactive
    starship init fish | source
    # Commands to run in interactive sessions can go here
end

# change the $EDITOR variable
set -gx EDITOR hx

# Added by Antigravity
fish_add_path /Users/vluther/.antigravity/antigravity/bin

# pnpm
set -gx PNPM_HOME /Users/vluther/Library/pnpm
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
