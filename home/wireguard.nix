{
  config,
  pkgs,
  lib,
  ...
}:

let
  wireproxy = pkgs.buildGoModule rec {
    name = "wireproxy";
    src = pkgs.fetchFromGitHub {
      owner = "whyvl";
      repo = "wireproxy";
      rev = "9dad356beeb3abad48434d5ec9272ad17af5b957";
      hash = "sha256-F8WatQsXgq3ex2uAy8eoS2DkG7uClNwZ74eG/mJN83o=";
    };
    vendorHash = "sha256-uCU5WLCKl5T4I1OccVl7WU0GM/t4RyAEmzHkJ22py30=";
  };

  wrapperScript = pkgs.writeShellApplication {
    name = "wireproxy-injected-secret";

    runtimeInputs = [ wireproxy ];

    text = ''
      PORT=$1
      URL=$2

      wireproxy --config=<(op inject <<EOS
      [http]
      BindAddress = 127.0.0.1:$PORT

      {{ $URL }}
      EOS
      )
    '';
  };
in
{
  systemd.user.services.wireproxy1 = {
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "${wrapperScript}/bin/wireproxy-injected-secret 11789 op://Personal/protonvpn-nl-free/config";
    };
  };
}
