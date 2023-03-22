{
  description = "A very basic flake";
  
  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-22.11";};

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors = { url = "github:misterio77/nix-colors"; };

    # nix-gaming = { url = "github:fufexan/nix-gaming"; };

    nixvim = {
      url = "github:pta2002/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    }; 

  };

  outputs = { self, nixpkgs, nix-colors, nixvim, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

      lib = nixpkgs.lib;

    in {
      nixosConfigurations = {
        lxvrns = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs self nix-colors; 
        };

        modules = [
          ./hosts/lxvrns/configuration.nix

          home-manager.nixosModules.home-manager {
            home-manager = {

              extraSpecialArgs = {
                inherit inputs self nix-colors; 
              };

              useUserPackages = true;
              useGlobalPkgs = true;
              users.lxvrns = { 
                imports = [ 
                    ./users/lxvrns
	                inputs.nixvim.homeManagerModules.nixvim
	              ];
	            };
            }; 
	        }

        ];

      };   

    };
  };
}
