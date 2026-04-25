{
  description = "vluther dotfiles — home-manager flake";

  inputs = {
    # Tracking nixpkgs-unstable to match the tools expected by home.nix
    # (e.g. oxfmt, which is not yet in the release-25.11 branch). The
    # flake.lock pins this to a specific commit for reproducibility.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (final: prev: {
            direnv = prev.direnv.overrideAttrs (_: { doCheck = false; });
          })
        ];
      };
    in {
      homeConfigurations.vluther = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./.config/home-manager/home.nix ];
      };
    };
}
