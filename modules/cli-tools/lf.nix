{
  flake.modules.homeManager.lf = { pkgs, ... }:

  let
    previewer = pkgs.writeShellScriptBin "pv.sh" ''
      file="$1"
      w="$2"
      h="$3"
      x="$4"
      y="$5"

      case "$file" in
        *.tar*) tar tf "$file"; exit ;;
        *.zip) unzip -l "$file"; exit ;;
        *.pdf) pdftotext "$file" -; exit ;;
        *) ;;
      esac

      case "$(file -Lb --mime-type "$file")" in
        image/*)
          # Note the double single-quotes around the width/height variables
          # to prevent Nix from trying to evaluate them.
          kitten icat --stdin no --transfer-mode memory --place "''${w}x''${h}@''${x}x''${y}" "$file" </dev/null >/dev/tty
          exit 1
          ;;
        text/*)
          bat --color=always --style=plain --pager=never "$file"
          exit
          ;;
        *) ;;
      esac

      echo '----- File Type Classification -----'
      file --dereference --brief -- "$file"
      echo '------------------------------------'
    '';

    cleaner = pkgs.writeShellScriptBin "cleaner.sh" ''
      kitten icat --clear --stdin no --transfer-mode memory </dev/null >/dev/tty
    '';

  in
  {
    home.packages = with pkgs; [
      poppler-utils  # pdftotext
    ];

    xdg.configFile."lf/icons".source = ./lf/icons;

    programs.lf = {
      enable = true;

      settings = {
        preview = true;
        drawbox = false;
        hidden = true;
        icons = true;
        ignorecase = true;
        incsearch = true;
        mouse = false;
        number = true;
        relativenumber = true;
        smartcase = true;
      };

      commands = {
        unarchive = ''
          ''${{
            set -f
            case "$f" in
                *.tar.bz|*.tar.bz2|*.tbz|*.tbz2) tar xjvf $f;;
                *.tar.gz|*.tgz) tar xzvf $f;;
                *.tar.xz|*.txz) tar xJvf $f;;
                *.zip) unzip $f;;
                *.rar) unrar x $f;;
                *.7z) 7z x $f;;
                *) echo "Unsupported format" ;;
            esac
          }}
        '';

        tar = ''
          ''${{
            set -f
            mkdir $1
            cp -r $fx $1
            tar czf $1.tar.gz $1
            rm -rf $1
          }}
        '';

        zip = ''
          ''${{
            set -f
            mkdir $1
            cp -r $fx $1
            zip -r $1.zip $1
            rm -rf $1
          }}
        '';

        choose_editor = ''
          ''${{
            printf ' Editor to open the file with: '
            read ans
            $ans "$f"
          }}
        '';

        mkfile = ''
          ''${{
            if [ -z $1 ]; then
              printf ' File Name: '
              read ans
              $EDITOR $ans
            else
              $EDITOR $1
            fi
          }}
        '';

        chmod = ''
          %{{
            printf ' Mode Bits: '
            read ans

            for file in $fx; do
              chmod $ans $file
            done

            lf -remote 'send reload'
          }}
        '';

        fzf_jump = ''
          ''${{
            res="$(find . -maxdepth 3 | fzf --reverse --header='Jump to location')"
            if [ -f "$res" ]; then
              cmd="select"
            elif [ -d "$res" ]; then
              cmd="cd"
            fi
            lf -remote "send $id $cmd \"$res\""
          }}
        '';

        trash = ''
          !{{
            export THEOSHELL_TRASH_DIR="$HOME/.local/share/theoshell/trash"
            if [ ! -d ''${THEOSHELL_TRASH_DIR} ]; then
              mkdir -p ''${THEOSHELL_TRASH_DIR}
            fi
            IFS="$(printf '\n\t')"; mv $fx ''${THEOSHELL_TRASH_DIR} && printf ":) $fx moved to trash!\n" || printf ":( Failed to move $fx to trash\n"
          }}
        '';

        rm = ''
          ''${{
            set -f
            printf "$fx\n"
            printf "delete?[y/n]"
            read ans
            [ "$ans" = "y" ] && rm -rf $fx
          }}
        '';
      };

      keybindings = {
        "gs" = "!git status";
        "DD" = "trash";
        "i" = "$ ${previewer}/bin/pv.sh $f | less -R";
      };

      extraConfig = ''
        set previewer ${previewer}/bin/pv.sh
        set cleaner ${cleaner}/bin/cleaner.sh

        # Unbinds default bindings to use as prefixes
        map e
        map m
        map f

        # multi-key to prevent accidental key press
        map ff fzf_jump

        map ee $$EDITOR "$f"
        map ec choose_editor

        map ml mark-load
        map mr mark-remove
        map ms mark-save

        map mf mkfile
        map md :push %mkdir<space>
        map mo chmod
      '';
    };

  };  # flake module ends
}
