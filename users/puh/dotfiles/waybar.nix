{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
  };

  home = {
    file = {
      waybar_config = {
        source = ./waybar;
        target = ".config/waybar";
        recursive = true;
      };
    };
  };
}
