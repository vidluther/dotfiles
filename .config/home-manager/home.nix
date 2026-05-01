{ pkgs, ... }:

let
  starshipWeather = pkgs.writeShellScript "starship-weather" ''
    set -f
    cache=/tmp/claude/statusline-weather-cache.json
    max_age=3600
    mkdir -p /tmp/claude

    fresh=false
    if [ -f "$cache" ]; then
      mtime=$(stat -f %m "$cache" 2>/dev/null || stat -c %Y "$cache" 2>/dev/null)
      now=$(date +%s)
      if [ -n "$mtime" ] && [ $(( now - mtime )) -lt $max_age ] 2>/dev/null; then
        fresh=true
      fi
    fi

    if ! $fresh; then
      tmp=$(${pkgs.curl}/bin/curl -fsS --max-time 3 'https://wttr.in/?format=j1' 2>/dev/null) || tmp=""
      if [ -n "$tmp" ] && echo "$tmp" | ${pkgs.jq}/bin/jq -e '.current_condition[0]' >/dev/null 2>&1; then
        echo "$tmp" > "$cache"
      fi
    fi

    [ -f "$cache" ] || exit 0
    json=$(cat "$cache")
    echo "$json" | ${pkgs.jq}/bin/jq -e '.current_condition[0]' >/dev/null 2>&1 || exit 0

    code=$(echo "$json"  | ${pkgs.jq}/bin/jq -r '.current_condition[0].weatherCode // empty')
    tempF=$(echo "$json" | ${pkgs.jq}/bin/jq -r '.current_condition[0].temp_F // empty')
    tempC=$(echo "$json" | ${pkgs.jq}/bin/jq -r '.current_condition[0].temp_C // empty')
    city=$(echo "$json"  | ${pkgs.jq}/bin/jq -r '.nearest_area[0].areaName[0].value // empty')

    case "$code" in
      113) icon="☀️" ;;
      116) icon="⛅" ;;
      119|122) icon="☁️" ;;
      143|248|260) icon="🌫️" ;;
      176|263|266|293|296|353) icon="🌦️" ;;
      179|182|185|281|284|311|314|317|350|362|365|374|377) icon="🌧️" ;;
      200|386|389) icon="⛈️" ;;
      227|230|320|323|326|329|332|335|338|368|371|392|395) icon="🌨️" ;;
      299|302|305|308|356|359) icon="🌧️" ;;
      *) icon="🌡️" ;;
    esac

    [ -z "$tempF" ] && exit 0
    if [ -n "$tempC" ]; then
      temps=$(printf '%s°F · %s°C' "$tempF" "$tempC")
    else
      temps=$(printf '%s°F' "$tempF")
    fi
    if [ -n "$city" ]; then
      printf '%s %s  %s' "$icon" "$temps" "$city"
    else
      printf '%s %s' "$icon" "$temps"
    fi
  '';
in
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
    direnv
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
        body = "CLAUDE_CONFIG_DIR=\"$HOME/.claude-work\" claude $argv";
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
        "$bun"
        "$rust"
        "$golang"
        "$php"
        "$python"
        "[](fg:#161b22 bg:#0d1117)"
        "\${custom.weather}"
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

      bun = {
        symbol = "🥟";
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
        disabled = true;
        time_format = "%R";
        style = "bg:#161b22";
        format = "[[  $time ](fg:#79c0ff bg:#161b22)]($style)";
      };

      custom.weather = {
        command = "${starshipWeather}";
        when = "true";
        shell = [ "bash" "--noprofile" "--norc" ];
        style = "bg:#161b22";
        format = "[[ $output ](fg:#79c0ff bg:#161b22)]($style)";
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
