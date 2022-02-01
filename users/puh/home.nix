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
    python-telegram = pkgs.python3Packages.buildPythonApplication rec {
        pname = "python-telegram";
        version = "0.14.0";

        src = pkgs.fetchFromGitHub {
            owner = "alexander-akhmetov";
            repo = pname;
            rev = version;
            sha256 = "sha256-JnClppbOUNGJayCfcPH8TgWOlFBGzz+qsrRtai4gyxg=";
        };

        propagatedBuildInputs = with pkgs.python3Packages; [
            pytest
        ];

        meta = {
            description = "Telegram console";
            homepage = "https://github.com/paul-nameless/tg";
        };
    };
    tg = pkgs.python3Packages.buildPythonApplication rec {
        pname = "tgconsole";
        version = "0.17.0";

        src = pkgs.fetchFromGitHub {
            owner = "paul-nameless";
            repo = "tg";
            rev = "v${version}";
            sha256 = "sha256-CzsvMhwGdsYvqLWNFzW6ijopao5m5HgSLQCB9DvYTos=";
        };

        propagatedBuildInputs = with pkgs.python3Packages; [
            telegram
                python-telegram
        ];

        doCheck = false;

        meta = {
            description = "Telegram console";
            homepage = "https://github.com/paul-nameless/tg";
        };
    };
  my-firefox = pkgs.wrapFirefox pkgs.firefox-esr-unwrapped {
    nixExtensions = [
      (pkgs.fetchFirefoxAddon {
        name = "ublock"; # Has to be unique!
        url = "https://addons.mozilla.org/firefox/downloads/file/3679754/ublock_origin-1.31.0-an+fx.xpi";
        sha256 = "1h768ljlh3pi23l27qp961v1hd0nbj2vasgy11bmcrlqp40zgvnr";
      })
      (pkgs.fetchFirefoxAddon {
        name = "tridactyl"; # Has to be unique!
        url = "https://addons.mozilla.org/firefox/downloads/file/3874829/tridactyl-1.22.0-an+fx.xpi";
        sha256 = "b53098462121e2328c9110ab5dbbff5938d8ecce615aeccfabd16f53dac48d8e";
      })
      (pkgs.fetchFirefoxAddon {
        name = "uMatrix"; # Has to be unique!
        url = "https://addons.mozilla.org/firefox/downloads/file/3812704/umatrix-1.4.4-an+fx.xpi";
        sha256 = "1de172b1d82de28c334834f7b0eaece0b503f59e62cfc0ccf23222b8f2cb88e5";
      })
      (pkgs.fetchFirefoxAddon {
        name = "SponsorBlock"; # Has to be unique!
        url = "https://addons.mozilla.org/firefox/downloads/file/3872957/sponsorblock_skip_sponsorships_on_youtube-3.6.2-an+fx.xpi";
        sha256 = "48550d1755c952b4fdb43f5e1a6a3eff6e0250939affced2ed4351d9d6a395d3";
      })
    ];

    extraPolicies = {
      DisablePocket = true;
      FirefoxHome = {
        Pocket = false;
        Snippets = false;
      };
      UserMessaging = {
        ExtensionRecommendations = false;
        SkipOnboarding = true;
      };
    };

    extraPrefs = ''
// Show more ssl cert infos
lockPref("security.identityblock.show_extended_validation", true);

// Enable dark dev tools
lockPref("devtools.theme","dark");

// Disable add-on signing
lockPref("xpinstall.signatures.required", false)

// Fullscreen in container
lockPref("full-screen-api.ignore-widgets", true)

// Disable language pack signing
lockPref("extensions.langpacks.signatures.required", false)

// vaapi

lockPref("media.ffmpeg.vaapi.enabled", true)
lockPref("media.ffvpx.enabled", false)
lockPref("media.navigator.mediadatadecoder_vpx_enabled", true)
lockPref("media.rdd-vpx.enabled", false)
'';
    extraPolicies = {
      ExtensionSettings = {
      };
    };
  };

  firefox-wayland = pkgs.makeDesktopItem {
    name = "Firefox (Wayland)";
    desktopName = "Firefox (Wayland)";
    exec = "env MOZ_ENABLE_WAYLAND=1 ${my-firefox}/bin/firefox";
    genericName = "Web Browser";
    categories = "Network;WebBrowser;";
    mimeType = lib.concatStringsSep ";" [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/ftp"
    ];
    icon = "firefox";
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
      nodePackages.node2nix

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
      xdg-desktop-portal
      xdg-desktop-portal-wlr
      libnotify
      my-firefox
      firefox-wayland
      dbus
      xdg-desktop-portal-wlr
      xdg-desktop-portal
      electrum-ltc
      steam
      blueman
      kubectl
      kubectx
      tg
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

  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Blue-Dark";
    };
  };

  xsession.pointerCursor = {
    package = pkgs.numix-cursor-theme;
    name = "Numix-Cursor";
  };

  gtk.gtk3.extraConfig = {
    gtk-application-prefer-dark-theme = true;
    gtk-cursor-theme-name = "Numix-Cursor";
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      cursor-theme = "Numix-Cursor";
    };
  };
  
  services = {
    blueman-applet.enable = true;
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
