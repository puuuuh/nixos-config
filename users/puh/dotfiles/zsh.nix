{ config, pkgs, ... }:

{
  programs = {
    zsh = {
		enable = true;
		shellAliases = {
			ll = "ls -l";
			update = "sudo nixos-rebuild switch";
			uupdate = "home-manager switch --flake ~/.config/nixpkgs/#$USER -v";
		};
		history = {
			size = 10000;
			path = "${config.xdg.dataHome}/zsh/history";
		};
		oh-my-zsh = {
			enable = true;
			plugins = [ "git" "docker" ];
			theme = "robbyrussell";
		};
    };
  };
}
