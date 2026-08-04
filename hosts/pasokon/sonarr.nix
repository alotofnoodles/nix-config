# Sonarr — TV series manager, the counterpart to radarr.nix and set up the same
# way. WebUI on localhost:8989, proxied as http://sonarr.
#
# Config in ~/.local/share/sonarr is mutable and NOT managed by Nix. Wired by
# hand once: root folder ~/Videos/Shows, qBittorrent as download client
# (localhost:8080), hardlinks-instead-of-copy left on. Indexers arrive from
# Prowlarr — never add them here directly.
{ pkgs, ... }:
{
  systemd.user.services.sonarr = {
    Unit.Description = "Sonarr TV series manager";

    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/.local/share/sonarr";
      ExecStart = "${pkgs.sonarr}/bin/Sonarr -nobrowser -data=%h/.local/share/sonarr";

      Restart = "on-failure";
      RestartSec = 5;
      NoNewPrivileges = true;
      PrivateTmp = true;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
