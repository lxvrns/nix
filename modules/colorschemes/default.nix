{ config, nix-colors, ... }:

{
  colorscheme = nix-colors.colorSchemes.gruvbox-dark-medium;
  imports = [
    # ./autumn.nix
    # ./melange.nix
    # ./spicy.nix
    # ./seoul.nix
  ];
}

