{ config, lib, nix-colors, osConfig, ... }:

with config.colorscheme.colors;
{
  home.file."README-md" = {
    target = "${config.xdg.cacheHome}/README.md";
    onChange = "cp -f '${config.home.file."README-md".target}' '${config.home.homeDirectory}/.dotnix/README.md'";
    
    text = ''
      # Welcome traveller to the disarray that are my dotfiles!

      ## Credits
      - [gammons/base16-obsidian](https://github.com/gammons/base16-obsidian)
      - [Misterio77/nix-colors](https://github.com/Misterio77/nix-colors)
      - [Misterio77/nix-starter-config](https://github.com/Misterio77/nix-starter-config/blob/minimal/configuration.nix)
      - [fortuneteller2k/nix-config](https://github.com/fortuneteller2k/nix-config)
      - [legendofmiracles/dotnix](https://github.com/legendofmiracles/dotnix)
      - [nuxshed/dotfiles](https://github.com/nuxshed/dotfiles)
      - [viperML/dotfiles](https://github.com/viperML/dotfiles)
      
      ![My rice!](./assets/rice.png "My rice!")
      
      |                     |                                                                                                               |
      | ------------------- | ------------------------------------------------------------------------------------------------------------- |
      | OS                  | [NixOS 22.05](https://nixos.org/)                                                                             |
      | Window Manager      | [Sway](https://github.com/swaywm/sway/) [i3-gaps](https://github.com/Airblader/i3)                            |
      | GTK Theme           | [Materia ${config.colorscheme.name}](https://github.com/Misterio77/nix-colors)                                |
      | Icon Theme          | [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)                                       |
      | Cusor Theme         | [Capitaine Cursors](https://github.com/keeferrourke/capitaine-cursors)                                        |
      | UI Font             | [Inter](https://github.com/rsms/inter)                                                                        | 
      | Terminal            | [Foot](https://codeberg.org/dnkl/foot) [Alacritty](https://github.com/alacritty/alacritty)                    |
      | Terminal Font       | ${builtins.toString osConfig.fonts.fontconfig.defaultFonts.monospace}                                                                 |
      | PDF Viewer          | [Zathura](https://git.pwmt.org/pwmt/zathura)                                                                  |
      | Editor              | [Neovim](https://neovim.io/)                                                                                  |
      | Shell               | [Zsh](https://www.zsh.org/)                                                                                   |
      | Wallpaper           | [Wallpaper](./assets/wallpaper.png)                                                                           |
      | Colorscheme         | ${config.colorscheme.name}

      ## Color Palette
      |                    Colorscheme                       |              ${config.colorscheme.name}               |
      |:----------------------------------------------------:|:-----------------------------------------------------:|
      | $$\textcolor{#${base00}}{\text{████}}$$ `#${base00}` |  $$\textcolor{#${base08}}{\text{████}}$$ `#${base08}` |
      | $$\textcolor{#${base01}}{\text{████}}$$ `#${base01}` |  $$\textcolor{#${base09}}{\text{████}}$$ `#${base09}` |
      | $$\textcolor{#${base02}}{\text{████}}$$ `#${base02}` |  $$\textcolor{#${base0A}}{\text{████}}$$ `#${base0A}` |
      | $$\textcolor{#${base03}}{\text{████}}$$ `#${base03}` |  $$\textcolor{#${base0B}}{\text{████}}$$ `#${base0B}` |
      | $$\textcolor{#${base04}}{\text{████}}$$ `#${base04}` |  $$\textcolor{#${base0C}}{\text{████}}$$ `#${base0C}` |
      | $$\textcolor{#${base05}}{\text{████}}$$ `#${base05}` |  $$\textcolor{#${base0D}}{\text{████}}$$ `#${base0D}` |
      | $$\textcolor{#${base06}}{\text{████}}$$ `#${base06}` |  $$\textcolor{#${base0E}}{\text{████}}$$ `#${base0E}` |
      | $$\textcolor{#${base07}}{\text{████}}$$ `#${base07}` |  $$\textcolor{#${base0F}}{\text{████}}$$ `#${base0F}` |
      '';
  };

  #home.activation = {
  #  generateReadme = lib.hm.dag.entryAfter [ "home.file.README.md" ] ''
  #    cp -f "${config.xdg.cacheHome}/README.md" "${config.home.homeDirectory}/.dotnix/README.md"
  #  '';
  #};

}

