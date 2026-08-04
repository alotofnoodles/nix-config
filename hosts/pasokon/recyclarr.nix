# Recyclarr — syncs TRaSH-guides quality settings into Radarr and Sonarr, so
# release scoring follows the community rules instead of stock defaults. Not a
# daemon: `recyclarr sync` is a oneshot run daily by the timer below.
#
# Declarative except the API keys, which come from a hand-made file outside
# git — home-manager symlinks recyclarr.yml individually, so this coexists
# untouched in the same directory:
#
#   ~/.config/recyclarr/secrets.yml   (chmod 600):
#     radarr_apikey: ...
#     sonarr_apikey: ...
#
# Scope is quality definitions plus a few custom formats. To go further, browse
# `recyclarr config list templates`. Docs: https://recyclarr.dev
{ config, pkgs, ... }:
{
  xdg.configFile."recyclarr/recyclarr.yml".text = ''
    # yaml-language-server: $schema=https://schemas.recyclarr.dev/v8/config-schema.json

    radarr:
      # Derived from the official hd-bluray-web.yml template; see
      # https://trash-guides.info/Radarr/radarr-setup-quality-profiles/#hd-bluray-web
      hd-bluray-web:
        base_url: http://localhost:7878
        api_key: !secret radarr_apikey

        quality_definition:
          type: movie

        quality_profiles:
          - trash_id: d1d67249d3890e49bc12e275d989a7e9  # HD Bluray + WEB
            # Zero out unmanaged formats so the profile matches the guide
            # exactly instead of drifting.
            reset_unmatched_scores:
              enabled: true

        custom_format_groups:
          add:
            # Golden Rule HD penalises x265 at 1080p because it forces a
            # transcode on weak clients. Playback here is the Jellyfin Android
            # TV app, which direct-plays HEVC, so exclude that penalty.
            - trash_id: f8bf8eab4617f12dfdbd16303d8da245  # [Optional] Golden Rule HD
              exclude:
                - dc98083864ea246d05a42df0d05f81cc  # x265 (HD)

            # Junk filter: blocks the BR-DISK/LQ/Upscaled grabs.
            - trash_id: a3ac6af01d78e4f21fcb75f601ac96df  # [Unwanted] Unwanted Formats

            # Movie edition preferences: uncomment any you want scored up.
            # - trash_id: f4f1474b963b24cf983455743aa9906c  # [Optional] Movie Versions
            #   select:
            #     - eecf3a857724171f968a66cb5719e152  # IMAX
            #     - 570bc9ebecd92723d2d21500f4be314c  # Remaster
            #     - e9001909a4c88013a359d0b9920d7bea  # Theatrical Cut

    sonarr:
      pasokon:
        base_url: http://localhost:8989
        api_key: !secret sonarr_apikey
        quality_definition:
          type: series
  '';

  systemd.user.services.recyclarr = {
    Unit.Description = "Recyclarr sync (TRaSH guides → Radarr/Sonarr)";

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.recyclarr}/bin/recyclarr sync";
      # v8 dropped --app-data in favour of this env var.
      Environment = [ "RECYCLARR_CONFIG_DIR=${config.xdg.configHome}/recyclarr" ];
      NoNewPrivileges = true;
      PrivateTmp = true;
    };
    # No Install/WantedBy: only the timer starts this.
  };

  systemd.user.timers.recyclarr = {
    Unit.Description = "Daily Recyclarr sync";
    Timer = {
      OnCalendar = "daily";
      # Catch up after the box was asleep at the scheduled time.
      Persistent = true;
      RandomizedDelaySec = "15m";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
