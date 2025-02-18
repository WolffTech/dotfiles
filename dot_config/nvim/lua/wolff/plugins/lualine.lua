return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "f-person/git-blame.nvim" },
  config = function()
    -- Git blame plugin configuration
    vim.g.gitblame_display_virtual_text = 0
    vim.g.gitblame_message_template = "Git: <summary> - <sha> - <author>"
    vim.g.gitblame_date_format = "%d/%m/%Y %H"
    vim.g.gitblame_message_when_not_committed = "*Uncommitted Changes* - You"

    local dark_colors = {
      grey    = "#757575",
      gold    = "#afaf5f",
      pink    = "#afaf5f",
      blue    = "#5f87af",
      orange  = "#d75f00",
      fg      = "#FFFFFF",
      mg      = "#4B4B4B",
      bg      = "#101010",
      xg      = "#212121",
      middle  = "#bcbcbc",
    }

    local light_colors = {
      grey    = "#757575",
      gold    = "#afaf5f",
      pink    = "#afaf5f",
      blue    = "#5f87af",
      orange  = "#d75f00",
      fg      = "#000000",
      mg      = "#9E9E9E",
      bg      = "#FFFFFF",
      xg      = "#F5F5F5",
      middle  = "#4B4B4B",
    }

    local function get_lualine_theme()
      if vim.o.background == "light" then
        return {
          normal = {
            a = { bg = light_colors.grey, fg = light_colors.bg, gui = "bold" },
            b = { bg = light_colors.mg, fg = light_colors.fg },
            c = { bg = none, fg = light_colors.fg },
            x = { bg = light_colors.xg, fg = light_colors.fg },
          },
          insert = {
            a = { bg = light_colors.gold, fg = light_colors.bg, gui = "bold" },
            b = { bg = light_colors.mg, fg = light_colors.fg },
            c = { bg = none, fg = light_colors.fg },
            x = { bg = light_colors.xg, fg = light_colors.fg },
          },
          visual = {
            a = { bg = light_colors.pink, fg = light_colors.bg, gui = "bold" },
            b = { bg = light_colors.mg, fg = light_colors.fg },
            c = { bg = none, fg = light_colors.fg },
            x = { bg = light_colors.xg, fg = light_colors.fg },
          },
          command = {
            a = { bg = light_colors.grey, fg = light_colors.bg, gui = "bold" },
            b = { bg = light_colors.mg, fg = light_colors.fg },
            c = { bg = none, fg = light_colors.fg },
            x = { bg = light_colors.xg, fg = light_colors.fg },
          },
          replace = {
            a = { bg = light_colors.blue, fg = light_colors.bg, gui = "bold" },
            b = { bg = light_colors.mg, fg = light_colors.fg },
            c = { bg = none, fg = light_colors.fg },
            x = { bg = light_colors.xg, fg = light_colors.fg },
          },
          inactive = {
            a = { bg = light_colors.bg, fg = light_colors.middle, gui = "bold" },
            b = { bg = light_colors.bg, fg = light_colors.middle },
            c = { bg = light_colors.bg, fg = light_colors.middle },
          },
        }
      else
        return {
          normal = {
            a = { bg = dark_colors.grey, fg = dark_colors.bg, gui = "bold" },
            b = { bg = dark_colors.mg, fg = dark_colors.fg },
            c = { bg = none, fg = dark_colors.fg },
            x = { bg = dark_colors.xg, fg = dark_colors.fg },
          },
          insert = {
            a = { bg = dark_colors.gold, fg = dark_colors.bg, gui = "bold" },
            b = { bg = dark_colors.mg, fg = dark_colors.fg },
            c = { bg = none, fg = dark_colors.fg },
            x = { bg = dark_colors.xg, fg = dark_colors.fg },
          },
          visual = {
            a = { bg = dark_colors.pink, fg = dark_colors.bg, gui = "bold" },
            b = { bg = dark_colors.mg, fg = dark_colors.fg },
            c = { bg = none, fg = dark_colors.fg },
            x = { bg = dark_colors.xg, fg = dark_colors.fg },
          },
          command = {
            a = { bg = dark_colors.grey, fg = dark_colors.bg, gui = "bold" },
            b = { bg = dark_colors.mg, fg = dark_colors.fg },
            c = { bg = none, fg = dark_colors.fg },
            x = { bg = dark_colors.xg, fg = dark_colors.fg },
          },
          replace = {
            a = { bg = dark_colors.blue, fg = dark_colors.bg, gui = "bold" },
            b = { bg = dark_colors.mg, fg = dark_colors.fg },
            c = { bg = none, fg = dark_colors.fg },
            x = { bg = dark_colors.xg, fg = dark_colors.fg },
          },
          inactive = {
            a = { bg = dark_colors.bg, fg = dark_colors.middle, gui = "bold" },
            b = { bg = dark_colors.bg, fg = dark_colors.middle },
            c = { bg = dark_colors.bg, fg = dark_colors.middle },
          },
        }
      end
    end

    local function setup_lualine()
      local lualine = require("lualine")
      local lazy_status = require("lazy.status")
      local git_blame = require("gitblame")
      local chosen_theme = get_lualine_theme()

      lualine.setup {
        options = {
          icons_enabled = true,
          theme = chosen_theme,
          component_separators = { left = " ", right = " " },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = {
            { "filename" },
            {
              git_blame.get_current_blame_text,
              cond = git_blame.is_blame_text_available,
            },
          },
          lualine_x = {
            {
              lazy_status.updates,
              cond = lazy_status.has_updates,
              color = {
                fg = vim.o.background == "light" and light_colors.orange or dark_colors.orange,
              },
            },
            "encoding",
            "fileformat",
            "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      }

      vim.notify("lualine configured for '" .. vim.o.background .. "' background")
    end

    setup_lualine()

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        setup_lualine()
      end,
    })
  end,
}
