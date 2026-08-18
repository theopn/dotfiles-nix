{ ... }:

{
  programs.nixvim = {
    opts = {
      # Tab
      # how many chars the cursor moves with <TAB> and <BS>; 0 to disable
      softtabstop = 0;
      expandtab = true; # yeah what about it?
      shiftwidth = 2;
      # make indentation a multiple of shiftwidth when using < / >
      shiftround = true;

      # Location in the buffer
      number = true;
      relativenumber = true;
      cursorline = true;
      # line, screenline, or number,line
      cursorlineopt = "number";
      cursorcolumn = true;

      # Search and replace
      ignorecase = true;
      # /smartcase -> apply ignorecase | /sMartcase -> no ignorecase
      smartcase = true;
      inccommand = "split";

      # Split
      splitright = true;  # for vsplit
      splitbelow = true;  # for hsplit

      # UI
      signcolumn = "yes";
      scrolloff = 10;  # roughly 20-25 lines above/below, so 10 is good
      termguicolors = true;
      showtabline = 2;  # always show
      laststatus = 3;   # global statusline

      # Char rendering
      list = true;
      listchars = {
        tab = "⇥ ";
        trail = "␣";
        nbsp = "⍽";
      };
      # render beginning of wrapped line
      showbreak = "↪";
      # wrapped line has the same indentation as the beginning
      breakindent = true;

      # Spell
      # enabling will be done in filetype autocmd
      spelllang = [ "en" ];
      spellsuggest = "best,8";
      # ConsiderCamelCaseForSpellCheck
      spelloptions = "camel";

      # Fold
      foldenable = false;
      foldmethod = "marker";

      # Update time
      updatetime = 250;
      timeoutlen = 300;

      # Window size
      winminwidth = 3;

      # Completion
      # behavior of <TAB> in cmd completion: no pre-select, match full completion
      wildmode = "noselect:full";
      # no pre-insert or pre-select, show menu even with 1 item, use popup
      completeopt = "noselect,menu,menuone,popup";

      # Others
      mouse = "a";
      confirm = true;
    };
  };
}
