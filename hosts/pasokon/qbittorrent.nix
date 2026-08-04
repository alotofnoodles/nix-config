# Headless qBittorrent (qbittorrent-nox) for the pasokon media box.
#
# WebUI: http://<lan-ip>:8080  (default creds are printed to the journal on the
# very first start — see the note on --confirm-legal-notice below).
#
# Config lives in ~/.config/qBittorrent/qBittorrent.conf and is mutable, NOT
# managed by Nix: the download paths, categories and (importantly) the WebUI
# password are set once through the UI. Set the default save path to
# ~/Videos/Downloads and "keep incomplete torrents in" ~/Videos/Downloads/
# incomplete on first run.
#
{ pkgs, ... }:
{
  systemd.user.services.qbittorrent = {
    Unit = {
      Description = "qBittorrent-nox torrent client";
      # User managers have no network-online.target; on-failure restarts
      # cover the race with wifi coming up after login.
    };

    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/Videos/Downloads/incomplete";
      ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=8080 --confirm-legal-notice";

      Restart = "on-failure";
      RestartSec = 5;
      NoNewPrivileges = true;
      PrivateTmp = true;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
