{ config, pkgs, ... }:

{
  programs = {
    zsh = {
		enable = true;
		shellAliases = {
			ll = "ls -l";
            update = "sudo nixos-rebuild switch --flake ~/.config/nixpkgs/#\$(hostname)";
			uupdate = "home-manager switch --flake ~/.config/nixpkgs/#$USER -v";
		};
		history = {
			size = 10000;
			path = "${config.xdg.dataHome}/zsh/history";
		};
    loginExtra = "
if [[ -z $DISPLAY && $TTY = /dev/tty1 ]]; then
  exec dbus-run-session -- sway
fi
";
		oh-my-zsh = {
			enable = true;
			plugins = [ "git" "docker" "docker-compose" "adb" "rust" ];
			theme = "robbyrussell";
		};
    };
  };
}
