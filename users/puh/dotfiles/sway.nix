{ config, pkgs, ... }:

{
  home = {
    file = {
      sway_config = {
        source = ./sway-config;
        target = ".config/sway/myconfig";
	recursive = true;
      };
    };
  };
}
