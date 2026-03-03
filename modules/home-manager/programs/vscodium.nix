{ pkgs, config, inputs, ... }:
{

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhs;

    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      enkia.tokyo-night
      ms-vscode.hexeditor
    ];

    userSettings = {
      "nix.enableLanguageServer" = true;
      "workbench.colorTheme" = "Tokyo Night Storm";
      "editor.autoIndentOnPaste" = true;
      "files.autoSave" = "afterDelay";
    };
  };
}
