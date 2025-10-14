{
  description = "System Configuration Flake";

  nixConfig.trusted-substituters = [ "https://hyprland.cachix.org" ];
  nixConfig.extra-trusted-public-keys = [
    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
  ];

  inputs = {
    hyprland.url = "github:hyprwm/Hyprland";
    hyprlock.url = "github:hyprwm/hyprlock";

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-generators,
      systems,
      treefmt-nix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      # Small tool to iterate over each systems
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});

      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager;
        }
      );

      homeConfigurations = (
        import ./home-manager/default.nix {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager;
        }
      );
      # packages.x86_64-linux = {
      #   laptop = nixos-generators.nixosGenerate {
      #     format = "iso";
      #     inherit system;
      #     specialArgs = {
      #       inherit inputs; # needed for hyprland and probs other stuff
      #       host = {
      #         hostName = "benlaptop";
      #       };
      #     };
      #     modules = [
      #       hosts/benlaptop
      #       hosts/common.nix
      #       hosts/modules
      #       ./custom-options.nix
      #     ];
      #   };
      # };
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

      checks = eachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
      });
    };
}
