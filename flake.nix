{
  description = "Builder for samsung a05s";

  inputs = {
    robotnix.url = "github:nix-community/robotnix";
    device_a05s = {
      url = "github:galaxy-a05s/lineage_device_samsung_a05s";
      flake = false;
    };
    lineage_bengal_common = {
      url = "github:galaxy-a05s/lineage_device_samsung_bengal-common";
      flake = false;
    };
    kernel_bengal = {
      url = "github:cd-Crypton/android_kernel_samsung_bengal-5.15";
      flake = false;
    };
    vendor_a05s = {
      url = "github:galaxy-a05s/android_vendor_samsung_bengal_f";
      flake = false;
    };
  };

  outputs =
    {
      self,
      robotnix,
      device_a05s,
      vendor_a05s,
      kernel_bengal,
      lineage_bengal_common,
    }:
    {
      robotnixConfigurations."A05s" = robotnix.lib.robotnixSystem (
        { pkgs, ... }:
        {
          device = "a05s";
          flavor = "lineageos";
          androidVersion = 15;
          source.dirs = {
            "device/samsung/a05s".src = device_a05s;
            "vendor/samsung/bengal".src = vendor_a05s;
            "device/samsung/bengal-common".src = lineage_bengal_common;
            "kernel/samsung/bengal".src = kernel_bengal;
          };
        }
      );

      # This provides a convenient output which allows you to build the image by
      # simply running "nix build" on this flake.
      packages.x86_64-linux.default = self.robotnixConfigurations."A05s".img;
    };
}
