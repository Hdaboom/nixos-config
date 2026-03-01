{ config, pkgs, ... }: {

	hardware.graphics.enable = true;

	hardware.nvidia = {
		modesetting.enable = true;
		powerManagement.enable = true;
		open = true; # use open source
		nvidiaSettings = true;
		package = config.boot.kernelPackages.nvidiaPackages.stable;
	};
}
