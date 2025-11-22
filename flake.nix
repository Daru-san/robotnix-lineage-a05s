{
  description = "Builder for LineageOS samsung a05s";
  nixConfig.extra-substituters = [ "https://robotnix.cachix.org" ];
  nixConfig.extra-trusted-public-keys = [
    "robotnix.cachix.org-1:+y88eX6KTvkJyernp1knbpttlaLTboVp4vq/b24BIv0="
  ];

  inputs = {
    robotnix.url = "github:nix-community/robotnix";
    device_a05s = {
      url = "github:galaxy-a05s/lineage_device_samsung_a05s";
      flake = false;
    };
    lineage_bengal_common = {
      url = "github:Daru-san/lineage_device_samsung_bengal-common";
      flake = false;
    };
    kernel_bengal = {
      url = "github:Daru-san/android_kernel_samsung_a05s";
      flake = false;
    };
    vendor_a05s = {
      url = "github:Daru-san/android_vendor_samsung_bengal_f";
      flake = false;
    };
    hosts = {
      url = "github:StevenBlack/hosts";
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
      hosts,
    }:
    let
      host = hosts;
    in
    {
      robotnixConfigurations."a05s" = robotnix.lib.robotnixSystem (
        { ... }:
        {
          device = "a05s";
          flavor = "lineageos";
          androidVersion = 15;
          flavorVersion = "22.2";
          source.dirs = {
            "device/samsung/a05s".src = device_a05s;
            "vendor/samsung/bengal".src = vendor_a05s;
            "device/samsung/bengal-common".src = lineage_bengal_common;
            "kernel/samsung/bengal".src = kernel_bengal;
          };
          apps = {
            bromite.enable = false;
            chromium.enable = false;
            updater.enable = false;
            seedvault.enable = true;
            vanadium.enable = false;
            fdroid.enable = true;
          };

          webview = {
            chromium.enable = false;
            chromium.availableByDefault = false;
            vanadium.enable = false;
            vanadium.availableByDefault = true;
          };

          microg.enable = true;

          hosts = host + "/hosts";
        }
      );

      packages.x86_64-linux.default = self.robotnixConfigurations."a05s".img;
    };
}
