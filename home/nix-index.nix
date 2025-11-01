{ pkgs, ... }:

{
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  systemd.user = {
    services.nix-index-build = {
      Unit = {
        Description = "Rebuild nix package index";
      };

      Service = {
        ExecStart = "${pkgs.nix-index}/bin/nix-index";
      };
    };

    timers.nix-index-build = {
      Unit = {
        Description = "Rebuild nix package index";
      };

      Timer = {
        OnUnitActiveSec = 60 * 60 * 24 * 7;
        Unit = "nix-index-build.service";
      };

      Install.WantedBy = [ "timers.target" ];
    };
  };
}
