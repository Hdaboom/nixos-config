{
	description = "My nix flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		firefox-addons = {
			url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { nixpkgs, ... } @ inputs:
	let
		system = "x86_64-linux";
		pkgs = nixpkgs.legacyPackages.${system};
	in
	{
		nixosConfigurations.icarus = nixpkgs.lib.nixosSystem {
			specialArgs = { inherit inputs; };
			modules = [
				./hosts/icarus/configuration.nix
				./modules/system
				inputs.home-manager.nixosModules.home-manager
			];
		};

	};
}
		
