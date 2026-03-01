{ config, pkgs, ... }: {

	boot.loader.systemd-boot = {
		enable = true;
		configurationLimit = 10;
	};

	boot.initrd.systemd.enable = true;

}
