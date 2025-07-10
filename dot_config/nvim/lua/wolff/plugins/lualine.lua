return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "f-person/git-blame.nvim",
  },
  config = function()
    vim.g.gitblame_display_virtual_text        = 0
    vim.g.gitblame_message_template            = "Git: <summary> - <sha> - <author>"
    vim.g.gitblame_date_format                 = "%d/%m/%Y %H"
    vim.g.gitblame_message_when_not_committed  = "*Uncommitted Changes* - You"

    local dark_colors = {
      grey   = "#757575"; gold   = "#afaf5f"; pink   = "#bC8cff";
      blue   = "#5f87af"; orange = "#d75f00"; fg     = "#FFFFFF";
      mg     = "#4B4B4B"; bg     = "#101010"; xg     = "#212121";
      middle = "#bcbcbc";
    }
    local light_colors = {
      grey   = "#757575"; gold   = "#afaf5f"; pink   = "#824fde";
      blue   = "#5f87af"; orange = "#d75f00"; fg     = "#000000";
      mg     = "#9E9E9E"; bg     = "#FFFFFF"; xg     = "#F5F5F5";
      middle = "#4B4B4B";
    }

    local function get_lualine_theme()
      local mode = vim.g.my_theme_mode or "dark"
      local C = (mode == "light") and light_colors or dark_colors
      local NONE = "NONE"

      return {
        normal = {
          a = { bg = C.grey, fg = C.bg, gui = "bold" },
          b = { bg = C.mg, fg = C.fg },
          c = { bg = C.bg, fg = C.fg },
          x = { bg = C.xg, fg = C.fg },
        },
        insert = {
          a = { bg = C.gold, fg = C.bg, gui = "bold" },
          b = { bg = C.mg, fg = C.fg },
          c = { bg = C.bg, fg = C.fg },
          x = { bg = C.xg, fg = C.fg },
        },
        visual = {
          a = { bg = C.pink, fg = C.bg, gui = "bold" },
          b = { bg = C.mg, fg = C.fg },
          c = { bg = C.bg, fg = C.fg },
          x = { bg = C.xg, fg = C.fg },
        },
        command = {
          a = { bg = C.grey, fg = C.bg, gui = "bold" },
          b = { bg = C.mg, fg = C.fg },
          c = { bg = C.bg, fg = C.fg },
          x = { bg = C.xg, fg = C.fg },
        },
        replace = {
          a = { bg = C.blue, fg = C.bg, gui = "bold" },
          b = { bg = C.mg, fg = C.fg },
          c = { bg = C.bg, fg = C.fg },
          x = { bg = C.xg, fg = C.fg },
        },
        inactive = {
          a = { bg = C.bg, fg = C.middle, gui = "bold" },
          b = { bg = C.bg, fg = C.middle },
          c = { bg = C.bg, fg = C.middle },
        },
      }
    end

    local function setup_lualine()
      local lualine      = require("lualine")
      local lazy_status  = require("lazy.status")
      local git_blame    = require("gitblame")
      local theme        = get_lualine_theme()

      lualine.setup {
        options = {
          icons_enabled     = true,
          theme             = theme,
          component_separators = { left = " ", right = " " },
          section_separators   = { left = "", right = "" },
          always_divide_middle = true,
          refresh = {
            statusline = 1000, tabline = 1000, winbar = 1000,
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = {
            "filename",
            { git_blame.get_current_blame_text,
              cond = git_blame.is_blame_text_available },
          },
          lualine_x = {
            { lazy_status.updates,
              cond  = lazy_status.has_updates,
              color = {
                fg = (vim.g.my_theme_mode == "light")
                     and light_colors.orange
                     or dark_colors.orange,
              },
            },
            "encoding", "fileformat", "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_c = { "filename" },
          lualine_x = { "location" },
        },
      }
    end

    setup_lualine()

    vim.api.nvim_create_autocmd("User", {
      pattern  = "MyThemeChanged",
      callback = setup_lualine,
    })
  end,
}

