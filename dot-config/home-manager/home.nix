{ config, pkgs, ... }:

{
  home.username = "vluther";
  home.homeDirectory = "/Users/vluther";
  home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  # ---------------------------------------------------------------------------
  # Packages
  # ---------------------------------------------------------------------------
  home.packages = with pkgs; [
    eza
    ripgrep
    jq
    gh
    neovim
    fnm
    pnpm

  oxlint
  oxfmt
 # Nerd Fonts
  nerd-fonts.fira-code
  nerd-fonts.fira-mono
  nerd-fonts.droid-sans-mono
  nerd-fonts.hack
  nerd-fonts.inconsolata
  nerd-fonts.inconsolata-go
  nerd-fonts.inconsolata-lgc
  nerd-fonts.jetbrains-mono
  nerd-fonts.meslo-lg
  nerd-fonts.monofur
  nerd-fonts.profont
  nerd-fonts.roboto-mono
  nerd-fonts.sauce-code-pro
  nerd-fonts.shure-tech-mono
  nerd-fonts.space-mono
  nerd-fonts.terminess-ttf
  nerd-fonts.ubuntu
  nerd-fonts.ubuntu-mono
  nerd-fonts.heavy-data
  nerd-fonts.go-mono
  nerd-fonts.code-new-roman


];

  # ---------------------------------------------------------------------------
  # Session variables
  # ---------------------------------------------------------------------------
  home.sessionVariables = {
    EDITOR = "nvim";
    PNPM_HOME = "/Users/vluther/Library/pnpm";
  };

  # ---------------------------------------------------------------------------
  # Git
  # ---------------------------------------------------------------------------
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Vid Luther";
        email = "vid@luther.io";
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAMtjt4Zl7OHuqa2nidi85ch6Ghm3O7n0/d4rp9F3ieW";
      };
      commit.gpgsign = true;
      gpg = {
        format = "ssh";
        ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
      gitbutler = {
        aiModelProvider = "openai";
        aiAnthropicKeyOption = "butlerAPI";
        aiOpenAIKeyOption = "butlerAPI";
      };
    };
  };

  # Global gitignore
  xdg.configFile."git/ignore".text = ''
    **/.claude/settings.local.json
    .config/zed/conversations/*
    .config/zed/prompts/*
  '';

  # ---------------------------------------------------------------------------
  # SSH
  # ---------------------------------------------------------------------------
 programs.ssh = {
  enable = true;
  enableDefaultConfig = false;
  matchBlocks."*" = {
    extraOptions = {
      IdentityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
    };
  };
};
  # ---------------------------------------------------------------------------
  # Fish shell
  # ---------------------------------------------------------------------------
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      starship init fish | source
    '';

    shellInit = ''
      fish_add_path /nix/var/nix/profiles/default/bin
      fish_add_path $HOME/.nix-profile/bin
      fish_add_path /Users/vluther/.antigravity/antigravity/bin
      fish_add_path $HOME/.local/bin
      fish_add_path $PNPM_HOME
    '';

    functions = {
      fish_prompt = {
        description = "Write out the prompt";
        body = ''
          set -l last_status $status
          set -l normal (set_color normal)
          set -l status_color (set_color brgreen)
          set -l cwd_color (set_color $fish_color_cwd)
          set -l vcs_color (set_color brpurple)
          set -l prompt_status ""
          set -q fish_prompt_pwd_dir_length
          or set -lx fish_prompt_pwd_dir_length 0
          set -l suffix '❯'
          if functions -q fish_is_root_user; and fish_is_root_user
            if set -q fish_color_cwd_root
              set cwd_color (set_color $fish_color_cwd_root)
            end
            set suffix '#'
          end
          if test $last_status -ne 0
            set status_color (set_color $fish_color_error)
            set prompt_status $status_color "[" $last_status "]" $normal
          end
          echo -s (prompt_login) ' ' $cwd_color (prompt_pwd) $vcs_color (fish_vcs_prompt) $normal ' ' $prompt_status
          echo -n -s $status_color $suffix ' ' $normal
        '';
      };

      vim = {
        wraps = "nvim";
        description = "alias vim nvim";
        body = "nvim $argv";
      };
    };
  };

  # ---------------------------------------------------------------------------
  # Fish conf.d — fnm
  # ---------------------------------------------------------------------------
  xdg.configFile."fish/conf.d/fnm.fish".text = ''
    fnm env --use-on-cd --version-file-strategy=recursive --shell fish | source
  '';

  # ---------------------------------------------------------------------------
  # Starship
  # ---------------------------------------------------------------------------
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
      };
      package.disabled = true;
    };
  };

  # ---------------------------------------------------------------------------
  # gh CLI
  # ---------------------------------------------------------------------------
  xdg.configFile."gh/config.yml".text = ''
    version: 1
    git_protocol: https
    editor:
    prompt: enabled
    prefer_editor_prompt: disabled
    pager:
    aliases:
        co: pr checkout
    http_unix_socket:
    browser:
    color_labels: disabled
    accessible_colors: disabled
    accessible_prompter: disabled
    spinner: enabled
  '';

  xdg.configFile."gh/hosts.yml".text = ''
    github.com:
        git_protocol: https
        users:
            vidluther:
        user: vidluther
  '';

  xdg.configFile."1Password/ssh/agent.toml".text = ''
  [[ssh-keys]]
  vault = "Private"
  [[ssh-keys]]
  vault = "Employee"
  [[ssh-keys]]
  vault = "SSH"
'';
}
