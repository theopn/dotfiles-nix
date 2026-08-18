{
  flake.modules.homeManager.fish = {

    programs.fish = {
      enable = true;

      shellAbbrs = {
        cl = "clear";

        ga = "git add";
        gcm = "git commit -m";
        gss = "git status";

        nv = "neovide --fork";
        v = "nvim";
        weather = "curl 'https://wttr.in'";

        # used in the `multicd` function below
        dotdot = {
          regex = "^\\.\\.+$";
          function = "multicd";
        };
      };

      # Non-expanding aliases like traditional shell.
      # long command can go here to declutter the terminal.
      shellAliases = {
        # --git and --total-size are also useful, but omitted for performance
        l = "eza --color=auto --icons=auto  --long --all --header --time-style=long-iso";
      };

      functions = {
        multicd = {
            description = ".. to cd .., ... to cd ../.., etc.";
            body = ''
              echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
            '';
        };

        mkcd = ''
          command mkdir $argv
          if [ $status = 0 ]
            switch $argv[(count $argv)]
              case '-*'

              case '*'
                cd $argv[(count $argv)]
                return
            end
          end
        '';

        numfiles = ''
          set -l num $(ls -A $argv | wc -l)
          [ -n $num ]; and echo "$num files in $argv"
        '';

        tarmake = "tar -czvf $argv[1].tar.gz $argv[1]";
        tarunmake = "tar -zxvf $argv[1]";

        ln_resolve = {
          description = "Create a symlink using absolute path";
          body = ''
            if test (count $argv) -ne 2
              echo "Usage: ln_resolve <source> <target>"
              return 1
            end
            set -l source (realpath $argv[1])
            set -l target (realpath $argv[2])

            ln -s "$source" "$target"

            if test $status -eq 0
              echo "Symlink created: $target -> $source"
            end
            '';
        };

        fish_greeting ={
          description = "OLIVER SAYS HI";
          body = ''
            # Colors
            set -l normal (set_color normal)
            set -l cyan (set_color -o cyan)
            set -l brcyan (set_color -o brcyan)
            set -l green (set_color -o green)
            set -l brgreen (set_color -o brgreen)
            set -l red (set_color -o red)
            set -l brred (set_color -o brred)

            set -l blue (set_color -o blue)
            set -l brblue (set_color -o brblue)
            set -l magenta (set_color -o magenta)
            set -l brmagenta (set_color -o brmagenta)
            set -l yellow (set_color -o yellow)
            set -l bryellow (set_color -o bryellow)

            set -l beige (set_color -o bba592)

            # Collection of Oliver ASCII arts
            set -l olivers \
            '
                \/   \/
                |\__/,|     _
              _.|o o  |_   ) )
              -(((---(((--------
              ' \
              '
                \/       \/
                /\_______/\
                /   o   o   \
              (  ==  ^  ==  )
                )           (
              (             )
              ( (  )   (  ) )
              (__(__)___(__)__)
              ' \
              '
                                    _
                    |\      _-``---,) )
              ZZZzz /,`.-```    -.   /
                  |,4-  ) )-,_. ,\ (
                  ---``(_/--`  `-`\_)
              ' \
              # Thanks Jonathan for the one below
              '
                    \/ \/
                    /\_/\ _______
                  = o_o =  _ _  \     _
                  (__^__)   __(  \.__) )
                (@)<_____>__(_____)____/
                  ♡ ~~ ♡ OLIVER ♡ ~~ ♡
              ' \
              '
                \/   \/
                |\__/,|        _
                |_ _  |.-----.) )
                ( T   ))        )
                (((^_(((/___(((_/
              ' \
              '
              You found the only "fish" that Oliver could not eat!
                    .
                    ":"
                  ___:____     |"\/"|
                ,`        `.    \  /
                |  O        \___/  |
              ~^~^~^~^~^~^~^~^~^~^~^~^~
              '
            set -l oliver "$(random choice $olivers)" # will break new line without the quotes

            # Other information
            set -l fish_ver $(fish --version)
            set -l uptime $(uptime | grep -ohe 'up .*' | sed 's/,//g' | awk '{ print $2" "$3 " " }')

            # Print the msg
            echo
            echo -e "  " "$brgreen"  "Meow"                              "$normal"
            echo -e "  " "$beige"    "$oliver"                           "$normal"
            echo -e "  " "$cyan"     "  Shell:\t"   "$brcyan$fish_ver"  "$normal"
            echo -e "  " "$blue"     "  Uptime:\t"  "$brblue$uptime"    "$normal"
            echo
          '';
        };

      };

      interactiveShellInit = ''
        fish_vi_key_bindings
        set fish_cursor_default block
        set fish_cursor_insert line
        set fish_cursor_replace_one underscore
        set fish_cursor_visual block
        set fish_vi_force_cursor
      '';
    };

  };  # flake module ends
}
