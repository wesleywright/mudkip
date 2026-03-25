{ ... }:

{
  # Pipewire can make use of rtkit for performance.
  security.rtkit.enable = true;

  services.pipewire = {
    # Pipewire is enabled by default as of NixOS 25.11, but we enable it
    # explicitly here in case the default changes.
    enable = true;

    # RAOP stands for Remote Audio Output Protocol, which is also known as Airplay.
    raopOpenFirewall = true;
    extraConfig.pipewire = {
      # Enable the RAOP Discover module, which allows using network Airplay
      # devices as Pipewire sinks automatically.
      "10-airplay-raop" = {
        "context.modules" = [
          {
            name = "libepipewire-module-raop-discover";
          }
        ];
      };
    };
  };

  # Needed for some applications to configure audio.
  users.users.naptime.extraGroups = [ "audio" ];
}
