{ config, pkgs, ... }: {
	

	imports = [
	./boot.nix
	./plymouth.nix
	./networking.nix
	./kernel.nix
	./nvidia.nix
	./ssh.nix

	];
}
