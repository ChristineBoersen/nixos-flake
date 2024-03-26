{

   description = "nix-configurations";
    inputs = {
      nixpkgs = {
        url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";
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

      nix-colors = {
        url = "github:misterio77/nix-colors";
      };

    };


    outputs = { self, nixpkgs, nix-darwin, nixos-wsl, home-manager, nix-colors, ... }@inputs:
    let

      #inherit home-manager;

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
    
    getDirNames = searchPath: (nixpkgs.lib.attrNames ( nixpkgs.lib.filterAttrs (n: v: v == "directory") (builtins.readDir  searchPath  )));
    hasSubDir = searchPath: dirName: ( builtins.any ( getDirNames "${searchPath}/${dirName}" ));
    getHostPaths = searchPath: 
      let             
        hostsOrDomains = getDirNames searchPath; 
        domains = builtins.filter (name: hasSubDir searchPath name) hostsOrDomains;
      in {
        hosts = builtins.filter (name: !(hasSubDir searchPath name) ) hostsOrDomains
                  ++ map (domain: ( getDirNames "./${searchPath}/${domain}" )) domains;                  
      };
    
     # produces a list of folder names in nixos-hosts and macos-hosts

    nixosHosts = getHostPaths "./nixos-hosts";
    macosHosts = getHostPaths "./macos-hosts";

   in
   {
     
      # instead of explicitly lists hosts like most examples do, we iterate nixosHosts to convert to an attrSet and output a nixosSystem
      nixosConfigurations = (nixpkgs.lib.listToAttrs 
        (
          nixpkgs.lib.lists.forEach nixosHosts 
          (
            hostName: { 
              name = "${hostName}";
              value = nixpkgs.lib.nixosSystem {          
                specialArgs = inputs;   # this is the @inputs from above
                modules = globalModulesNixos
                ++ [ ./nixos-hosts/${hostName}/configuration.nix ];
              };
            }
          )
        )
    );
    

    # Keep this as example of manual configuration. The forEach above replaces the need for manually specifying
    #  nixosConfigurations = {
    #    christine = nixpkgs.lib.nixosSystem {
    #       system = "x86_64-linux";
    #       specialArgs = inputs;   # this is the @inputs from above
    #       modules = globalModulesNixos
    #       ++ [ ./nixos-hosts/christine/configuration.nix ];
    #    };
    #    enterprise = nixpkgs.lib.nixosSystem {
    #       system = "x86_64-linux";
    #       specialArgs = inputs;   # this is the @inputs from above
    #       modules = globalModulesNixos
    #       ++ [
    #           ./nixos-hosts/enterprise/configuration.nix
    #         ];
    #   };
    # };

    # instead of explicitly lists hosts like most examples do, we iterate nixosHosts to convert to an attrSet and output a nixosSystem
      darwinConfigurations = (nixpkgs.lib.listToAttrs (nixpkgs.lib.lists.forEach macosHosts (hostName:
       { 
        name = "${hostName}";
        value = nixpkgs.lib.nixosSystem {
          #system = "x86_64-darwin";
          specialArgs = inputs;   # this is the @inputs from above
          modules = globalModulesMacos
          ++ [ ./macos-hosts/${hostName}/configuration.nix ];
        };
       }
     )));

    
  };

}
