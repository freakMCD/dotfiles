{ config, lib, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelParams = [ "pcie_aspm=off" ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/2bec06f2-f957-4ef7-bb0d-fa2cb606907c";
      fsType = "ext4";
      options = [ "noatime" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/4E2B-7D7A";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  fileSystems."/mnt/DATA" =
    { device = "/dev/disk/by-uuid/8dbef5d9-f65d-42fe-9788-1af81ed3d908";
      fsType = "ext4";
      options = [ "noatime" ];
    };

  swapDevices = [ ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
