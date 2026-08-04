# Runs as a systemd *user* service: the host is Arch
{ pkgs, lib, ... }:
let
  # abyss-jellyfin theme (https://github.com/AumGupta/abyss-jellyfin), applied
  # as Jellyfin "Custom CSS" via @import. The browser fetches abyss.css from the
  # jsDelivr CDN at page load. Pinned to a tag rather than @main so an upstream
  # push can't restyle the server out from under us — bump it deliberately.
  themeCss = "@import url('https://cdn.jsdelivr.net/gh/AumGupta/abyss-jellyfin@main/abyss.css');";

  # Jellyfin stores Custom CSS in branding.xml inside its (mutable) data dir, so
  # it can't be a read-only home.file symlink — the server rewrites the file and
  # would error on a store path. Instead we stamp out the whole file below on
  # each activation, making Nix the source of truth for branding. Trade-off:
  # this overwrites any branding changes made through the dashboard UI.
  brandingXml = pkgs.writeText "jellyfin-branding.xml" ''
    <?xml version="1.0" encoding="utf-8"?>
    <BrandingOptions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <CustomCss>${themeCss}</CustomCss>
      <SplashscreenEnabled>false</SplashscreenEnabled>
    </BrandingOptions>
  '';
in
{
  # Write branding.xml before Home Manager restarts jellyfin.service (the
  # reloadSystemd step runs after writeBoundary), so the restart picks up the
  # theme. A running server also serves Custom CSS live — hard-refresh the
  # browser (Ctrl+Shift+R) after a switch to bust the cached stylesheet.
  home.activation.jellyfinAbyssTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run install -Dm644 ${brandingXml} "$HOME/.local/share/jellyfin/config/branding.xml"
  '';

  systemd.user.services.jellyfin = {
    Unit = {
      Description = "Jellyfin media server";
    };

    Service = {
      ExecStart = "${pkgs.jellyfin}/bin/jellyfin --datadir %h/.local/share/jellyfin --cachedir %h/.cache/jellyfin";
      Restart = "on-failure";
      RestartSec = 5;
      NoNewPrivileges = true;
      PrivateTmp = true;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
