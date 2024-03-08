{

   description = "nix-configurations";
    inputs = {
      nixpkgs = {
        url = "github:NixOS/nixpkgs?ref=master";
      };

      nix-darwin = {
        url = "github:LnL7/nix-darwin";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # Build a custom WSL installer
      nixos-wsl = {
        url = "github:nix-community/NixOS-WSL";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nil.url = "github:oxalica/nil";

      home-manager = {
        url = "github:nix-community/home-manager/release-23.11";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      flake-parts = {
        url = "github:hercules-ci/flake-parts";
        inputs.nixpkgs-lib.follows = "nixpkgs";
      };
      ez-configs = {
        url = "github:ehllie/ez-configs";
        inputs = {
          nixpkgs.follows = "nixpkgs";
          flake-parts.follows = "flake-parts";
        };
      };
      sops-nix = {
        url = "github:Mic92/sops-nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      agenix.url = "github:ryantm/agenix";
      agenix.inputs.nixpkgs.follows = "nixpkgs";

    };


    outputs = { self, nixpkgs, nix-darwin, nixos-wsl, home-manager, ... }@inputs:
    let


      home-manager.enable = true;
      home-manager.useGlobalPkgs = true;

      # Implement Global settings/home manager defaults for ALL machines by Vendor/Arch
      globalModules = [
        {
          system.configurationRevision = self.rev or self.dirtyRev or null;
        }
        ./global/default.nix
      ];


      globalModulesNixos = globalModules ++ [
        ./global/nixos.nix
        #home-manager.nixosModules.default
     ];

     globalModulesMacos = globalModules ++ [
       ./global/macos.nix
        #home-manager.darwinModules.default
     ];


   in
   {
     nixosHosts = nixpkgs.lib.attrNames ( nixpkgs.lib.filterAttrs (n: v: v == "directory") builtins.readDir ./nixos-hosts  );
     # refactor to loop nixosHosts
     nixosConfigurations = {
       christine = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = inputs;   # this is the @inputs from above
          modules = globalModulesNixos
          ++ [ ./nixos-hosts/christine/configuration.nix ];
       };
       enterprise = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = inputs;   # this is the @inputs from above
          modules = globalModulesNixos
          ++ [ ./nixos-hosts/enterprise/configuration.nix ];
      };
    };

    macosHosts = nixpkgs.lib.attrNames ( nixpkgs.lib.filterAttrs (n: v: v == "directory") builtins.readDir ./macos-hosts  );

    darwinConfigurations = {
      #hackinfrost = nix-darwin.lib.darwinSystem {
      #   system = "x86_64-darwin";
      #   modules = globalModulesMacos
      #     ++ [ ./hosts/hackinfrost/configuration.nix ];
      # };
      # silicontundra = nix-darwin.lib.darwinSystem {
      #   system = "aarch64-darwin";
      #   modules = globalModulesMacos
      #     ++ [ ./hosts/silicontundra/configuration.nix ];
      # };
    };
  };

}
