{
  inputs = {
    system-config-private.url = "git+https://github.com/NyanCatForEver/system-config-private.git";

    nixpkgs.url = "https://channels.nixos.org/nixos-26.05/nixexprs.tar.zst";
    nixpkgs-unstable.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";

    nixpkgs-patcher.url = "github:gepbird/nixpkgs-patcher";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix-unstable = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    helium = {
      url = "github:amaanq/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    i915-sriov-dkms = {
      url = "github:strongtz/i915-sriov-dkms?ref=2026.11.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs-patcher,
      ...
    }@inputs:
    let
      overlay = {
        nixpkgs.overlays = [
          (
            final: prev:
            let
              system = final.stdenv.hostPlatform.system;
            in
            {
              helium = inputs.helium.packages.${system}.default;
              agenix = inputs.agenix.packages.${system}.default;
            }
          )
        ];
      };

      nixosSystem =
        hostName:
        {
          nixpkgs ? inputs.nixpkgs,
          patches ? _: [ ],
          modules ? [ ],
        }:
        nixpkgs-patcher.lib.nixosSystem {
          modules = modules ++ [
            overlay
            ./common
            ./hosts/${hostName}/configuration.nix
            ./hosts/${hostName}/hardware-configuration.nix
          ];

          specialArgs = {
            inherit hostName;
            modules = category: paths: map (path: ./modules/${category}/${path}) paths;
            private = inputs.system-config-private.private.hosts.${hostName};
          };
          nixpkgsPatcher = { inherit inputs nixpkgs patches; };
        };

      systems = {
        homenix.modules = [
          inputs.agenix.nixosModules.default
          inputs.i915-sriov-dkms.nixosModules.default
        ];
        nixpad = {
          nixpkgs = inputs.nixpkgs-unstable;
          modules = [ inputs.agenix-unstable.nixosModules.default ];
        };
        nixyan = {
          nixpkgs = inputs.nixpkgs-unstable;
          modules = [ inputs.agenix-unstable.nixosModules.default ];
        };
      };
    in
    {
      nixosConfigurations = builtins.mapAttrs nixosSystem systems;
    };
}
