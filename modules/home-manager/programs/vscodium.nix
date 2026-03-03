{ pkgs, config, inputs, ... }:
{

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhs;

    extensions = with pkgs.vscode-extensions; [

    ];

    userSettings = {
      "nix.enableLanguageServer" = true;
    };
  };
}
