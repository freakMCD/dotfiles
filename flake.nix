{
  description = "My freaky nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-unstable-small.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-020425.url = "github:NixOS/nixpkgs/77b584d61ff80b4cef9245829a6f1dfad5afdfa3";

    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fastanime = {
      url = "github:Benex254/fastanime";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixos-unstable-small, home-manager, fastanime, ... }@inputs:
  let system = "x86_64-linux";
    pkgs = import nixpkgs { system = "x86_64-linux"; };
    pkgs-small = import nixos-unstable-small { system = "x86_64-linux"; };
  in
  {
    homeConfigurations.edwin = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ({ config, pkgs, ... }: {
          # Make pkgs-small available to your home.nix module
          _module.args.pkgs-small = pkgs-small;
        })
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
