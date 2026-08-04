# Jellyseerr — request front-end. WebUI on localhost:5055, proxied as
# http://jellyseerr. Household members sign in with their Jellyfin accounts and
# request titles, which Jellyseerr hands to Radarr/Sonarr; the *arr apps stay
# admin-only.
#
# Config in $CONFIG_DIRECTORY is mutable and NOT managed by Nix. Wired by hand
# once: sign in against Jellyfin (localhost:8096), then add Radarr and Sonarr
# as services with their API keys and root folders.
{ pkgs, ... }:
{
  systemd.user.services.jellyseerr = {
    Unit.Description = "Jellyseerr media request manager";

    Service = {
      # %h isn't expanded inside Environment=, hence the literal path.
      Environment = [
        "CONFIG_DIRECTORY=/home/foomaxchu/.local/share/jellyseerr"
        "PORT=5055"
      ];
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/.local/share/jellyseerr";
      ExecStart = "${pkgs.jellyseerr}/bin/seerr";

      Restart = "on-failure";
      RestartSec = 5;
      NoNewPrivileges = true;
      PrivateTmp = true;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
