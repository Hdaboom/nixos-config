{ config, pkgs, inputs, lib, ... }: {

	imports = [
		./cli/git.nix
		./programs/firefox.nix
		./programs/nvim.nix
		./shell/fish.nix
		./shell/kitty.nix

	];
}
