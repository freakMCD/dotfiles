{
  description = "My freaky nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-020425.url = "github:NixOS/nixpkgs/77b584d61ff80b4cef9245829a6f1dfad5afdfa3";

    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-020425, home-manager, ... }@inputs:
  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    stablePkgs = import nixpkgs-020425 { inherit system; };
  in
  {
    homeConfigurations.edwin = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        stablePkgs = stablePkgs;
      };
      modules = [
        ./home  # your ./home.nix file
      ];
    };

    nixosConfigurations.edwin = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ ./system ];
    };
  };
}
