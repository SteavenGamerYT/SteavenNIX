{
  description = "SteavenNIX - A modern NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    
    # Additional inputs
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    # Development tools
    nil.url = "github:oxalica/nil";
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    
    # System utilities
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, chaotic, nix-flatpak, nixos-hardware, nil, alejandra, nix-index-database, ... } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      unstable = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      
      # Common configuration for all systems
      commonConfig = {
        nixpkgs.config.allowUnfree = true;
        nix.settings = {
          experimental-features = [ "nix-command" "flakes" ];
          auto-optimise-store = true;
          trusted-users = [ "root" "omarhanykasban" ];
        };
        nix.gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 30d";
        };
      };
    in {
      nixosConfigurations = {
        "Omar-GamingLaptop" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            nix-flatpak.nixosModules.nix-flatpak
            chaotic.nixosModules.nyx-cache
            chaotic.nixosModules.nyx-overlay
            chaotic.nixosModules.nyx-registry
            nix-index-database.nixosModules.nix-index

            {
              _module.args = {
                unstable = unstable;
              };
            }
          ] ++ [
            commonConfig
          ];
        };
      };

      # Development shell
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nil
          alejandra
          nixpkgs-fmt
        ];
      };
    };
}
