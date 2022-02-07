{ config, pkgs, lib, unstable, ... }:

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
    version = "0.15.0";

    src = pkgs.fetchFromGitHub {
      owner = "alexander-akhmetov";
      repo = pname;
      rev = "a5c06855aed41ff1503c7949ccb5fe725374fa20";
      sha256 = "sha256-P4lbCwhkko/xo/s4v60pq8gwAaeY9x/2Q4ij/x8fDwM=";
    };

    nativeBuildInputs = [
      pkgs.tdlib
    ];

    propagatedBuildInputs = with pkgs.python3Packages; [
      pytest
    ];

    preFixup = let
      libPath = pkgs.lib.makeLibraryPath [
        pkgs.zlib
        pkgs.openssl
        pkgs.stdenv.cc.cc.lib
      ];
    in ''
    echo "$src"
    patchelf \
    --set-rpath "${libPath}" \
    $out/lib/python3.9/site-packages/telegram/lib/linux/libtdjson.so
    '';

    postPatch = ''
    substituteInPlace telegram/tdjson.py \
    --replace "find_library(\"libtdjson\")" "find_library(\"tdjson\")"
    '';

    meta = {
      description = "Telegram console";
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

    nativeBuildInputs = with pkgs; [
      ffmpeg
      ranger
      fzf
    ];

    propagatedBuildInputs = with pkgs.python3Packages; [
      python-telegram
      pkgs.ffmpeg
    ];

    postPatch = ''
    substituteInPlace setup.py \
    --replace "python-telegram==0.14.0" "python-telegram==0.15.0"
    '';

    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [ pkgs.tdlib ];

    doCheck = false;

    meta = {
      description = "Telegram console";
      homepage = "https://github.com/paul-nameless/tg";
    };
  };
  my-firefox = pkgs.wrapFirefox unstable.firefox-esr-unwrapped {
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
    '';
    extraPolicies = {
      ExtensionSettings = {
      };
    };
  };
  dbus-firefox-esr = (my-firefox.overrideAttrs (_: {
    desktopItem =
      pkgs.makeDesktopItem {
        name = "firefox";
        icon = "firefox";
        desktopName = "Firefox (Wayland)";
        exec = "env MOZ_DBUS_REMOTE=1 MOZ_ENABLE_WAYLAND=1 ${my-firefox}/bin/firefox %u";
        comment = "";
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
      };
    }));

    firefox-wayland = pkgs.makeDesktopItem {
      name = "firefox-xorg";
      exec = "env MOZ_DBUS_REMOTE=1 firefox %u";
      desktopName = "Firefox";
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
        unstable.tdesktop
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
        dbus-firefox-esr
        firefox-wayland
        dbus
        xdg-desktop-portal-wlr
        xdg-desktop-portal
        electrum-ltc
        steam
        blueman
        kubectl
        kubectx
        ranger
        urlview
        ffmpeg
        sccache
        unzip
        mpv
        vlc
        gzdoom

      ];
    };

    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraOptions = [
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

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = 
  {
    # Add other defaults here too
    "text/html" = [ "firefox-wayland.desktop" ];
    "text/xml" = [ "firefox.desktop" ];
    "application/xhtml+xml" = [ "firefox.desktop" ];
    "application/vnd.mozilla.xul+xml" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
    "x-scheme-handler/ftp" = [ "firefox.desktop" ];
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
