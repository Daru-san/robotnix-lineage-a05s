{
  description = "Builder for samsung a05s";

  inputs = {
    robotnix.url = "github:nix-community/robotnix";
    device_a05s = {
      url = "github:galaxy-a05s/lineage_device_samsung_a05s";
      flake = false;
    };
    bengal_common = {
      url = "github:galaxy-a05s/android_device_samsung_bengal-common";
      flake = false;
    };
    kernel_a05s = {
      url = "github:cdpkp/android_kernel_tree_common_a05s";
      flake = false;
    };
  };

  outputs =
    {
      self,
      robotnix,
      device_a05s,
      bengal_common,
      kernel_a05s,
    }:
    {
      robotnixConfigurations."A05s" = robotnix.lib.robotnixSystem (
        { pkgs, ... }:
        {
          device = "A05s";
          flavor = "lineageos";
          androidVersion = 15;
          source.dirs = {
            "device/samsung/a05s".src = device_a05s;
            "device/samsung/bengal-common".src = bengal_common;
            "kernel/samsung/a05s".src = kernel_a05s;
          };
        }
      );

      # This provides a convenient output which allows you to build the image by
      # simply running "nix build" on this flake.
      packages.x86_64-linux.default = self.robotnixConfigurations."A05s".img;
    };
}
