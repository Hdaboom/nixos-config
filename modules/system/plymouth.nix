{ config, pkgs, inputs, ... }: {


	
	boot.plymouth = {
		enable = true;
		themePackages = [ pkgs.plymouth-blahaj-theme ];
		theme = "blahaj";
	};
}
