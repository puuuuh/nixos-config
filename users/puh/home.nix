{ config, pkgs, lib, ... }:

let 
proximity-sort = pkgs.rustPlatform.buildRustPackage rec {
    pname = "proximity-sort";
    version = "v1.0.7";

    src = pkgs.fetchFromGitHub {
        owner = "jonhoo";
        repo = pname;
        rev = version;
        sha256 = "0d4068pkcfmcshxwkmwzlf4jyhfpilvf93m3lc1gjr8kc7jbhcb4";
    };

    cargoSha256 = "02n6h7zwnxmlw2w534yldl9sr6adhy9g4ba15x30j7bizbm6gbl2";

    meta = with lib; {
        description = "Simple command-line utility for sorting inputs by proximity to a path argument";
        homepage = "https://github.com/jonhoo/proximity-sort";
        license = licenses.mit;
    };
};
in
{

    imports = [
        ./dotfiles/zsh.nix
        ./dotfiles/sway.nix
            ./dotfiles/git.nix
            ./dotfiles/tmux.nix
            ./dotfiles/neovim.nix
            ./dotfiles/waybar.nix
        ../../services/keepass-mount.nix
    ];

    fonts.fontconfig.enable = true;

    home = {
        packages = with pkgs; [
            htop
                discord
                keepassxc
                tdesktop
                noto-fonts
                noto-fonts-cjk
                noto-fonts-emoji
                liberation_ttf
                fira-code
                fira-code-symbols
                mplus-outline-fonts
                (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "SourceCodePro" ]; })
                emacsPgtkGcc
                spotify
                sshfs
                asciinema
                aspell
                aspellDicts.en
                tldr
                procs
                gitAndTools.gh
                git-crypt
                git-lfs
                gtop
                unstable.btop
                bpytop
                tree
                ripgrep
                file
                binutils
                fd
                proximity-sort
                trash-cli
                mosh
                highlight
                nix-index
                yarn
                nixpkgs-fmt
                nixpkgs-review
                pypi2nix
                nodePackages.node2nix
                unstable.python39Packages.poetry

                (python39.withPackages (ps: with ps; [
                                        pip
                                        powerline
                                        pygments
                                        pynvim
                ]))
                swaylock
                swayidle
                wl-clipboard
                mako # notification daemon
                alacritty # Alacritty is the default terminal in the config
                rofi
                sway-contrib.grimshot
                xdg-user-dirs
                libnotify
                ];
    };

    wayland.windowManager.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        extraOptions = [
            "--my-next-gpu-wont-be-nvidia"
            "--config"
            "${config.home.homeDirectory}/.config/sway/myconfig"
        ];
        extraSessionCommands = ''
# SDL:
            export SDL_VIDEODRIVER=wayland
# QT (needs qt5.qtwayland in systemPackages):
            export QT_QPA_PLATFORM=wayland-egl
            export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
# Fix for some Java AWT applications (e.g. Android Studio),
# use this if they aren't displayed properly:
            export _JAVA_AWT_WM_NONREPARENTING=1
            '';
    };


    programs = {
        home-manager.enable = true;
        gpg.enable = true;
        fzf.enable = true;
        jq.enable = true;
        bat.enable = true;
        command-not-found.enable = true;
        dircolors.enable = true;
        htop.enable = true;
        info.enable = true;
        exa.enable = true;


        direnv = {
            enable = true;
            nix-direnv = {
                enable = true;
                enableFlakes = true;
            };
        };
    };

    programs.urxvt = {
      enable = false;
    };

    gtk.theme = {
        package = pkgs.flat-remix-gtk;
        name = "flat-remix-gtk";
    };

    xsession.pointerCursor = {
        package = pkgs.numix-cursor-theme;
        name = "Numix-Cursor";
    };

    services = {
        lorri.enable = true;
        gpg-agent = {
            enable = true;
            enableSshSupport = true;
        };
        keepass-mount = {
            enable = true;
        };
    };
}
