{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./modules/common.nix
    ./modules/desktops/gnome.nix
    ./modules/keyboard/interception.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  # My poor computer cant handle EFI variables :(
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "desktop";

  qt5 = {
    enable = true;
    platformTheme = "gnome";
    style= "adwaita-dark";
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  # For suspend/resume:
  hardware.nvidia.powerManagement.enable = true;

  programs.gamemode.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  environment.shells = [ pkgs.zsh ];
  users.users.sofi = {
    description = "Sofi";
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    firefox
    neovim
    vimPlugins.nvim-treesitter
    gcc
    spotify
    legendary-gl
    inputs.nix-gaming.packages.${pkgs.system}.wine-tkg
    winetricks
    nur.repos.wolfangaukang.heroic
  ];

  system.stateVersion = "22.05";  # Do not touch.
}

