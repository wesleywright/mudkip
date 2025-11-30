{ ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
    };
    extraConfig = ''
      IdentityAgent ~/.1password/agent.sock
    '';
  };
}
