{ config, pkgs, inputs, ... }: {

	programs.ssh = {
		startAgent = true;
	};

	services.openssh.enable = true;
}
