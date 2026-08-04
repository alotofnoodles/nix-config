# Radarr — movie manager. WebUI on localhost:7878, proxied as http://radarr.
#
# Runs as the login user so imports are plain file ops: it hardlinks finished
# downloads from ~/Videos/Downloads into ~/Videos/Movies. Hardlinks need both
# on one filesystem — that's why downloads live under ~/Videos, see
# qbittorrent.nix.
#
# Config in ~/.local/share/radarr is mutable and NOT managed by Nix. Wired by
# hand once: root folder ~/Videos/Movies, qBittorrent as download client
# (localhost:8080), hardlinks-instead-of-copy left on. Indexers arrive from
# Prowlarr — never add them here directly.
{ pkgs, ... }:
{
  systemd.user.services.radarr = {
    Unit.Description = "Radarr movie manager";

    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/.local/share/radarr";
      ExecStart = "${pkgs.radarr}/bin/Radarr -nobrowser -data=%h/.local/share/radarr";

      Restart = "on-failure";
      RestartSec = 5;
      NoNewPrivileges = true;
      PrivateTmp = true;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
