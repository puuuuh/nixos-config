{ config, pkgs, unstable, ... }:

let
  project-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "project-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "ahmedkhalf";
      repo = "project.nvim";
      rev = "71d0e23dcfc43cfd6bb2a97dc5a7de1ab47a6538";
      sha256 = "0jxxckfcm0vmcblj6fr4fbdxw7b5dwpr8b7jv59mjsyzqfcdnhs5";
    };
  };
in
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs; [
      vimPlugins.nvim-lspconfig
      vimPlugins.lsp-status-nvim
      vimPlugins.trouble-nvim
      vimPlugins.lspkind-nvim
      vimPlugins.lsp_extensions-nvim
      unstable.vimPlugins.nvim-cmp
      unstable.vimPlugins.cmp-nvim-lsp
      vimPlugins.vim-vsnip
      vimPlugins.cmp-vsnip
      vimPlugins.cmp-buffer
      vimPlugins.luasnip
      vimPlugins.fzf-vim
      vimPlugins.tokyonight-nvim
      vimPlugins.vim-rooter
      vimPlugins.rust-vim
      vimPlugins.vimspector
      vimPlugins.vim-javascript
      vimPlugins.typescript-vim
      vimPlugins.vim-jsx-typescript
      vimPlugins.vim-graphql
      (vimPlugins.nvim-treesitter.withPlugins (
        plugins: with plugins; [
          tree-sitter-nix
          tree-sitter-python
          tree-sitter-rust
          tree-sitter-c-sharp
          tree-sitter-toml
        ]
      ))
      vimPlugins.galaxyline-nvim
      vimPlugins.nvim-web-devicons
      vimPlugins.i3config-vim
      vimPlugins.plantuml-syntax
      vimPlugins.vim-go
      vimPlugins.plenary-nvim
      vimPlugins.telescope-nvim
      vimPlugins.popup-nvim
      vimPlugins.nvim-tree-lua
      project-nvim
      vimPlugins.neogit
      vimPlugins.indent-blankline-nvim
      vimPlugins.vim-easymotion
      vimPlugins.vim-nix
      vimPlugins.vim-toml
      vimPlugins.vim-yaml
    ];
    extraConfig = ''
      :lua require('init_lua')
      '';
  };

  home = {
    file = {
      nvim_config = {
        source = ./nvim/lua;
        target = ".config/nvim/lua";
	recursive = true;
      };
    };
  };
}
