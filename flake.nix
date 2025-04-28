{
  description = "SteavenNixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };

  outputs = { self, nixpkgs, chaotic, nix-flatpak, ... }: {
    nixosConfigurations = {
      "Omar-PC" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          nix-flatpak.nixosModules.nix-flatpak
          chaotic.nixosModules.nyx-cache
          chaotic.nixosModules.nyx-overlay
          chaotic.nixosModules.nyx-registry
        ];
      };
    };
  };
}
