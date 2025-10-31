{
  description = "My freaky nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stevenblack = {
      url = "github:StevenBlack/hosts";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system; 
    };
  in
  {
    homeConfigurations.edwin = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./home  # your ./home.nix file
      ];
    };

    nixosConfigurations.edwin = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [ 
        ./system
      ];
    };
  };
}
