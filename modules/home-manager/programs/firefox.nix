{ config, pkgs, inputs, ... }: {

	programs.firefox = {
		enable = true;
		profiles.hdaboom = {
			
			bookmarks = [	
				{ 
				name = "Bookmarks Toolbar";
				toolbar = true;
				bookmarks = [

					{ name = "Youtube"; url = "https://youtube.com"; }
					{ name = "AnimeKai"; url = "https://animekai.to/home"; }
					{ name = "Anilist"; url = "https://anilist.co/home"; }
					{ name = "Comick"; url =  "https://comick.io/home2"; }
					{ name = "Mangafire"; url = "https://managafire.to/home"; }
					{ name = "Reddit"; url = "https://reddit.com"; }
					{ name = "Piracy megathread"; url = "https://old.reddit.com/r/piracy/wiki/megathread"; }
					{ name = "HydraHD"; url = "https://hydrahd.ru"; }
					{ name = "Apple Music"; url = "music.apple.com/gb/search"; }
					{ name = "Google Gemini"; url = "https://gemini.google.com"; }
					];
				}
			];

			settings = {
				"extensions.autoDisableScopes" = 0;
			};

			extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
				ublock-origin
				bitwarden
				istilldontcareaboutcookies
				sponsorblock
			];
		};
	};
}
