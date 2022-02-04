{ config, pkgs, ... }:

{
  programs = {
    nix-index = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = true;
    };
    zsh = {
		enable = true;
        enableCompletion = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;
        shellGlobalAliases = {
          UUID = "$(uuidgen | tr -d \\n)";
          G = "| grep";
          fuck = "sudo !!";
        };
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
