{ config, pkgs, ... }: {
	

	# enable network manager
	networking.networkmanager.enable = true;
	
	# enable bluetooth
	hardware.bluetooth.enable = true;

}
