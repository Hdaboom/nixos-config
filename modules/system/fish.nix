{ config, pkgs, inputs, ... }: {


	programs.fish = {
		enable = true;
	};

	users.users.hdaboom.shell = pkgs.fish;
}
