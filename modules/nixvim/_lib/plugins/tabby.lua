local theme = {
  fill = "TabLineFill",
  head = "MiniTablineCurrent",
  current_tab = "TabLineSel",
  tab = "TabLine",
  win = "TabLine",
  tail = "TabLine",
}

require("tabby").setup({
  line = function(line)
    return {
      {
        { " Theo ", hl = theme.head },
        line.sep("", theme.head, theme.fill),
      },
      line.tabs().foreach(function(tab)
        local hl = tab.is_current() and theme.current_tab or theme.tab
        return {
          line.sep("", hl, theme.fill),
          tab.is_current() and "" or "󰆣",
          tab.number(),
          tab.name(),
          tab.close_btn(""),
          line.sep("", hl, theme.fill),
          hl = hl,
          margin = " ",
        }
      end),
      line.spacer(),
      line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
        return {
          line.sep("", theme.win, theme.fill),
          win.is_current() and "" or "",
          win.buf().file_icon(),
          win.buf_name(),
          win.buf().is_changed() and "" or "",
          line.sep("", theme.win, theme.fill),
          hl = theme.win,
          margin = " ",
        }
      end),
      {
        line.sep("", theme.tail, theme.fill),
        { "  ", hl = theme.tail },
      },
      hl = theme.fill,
    }
  end,
  -- option = {}, -- setup modules" option,
})
