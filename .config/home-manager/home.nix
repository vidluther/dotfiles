{ pkgs, ... }:

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
    ruby

    oxlint
    oxfmt
    nixd
    nil

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
  # mise
  # ---------------------------------------------------------------------------
  programs.mise = {
    enable = true;
    enableFishIntegration = true;
  };

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

    shellInit = ''
      fish_add_path /nix/var/nix/profiles/default/bin
      fish_add_path $HOME/.nix-profile/bin
      fish_add_path /Users/vluther/.antigravity/antigravity/bin
      fish_add_path $HOME/.local/bin
      fish_add_path $HOME/.opencode/bin
      fish_add_path $PNPM_HOME
      set -gx OPENCODE_EXPERIMENTAL_OXFMT true
    '';

    functions = {
      vim = {
        wraps = "nvim";
        description = "alias vim nvim";
        body = "nvim $argv";
      };

      npm = {
        wraps = "pnpm";
        description = "alias npm pnpm";
        body = "pnpm $argv";
      };

      claude-work = {
        wraps = "claude";
        description = "alias claude-work claude";
        body = "CLAUDE_CONFIG_DIR="$HOME/.claude-work  claude $argv";
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

      format = builtins.concatStringsSep "" [
        "[](fg:#1f6feb)"
        "[  ](bg:#1f6feb fg:#ffffff)"
        "[](bg:#161b22 fg:#1f6feb)"
        "$directory"
        "[](fg:#161b22 bg:#0d1117)"
        "$git_branch"
        "$git_status"
        "[](fg:#0d1117)"
        "$fill"
        "[](fg:#0d1117)"
        "$nodejs"
        "$rust"
        "$golang"
        "$php"
        "$python"
        "[](fg:#161b22 bg:#0d1117)"
        "$time"
        "[](fg:#161b22)"
        "\n$character"
      ];

      fill.symbol = " ";

      directory = {
        style = "fg:#ffffff bg:#161b22";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = ".../";
        substitutions = {
          Documents = "󰈙 ";
          Downloads = " ";
          Music = " ";
          Pictures = " ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:#0d1117";
        format = "[[ $symbol $branch ](fg:#3fb950 bg:#0d1117)]($style)";
      };

      git_status = {
        style = "bg:#0d1117";
        format = "[[($all_status$ahead_behind )](fg:#f78166 bg:#0d1117)]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:#0d1117";
        format = "[[ $symbol ($version) ](fg:#58a6ff bg:#0d1117)]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:#0d1117";
        format = "[[ $symbol ($version) ](fg:#58a6ff bg:#0d1117)]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:#0d1117";
        format = "[[ $symbol ($version) ](fg:#58a6ff bg:#0d1117)]($style)";
      };

      php = {
        symbol = "";
        style = "bg:#0d1117";
        format = "[[ $symbol ($version) ](fg:#58a6ff bg:#0d1117)]($style)";
      };

      python = {
        symbol = "";
        style = "bg:#0d1117";
        format = "[[ $symbol ($version) ](fg:#58a6ff bg:#0d1117)]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#161b22";
        format = "[[  $time ](fg:#79c0ff bg:#161b22)]($style)";
      };

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
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
