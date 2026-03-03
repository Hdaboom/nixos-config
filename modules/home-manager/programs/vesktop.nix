{ config, pkgs, inputs, ... }: {

	programs.vesktop = {
		enable = true;
		vencord.themes = "https://refact0r.github.io/system24/build/system24.css";
	};
}
