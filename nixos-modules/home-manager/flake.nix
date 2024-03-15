{
  # ...
  outputs = { self, nixpkgs, home-manager }:
    let
      # ...
    in {
      # ...
      nixosModules = {
        # ...
        declarativeHome = { ... }: {
          config = {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          };
        };
      };
    };
}