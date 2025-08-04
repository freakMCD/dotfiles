{
  description = "My freaky nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-stable, home-manager, ... }@inputs:
  let 
    system = "x86_64-linux";
    stablePkgs = import nixpkgs-stable { inherit system; };
    pkgs = import nixpkgs {
      inherit system; 
      overlays = [
        (import ./overlays/stablePkgs.nix stablePkgs)
      ];
    };
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
      inherit system;
      specialArgs = { inherit inputs stablePkgs; };
      modules = [ 
        ./system
      ];
    };
  };
}
