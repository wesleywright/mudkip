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
in
{
  systemd.user.services.wireproxy1 = {
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "${wireproxy}/bin/wireproxy --config ${config.xdg.configHome}/wireproxy/proxy1.ini";
    };
  };
}
