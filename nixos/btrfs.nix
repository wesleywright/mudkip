{ pkgs, ... }:

let
  create-snapshots = pkgs.writeShellApplication {
    name = "create-snapshots";
    runtimeInputs = [
      pkgs.btrfs-progs
      pkgs.util-linux
    ];
    text = ''
      LOCK_PATH=/tmp/create-snapshots.lock
      function acquireLock {
        echo "acquiring lock at $LOCK_PATH"
        exec 3> "$LOCK_PATH"
        flock -x 3
      }

      function createSnapshot {
        mkdir -p /snapshots/"$1"
        btrfs subvolume snapshot -r "$2" /snapshots/"$1"/"$3"
      }

      acquireLock

      # Fetch the timestamp once so that we can use consistent names for all
      # snapshots
      TIMESTAMP="$(date --iso-8601=seconds)"

      echo "creating snapshots under /snapshots for timestamp $TIMESTAMP"
      createSnapshot root / "$TIMESTAMP"
      createSnapshot nix /nix "$TIMESTAMP"
      createSnapshot home /home "$TIMESTAMP"
    '';
  };
in
{
  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [
      "/"
      "/mnt/games"
    ];
  };

  systemd = {
    timers."create-snapshots" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "hourly";
        Persistent = true;
        Unit = "create-snapshots.service";
      };
    };

    services."create-snapshots" = {
      serviceConfig = {
        ExecStart = "${create-snapshots}/bin/create-snapshots";
        Type = "oneshot";
        User = "root";
      };
    };
  };
}
