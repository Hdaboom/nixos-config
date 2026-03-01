{ config, pkgs, inputs, ... }: {
	

	programs  = {
		git = {

			enable = true;

			settings.user = {
				name = "hdaboom";
				email = "hdaboom@gmail.com";
			};

			settings.init.defaultBranch = "main";
		};

		lazygit = {
			enable =true;
		};

		gh = {
			enable = true;
		};
	};
}
