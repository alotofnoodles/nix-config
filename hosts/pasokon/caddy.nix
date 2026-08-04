# Caddy — hostname front door for the media stack, so the browser takes
# `radarr/` instead of pasokon.local:7878.
#
# One listener on :80 routes by Host header to the localhost services:
#   http://radarr    → 7878        http://jellyfin → 8096
#   http://sonarr    → 8989        http://qbit     → 8080
#   http://prowlarr  → 9696
{ config, pkgs, ... }:
{
  xdg.configFile."caddy/Caddyfile".text = ''
    {
      # Without this Caddy would try to provision certificates for bare names
      # like "radarr" and fail.
      auto_https off
      http_port 80
      # Loopback only. The default 0.0.0.0 would re-expose every backend to the
      # LAN — and since the proxy connects from 127.0.0.1, remote clients would
      # inherit any trust a backend gives localhost.
      default_bind 127.0.0.1
    }

    http://radarr {
      reverse_proxy localhost:7878
    }

    http://sonarr {
      reverse_proxy localhost:8989
    }

    http://prowlarr {
      reverse_proxy localhost:9696
    }

    http://qbit {
      reverse_proxy localhost:8080
    }

    http://jellyfin {
      reverse_proxy localhost:8096
    }

    http://bazarr {
      reverse_proxy localhost:6767
    }

    # /etc/hosts carries the single-r `jellyseer`; the app's name has two.
    http://jellyseer, http://jellyseerr {
      reverse_proxy localhost:5055
    }
  '';

  systemd.user.services.caddy = {
    Unit.Description = "Caddy reverse proxy for media services";

    Service = {
      ExecStart = "${pkgs.caddy}/bin/caddy run --config ${config.xdg.configHome}/caddy/Caddyfile --adapter caddyfile";
      Restart = "on-failure";
      RestartSec = 5;
      NoNewPrivileges = true;
      PrivateTmp = true;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
