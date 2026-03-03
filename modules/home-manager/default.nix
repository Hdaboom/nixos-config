{ config, lib, pkgs, ... }:

let
  cfg = config.myOptions;
in {
  ## 1. Define the Toggles
  options.myOptions = {
    browser     = lib.mkEnableOption "Web browsers";
    development = lib.mkEnableOption "Development tools";
    gaming      = lib.mkEnableOption "Gaming configuration";
    social	= lib.mkEnableOption "Social Applications";
    allCli      = lib.mkEnableOption "All CLI tools";
    allShell    = lib.mkEnableOption "All shell utilities";
    allPrograms = lib.mkEnableOption "All GUI programs";
    everything  = lib.mkEnableOption "Enable every single module";
  };

  ## 2. Unconditional Imports (Prevents Infinite Recursion)
  imports = [
    ./cli/git.nix
    ./programs/firefox.nix
    ./programs/nvim.nix
    ./programs/vscodium.nix
    ./programs/vesktop.nix
    ./shell/fish.nix
    ./shell/kitty.nix
  ];

  ## 3. Remote Logic Injection
  # This wraps the imported files in mkIf WITHOUT modifying the files themselves.
  config = lib.mkMerge [
    # CLI
    (lib.mkIf (!(cfg.allCli || cfg.everything || cfg.development)) {
      # This is the "Inverse" trick: if the option is NOT 
      # enabled, we force the programs in those files to be disabled.
      programs.git.enable = lib.mkForce false;
    })

    # Programs
    (lib.mkIf (!(cfg.browser || cfg.allPrograms || cfg.everything)) {
      programs.firefox.enable = lib.mkForce false;
    })

    (lib.mkIf (!(cfg.social || cfg.allPrograms || cfg.everything)) {
    	programs.vesktop.enable = lib.mkForce false;
    })
    
    (lib.mkIf (!(cfg.development || cfg.allPrograms || cfg.everything)) {
      programs.neovim.enable = lib.mkForce false;
      programs.vscode.enable = lib.mkForce false;
    })

    # Shell
    (lib.mkIf (!(cfg.allShell || cfg.everything)) {
      programs.fish.enable = lib.mkForce false;
      programs.kitty.enable = lib.mkForce false;
    })

    # Gaming (Direct Config)
   # (lib.mkIf (cfg.gaming || cfg.everything) {})
  ];
}
