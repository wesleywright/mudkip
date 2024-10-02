{ ... }:

{
  # My USB hub causes Linux to wake from sleep immediately for some reason.
  # I actually only ever want the computer to wake up if I manually press the
  # ACPI power button on top of the chassis, so it's actually much simpler if
  # I just disable other ACPI power signals completely.
  services.udev.extraRules = ''
    ACTION=="add", ATTR{vendor}="0x1022", ATTR{device}="0x149c", ATTR{power/wakeup}="disabled"
  '';
}
