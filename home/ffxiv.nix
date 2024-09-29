{ pkgs, ... }:

let
  xivlauncher-1p = pkgs.writeShellApplication {
    name = "xivlauncher-1p";
    # NOTE: do NOT specify `op` here; we need to depend on the global install from NixOS,
    # as the bare package doesn't seem to integrate with polkit correctly AFAICT
    runtimeInputs = [
      pkgs.curl
      pkgs.xivlauncher
    ];
    text = ''
      function fetchOTP {
        op item get --otp MogStation
      }

      function sendRequest {
        curl http://localhost:4646/ffxivlauncher/"''${1:-}"
      }

      function passOTPOnce {
        while ! fetchOTP 2>/dev/null; do
          echo "Could not fetch OTP, sleeping"
          sleep 1
        done
        
        while ! sendRequest 2>/dev/null; do
          echo "HTTP server is not yet ready, sleeping"
          sleep 1
        done
        sendRequest "$(fetchOTP)"
      }

      # Ensure that 1Password is running
      passOTPOnce &
      XIVLauncher.Core "$@"
    '';
  };
  xivlauncher-1p-desktop = pkgs.makeDesktopItem {
    name = "xivlauncher-1p-desktop";
    desktopName = "Final Fantasy XIV (1Password)";
    exec = "${xivlauncher-1p}/bin/xivlauncher-1p";
  };
in {
  home.packages = [
    xivlauncher-1p
    xivlauncher-1p-desktop
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "xivlauncher"
    ];
}
