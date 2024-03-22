{
  description = "MCL NixOS installation media";
  inputs = {
        nixos = {
            url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";  
        };        
  };
    
  outputs = { self, nixos }: {
    nixosConfigurations = {
      mclMinimal = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
           "${self.outPath}/default.nix"
          ({ pkgs, ... }: {
            # environment.systemPackages = [ 
                
            # ];
          })
        ];
      };
    };
  };
}