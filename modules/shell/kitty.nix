{
  flake.modules.homeManager.kitty = { config, lib, pkgs, ... }: {
    options.theo.kitty.font = lib.mkOption {
      type = lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            # or ComicCodeLigatures Nerd Font / ProggyClean Nerd Font
            default = "FantasqueSansM Nerd Font";
          };
          size = lib.mkOption {
            type = lib.types.ints.positive;
            default = 16;
          };
        };
      };
      default = { };
      description = "Kittyyyyyyyyy font";
    };

    config = {

      xdg.configFile."kitty/tab_bar.py".source = ./kitty/tab_bar.py;

      programs.kitty = {

        enable = true;

        # https://sw.kovidgoyal.net/kitty/faq/#how-do-i-specify-command-line-options-for-kitty-on-macos
        darwinLaunchOptions = [
          "--single-instance"
        ];

        themeFile = "Nordfox";

        font = config.theo.kitty.font;

        settings = {
          bold_font = "auto";
          italic_font = "auto";
          bold_italic_font = "auto";
          disable_ligatures = "cursor";

          cursor_shape = "block";

          scrollback_lines = 10000;
          scrollbar = "scrolled";
          scrollbar_interactive = "yes";
          scrollbar_jump_on_click = "no";

          show_hyperlink_targets = "yes";

          enable_audio_bell = "no";
          visual_bell_duration = "0.0";
          bell_on_tab = ''"[BELL]"'';

          enabled_layouts = "tall,vertical,horizontal,stack";
          window_border_width = "1.0pt";
          window_margin_width = "5 5 3 5";
          inactive_text_alpha = "0.6";
          # behavior is up to compositor, but Niri needs decoration to support transparency
          hide_window_decorations = if pkgs.stdenv.hostPlatform.isDarwin then "titlebar-only" else "no";

          tab_bar_edge = "bottom";
          tab_bar_style = "custom";
          tab_powerline_style = "round";
          tab_bar_align = "center";
          tab_bar_min_tabs = 1;
          tab_separator = " ";
          tab_title_max_length = 0;
          tab_title_template = "";
          active_tab_title_template = "";

          background_opacity = "0.90";
          background_blur = 30;
          dynamic_background_opacity = "yes";

          shell = "${pkgs.fish}/bin/fish --login --interactive";
          term = "xterm-kitty";

          macos_option_as_alt = "yes";

          kitty_mod = "ctrl+shift";
          clear_all_shortcuts = "yes";
        };

        extraConfig = ''
          scrollback_pager nvim -u NONE
            \ -c "set noswapfile"
            \ -c "set noautoread"
            \ -c "set scrollback=10000"
            \ -c "write! ~/.local/state/kitty-scrollback-buffer | term cat ~/.local/state/kitty-scrollback-buffer; sleep 100"
            \ -c "set clipboard+=unnamedplus"
            \ -c "xnoremap <SPACE>y \"+y"
            \ -c "tnoremap <ESC> <C-\\><C-n>"
            \ -c "nnoremap i <NOP>"
            \ -c "nnoremap q :qa!<CR>"
            \ -c "normal +G"
            \ -
        '';

        # 4. Keyboard Shortcuts
        keybindings = {
          "ctrl+a>ctrl+a" = "send_text all \\x01";

          # Clipboard
          "ctrl+shift+c" = "copy_to_clipboard";
          "cmd+c" = "copy_or_noop";
          "ctrl+shift+v" = "paste_from_clipboard";
          "cmd+v" = "paste_from_clipboard";

          # Scrolling
          "ctrl+shift+h" = "show_scrollback";
          "ctrl+a>[" = "show_scrollback";
          "ctrl+shift+g" = "show_last_command_output";
          "ctrl+a>]" = "show_last_command_output";

          # Window management
          "ctrl+shift+enter" = "new_window";
          "cmd+enter" = "new_window";
          "ctrl+a>enter" = "launch --location=hsplit --cwd=current";

          "ctrl+shift+n" = "new_os_window";
          "cmd+n" = "new_os_window";

          "ctrl+shift+w" = "close_window";
          "ctrl+a>x" = "close_window";

          "ctrl+a>h" = "previous_window";
          "ctrl+a>j" = "previous_window";
          "ctrl+a>p" = "previous_window";

          "ctrl+a>k" = "next_window";
          "ctrl+a>l" = "next_window";
          "ctrl+a>n" = "next_window";

          "ctrl+a>shift+h" = "move_window_backward";
          "ctrl+a>shift+j" = "move_window_backward";
          "ctrl+a>shift+p" = "move_window_backward";

          "ctrl+a>shift+k" = "move_window_forward";
          "ctrl+a>shift+l" = "move_window_forward";
          "ctrl+a>shift+n" = "move_window_forward";

          "ctrl+a>r" = "start_resizing_window";

          # Tab management
          "ctrl+shift+t" = "new_tab";
          "cmd+t" = "new_tab";
          "ctrl+a>c" = "launch --cwd=current --type=tab";

          "ctrl+shift+alt+t" = "set_tab_title";
          "shift+cmd+i" = "set_tab_title";
          "ctrl+a>," = "set_tab_title";

          # Number keys
          "ctrl+a>1" = "goto_tab 1";
          "ctrl+a>2" = "goto_tab 2";
          "ctrl+a>3" = "goto_tab 3";
          "ctrl+a>4" = "goto_tab 4";
          "ctrl+a>5" = "goto_tab 5";
          "ctrl+a>6" = "goto_tab 6";
          "ctrl+a>7" = "goto_tab 7";
          "ctrl+a>8" = "goto_tab 8";
          "ctrl+a>9" = "goto_tab 9";
          "cmd+1" = "goto_tab 1";
          "cmd+2" = "goto_tab 2";
          "cmd+3" = "goto_tab 3";
          "cmd+4" = "goto_tab 4";
          "cmd+5" = "goto_tab 5";
          "cmd+6" = "goto_tab 6";
          "cmd+7" = "goto_tab 7";
          "cmd+8" = "goto_tab 8";
          "cmd+9" = "goto_tab 9";

          # Layout management
          "ctrl+shift+l" = "next_layout";
          "ctrl+a>o" = "next_layout";
          "ctrl+a>z" = "toggle_layout stack";

          # Font sizes
          "ctrl+shift+equal" = "change_font_size all +3.0";
          "ctrl+shift+plus" = "change_font_size all +2.0";
          "cmd+plus" = "change_font_size all +2.0";
          "cmd+equal" = "change_font_size all +2.0";
          "ctrl+shift+minus" = "change_font_size all -2.0";
          "cmd+minus" = "change_font_size all -1.0";
          "ctrl+shift+0" = "change_font_size all 0";
          "cmd+0" = "change_font_size all 0";

          # Select and act on visible text
          "ctrl+shift+e" = "open_url_with_hints";
          "ctrl+shift+p>shift+f" = "kitten hints --type path";

          # Miscellaneous
          "cmd+`" = "macos_cycle_through_os_windows";
          "cmd+shift+`" = "macos_cycle_through_os_windows_backwards";
          "ctrl+a>:" = "kitty_shell window";
          "ctrl+shift+f5" = "load_config_file";
          "ctrl+cmd+," = "load_config_file";
          "cmd+h" = "hide_macos_app";
          "cmd+m" = "minimize_macos_window";
        };
      };

    };  # config block (due to having extra options) ends

  };  # flake module ends
}
