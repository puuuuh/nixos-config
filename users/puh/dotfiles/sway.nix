{ config, pkgs, ... }:

{
  home = {
    file = {
      sway_config = {
        source = ./config.backup;
        target = ".config/sway/myconfig";
	recursive = true;
      };
    };
  };
}
