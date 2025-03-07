{
  description = "My freaky nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fastanime = {
      url = "github:Benex254/fastanime";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, fastanime, ... }@inputs: {
    homeConfigurations.edwin = home-manager.lib.homeManagerConfiguration {
     pkgs = import nixpkgs {
        system = "x86_64-linux";
     };
     modules = [
        ./home
        ./theme.nix
        ./theme
     ];
    };

    nixosConfigurations.edwin = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./system
      ];
    };
  };
}
