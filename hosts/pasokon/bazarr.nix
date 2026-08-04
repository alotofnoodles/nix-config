# Bazarr — subtitle downloader. WebUI on localhost:6767, proxied as
# http://bazarr by caddy.nix.
#
# Config in ~/.local/share/bazarr is mutable and NOT managed by Nix. Wired by
# hand once: Radarr (7878) and Sonarr (8989) connections + API keys, subtitle
# providers, and a default language profile — without that profile Bazarr does
# nothing.
{ pkgs, ... }:
{
  systemd.user.services.bazarr = {
    Unit.Description = "Bazarr subtitle manager";

    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/.local/share/bazarr";
      ExecStart = "${pkgs.bazarr}/bin/bazarr --config %h/.local/share/bazarr";

      Restart = "on-failure";
      RestartSec = 5;
      NoNewPrivileges = true;
      PrivateTmp = true;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
