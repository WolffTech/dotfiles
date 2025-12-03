return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "f-person/git-blame.nvim",
  },

  config = function()
    vim.g.gitblame_display_virtual_text = 0
    vim.g.gitblame_message_template    = "Git: <summary> • <sha> • <author>"
    vim.g.gitblame_date_format          = "%d/%m/%Y %H"
    vim.g.gitblame_message_when_not_committed = "*Uncommitted Changes* • You"

    local lualine = require("lualine")

    lualine.setup({
      options = {
        theme = "catppuccin",
        icons_enabled = true,
        component_separators = { left = " ", right = " " },
        section_separators   = { left = "", right = "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          "filename",
          { require("gitblame").get_current_blame_text,
            cond = require("gitblame").is_blame_text_available },
        },
        lualine_x = {
          { require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = { fg = "#fab387" } },
          "encoding", "fileformat", "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_c = { "filename" },
        lualine_x = { "location" },
      },
    })

    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "catppuccin",
      callback = function()
        lualine.setup(lualine.get_config())
      end,
    })
  end,
}

