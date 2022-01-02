{config, pkgs, lib, nixosConfig, ...}:

let
  cfg = config.services.keepass-mount;
in
with lib;

{
  options.services.keepass-mount = with types; {
    enable = mkEnableOption "Auto mount keepass files through rsync";
  };


  config =
    mkIf cfg.enable {
      systemd.user.services.keepass-mount = {
        Unit = {
          Description = "Mount my keepass store from dropbox";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
        Service = {
          ExecStartPre = "/run/current-system/sw/bin/mkdir -p ${config.home.homeDirectory}/KeePass";
          ExecStop = ''${pkgs.fuse}/bin/fusermount -u ${config.home.homeDirectory}/KeePass'';
          Restart = "always";
          ExecStart = ''${pkgs.rclone}/bin/rclone mount -v \
                                --vfs-cache-mode writes \
                                --cache-tmp-upload-path=/tmp/rclone/upload \
                                --cache-chunk-path=/tmp/rclone/chunks \
                                --cache-workers=8 \
                                --cache-writes \
                                --cache-dir=/tmp/rclone/vfs \
                                --cache-db-path=/tmp/rclone/db \
                                --no-modtime \
                                --drive-use-trash \
                                --stats=0 \
                                --checkers=16 \
                                --bwlimit=40M \
                                --dir-cache-time=60m \
                                --cache-info-age=60m dropbox:KeePass ${config.home.homeDirectory}/KeePass'';
          Environment = [ "PATH=/run/wrappers/bin:$PATH" ];
        };	  
      };
    };
}
