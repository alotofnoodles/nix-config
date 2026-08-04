# Prowlarr — indexer manager. WebUI on localhost:9696, proxied as
# http://prowlarr.
#
# Indexers are configured here once and synced out to Radarr and Sonarr
# (Settings → Apps), which is why they're never added in those apps directly.
#
# Config in ~/.local/share/prowlarr is mutable and NOT managed by Nix; the app
# connections need each target's API key from its Settings → General.
{ pkgs, ... }:
{
  systemd.user.services.prowlarr = {
    Unit.Description = "Prowlarr indexer manager";

    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/.local/share/prowlarr";
      ExecStart = "${pkgs.prowlarr}/bin/Prowlarr -nobrowser -data=%h/.local/share/prowlarr";

      Restart = "on-failure";
      RestartSec = 5;
      NoNewPrivileges = true;
      PrivateTmp = true;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
