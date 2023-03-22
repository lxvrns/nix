{ config, pkgs, nixvim, nix-colors, ... }:

with config.colorscheme.colors;

{
  # Neovim

  programs.nixvim = {
    enable = true;

    globals = {
      limelight_conceal_ctermfg = "#${base03}";
      limelight_conceal_guifg = "#${base03}";
    };

    plugins = {

      nix.enable = true;
      # nvim-autopairs.enable = true;

      lualine = {
        enable = false;

        sectionSeparators = {
          left = "" ;
          right = "" ;
        };

        componentSeparators = {
          left = "" ;
          right = "" ;
        };

        theme = "base16";
      };

      goyo = {
        enable = true;
        showLineNumbers = false;
      };

      lsp = {
        enable = true;
	      servers = {
	        rust-analyzer.enable = true;
	        rnix-lsp.enable = true;
	      };
      };

    };

    extraPlugins = with pkgs.vimPlugins; [ 
      limelight-vim
      # (import ./rose-pine.nix { inherit pkgs; })
      # (import ./melange.nix { inherit pkgs; })
    ];

    options = {
      # Indentation
      autoindent = true;
      tabstop = 8;
      shiftwidth = 2;
      expandtab = true;
      backspace = "indent,eol,start";

      # Text
      showmatch = true;
      mouse = "a";
      number = true;
      relativenumber = false;
      ttyfast = true;
      clipboard = "unnamedplus";

      # Colors
      background = "${config.colorscheme.kind}";
      termguicolors = true;

    };

    colorscheme = "base16-${config.colorscheme.slug}";
    #colorscheme = "melange";

  };

  programs.neovim.vimAlias = true;
  programs.neovim.viAlias = true;

}
