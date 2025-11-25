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
      nixpkgs,
      lineage_hardware_samsung,
    }:
    let
      host = hosts;
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
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

          kernel = {
            enable = true;
            clangVersion = "20";
            src = kernel_bengal;
            relpath = "kernel/samsung/bengal";
            patches = [
              (pkgs.fetchpatch {
                url = "https://github.com/cdpkp/android_kernel_tree_samsung_a05s/commit/72c67f9b85b492a8ba500ce2a03eff1bd78f6b9e.patch";
                sha256 = "sha256-DXaih7kqe73nl6fT1dyMxT5IlSosYQTaPc/qENXn248=";
              })
              (pkgs.fetchpatch {
                url = "https://github.com/cdpkp/android_kernel_tree_samsung_a05s/commit/9bd23082815e1c7b455d7384563a454023e0c202.patch";
                sha256 = "sha256-/IrhIfDniqRZIvoAYmaCnaG9iWnWymKK4X0bmTHq0Ec";
              })
            ];
          };

          microg.enable = true;

          hosts = host + "/hosts";
        }
      );

      packages.x86_64-linux.default = self.robotnixConfigurations."a05s".img;
    };
}
