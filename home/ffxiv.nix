{ pkgs, ... }:

let
  xivlauncher-submit-otp = pkgs.writeShellApplication {
    name = "xivlauncher-submit-otp";
    # NOTE: do NOT specify `op` here; we need to depend on the global install from NixOS,
    # as the bare package doesn't seem to integrate with polkit correctly AFAICT
    runtimeInputs = [
      pkgs.curl
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
      passOTPOnce
    '';
  };
  xivlauncher-submit-otp-desktop = pkgs.makeDesktopItem {
    desktopName = "Fill FFXIV OTP";
    categories = [ "Game" ];
    exec = "${xivlauncher-submit-otp}/bin/xivlauncher-submit-otp";
    icon = "object-unlocked";
    name = "xivlauncher-submit-otp-desktop";
  };
in {
  home.packages = [
    pkgs.xivlauncher
    xivlauncher-submit-otp
    xivlauncher-submit-otp-desktop
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "xivlauncher"
    ];
}
