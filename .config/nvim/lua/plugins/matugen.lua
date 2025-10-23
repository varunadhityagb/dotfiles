-- Matugen generated colorscheme for Neovim
-- Save template as: ~/.config/matugen/templates/matugen.lua
-- Generated file will be: ~/.config/nvim/lua/plugins/matugen.lua

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "matugen",
    },
  },
  {
    -- Define custom colorscheme
    dir = vim.fn.stdpath("config"),
    name = "matugen-colorscheme",
    lazy = false,
    priority = 1000,
    config = function()
      -- Matugen colors
      local colors = {
        -- Base colors
        background = "#0e1415",
        foreground = "#dee4e4",

        -- Surface colors
        surface = "#0e1415",
        surface_bright = "#343a3b",
        surface_container = "#1b2122",
        surface_container_high = "#252b2c",
        surface_container_highest = "#303637",
        surface_container_low = "#171d1e",
        surface_container_lowest = "#090f10",

        -- Primary colors
        primary = "#81d3df",
        primary_container = "#004f57",
        primary_fixed = "#9df0fb",
        primary_fixed_dim = "#81d3df",
        on_primary = "#00363c",
        on_primary_container = "#9df0fb",

        -- Secondary colors
        secondary = "#b1cbcf",
        secondary_container = "#324b4e",
        secondary_fixed = "#cde7eb",
        secondary_fixed_dim = "#b1cbcf",
        on_secondary = "#1c3438",
        on_secondary_container = "#cde7eb",

        -- Tertiary colors
        tertiary = "#b9c6ea",
        tertiary_container = "#3a4664",
        tertiary_fixed = "#d9e2ff",
        tertiary_fixed_dim = "#b9c6ea",
        on_tertiary = "#23304d",
        on_tertiary_container = "#d9e2ff",

        -- Error colors
        error = "#ffb4ab",
        error_container = "#93000a",
        on_error = "#690005",
        on_error_container = "#ffdad6",

        -- Other colors
        outline = "#899294",
        outline_variant = "#3f484a",
        on_surface = "#dee4e4",
        on_surface_variant = "#bec8ca",
        inverse_surface = "#dee4e4",
        inverse_on_surface = "#2b3132",
        inverse_primary = "#006973",
        shadow = "#000000",
        scrim = "#000000",
      }

      -- Clear existing highlights
      vim.cmd("highlight clear")
      if vim.fn.exists("syntax_on") then
        vim.cmd("syntax reset")
      end

      vim.g.colors_name = "matugen"

      -- Helper function to set highlights
      local function hl(group, opts)
        vim.api.nvim_set_hl(0, group, opts)
      end

      -- Editor colors
      hl("Normal", { fg = colors.foreground, bg = "NONE" })
      hl("NormalFloat", { fg = colors.foreground, bg = "NONE" })
      hl("NormalNC", { fg = colors.foreground, bg = "NONE" })
      hl("SignColumn", { bg = "NONE" })
      hl("EndOfBuffer", { fg = colors.surface_container_high, bg = "NONE" })
      hl("MsgArea", { fg = colors.foreground, bg = "NONE" })
      hl("LineNr", { fg = colors.outline })
      hl("CursorLineNr", { fg = colors.primary, bold = true })
      hl("CursorLine", { bg = colors.surface_container_low })
      hl("ColorColumn", { bg = colors.surface_container })
      hl("Cursor", { fg = colors.background, bg = colors.foreground })
      hl("Visual", { bg = colors.primary_container })
      hl("VisualNOS", { bg = colors.primary_container })
      hl("Search", { fg = colors.on_primary_container, bg = colors.primary_container })
      hl("IncSearch", { fg = colors.on_primary, bg = colors.primary })
      hl("CurSearch", { fg = colors.on_primary, bg = colors.primary })
      hl("MatchParen", { fg = colors.primary, bold = true })
      hl("Folded", { fg = colors.on_surface_variant, bg = colors.surface_container })
      hl("FoldColumn", { fg = colors.outline, bg = "NONE" })

      -- Statusline
      hl("StatusLine", { fg = colors.on_surface, bg = colors.surface_container_high })
      hl("StatusLineNC", { fg = colors.on_surface_variant, bg = colors.surface_container })

      -- Tabline
      hl("TabLine", { fg = colors.on_surface_variant, bg = colors.surface_container })
      hl("TabLineFill", { bg = colors.surface })
      hl("TabLineSel", { fg = colors.on_surface, bg = colors.surface_container_highest })

      -- Popups
      hl("Pmenu", { fg = colors.on_surface, bg = colors.surface_container_high })
      hl("PmenuSel", { fg = colors.on_primary_container, bg = colors.primary_container })
      hl("PmenuSbar", { bg = colors.surface_container })
      hl("PmenuThumb", { bg = colors.outline })

      -- Syntax highlighting
      hl("Comment", { fg = colors.outline, italic = true })
      hl("Constant", { fg = colors.tertiary })
      hl("String", { fg = colors.secondary })
      hl("Character", { fg = colors.secondary })
      hl("Number", { fg = colors.tertiary_fixed_dim })
      hl("Boolean", { fg = colors.tertiary })
      hl("Float", { fg = colors.tertiary_fixed_dim })

      hl("Identifier", { fg = colors.primary_fixed_dim })
      hl("Function", { fg = colors.primary })

      hl("Statement", { fg = colors.primary })
      hl("Conditional", { fg = colors.primary })
      hl("Repeat", { fg = colors.primary })
      hl("Label", { fg = colors.primary })
      hl("Operator", { fg = colors.on_surface })
      hl("Keyword", { fg = colors.primary })
      hl("Exception", { fg = colors.error })

      hl("PreProc", { fg = colors.tertiary_fixed })
      hl("Include", { fg = colors.primary })
      hl("Define", { fg = colors.primary })
      hl("Macro", { fg = colors.tertiary })
      hl("PreCondit", { fg = colors.tertiary })

      hl("Type", { fg = colors.tertiary_fixed })
      hl("StorageClass", { fg = colors.primary })
      hl("Structure", { fg = colors.tertiary_fixed })
      hl("Typedef", { fg = colors.tertiary_fixed })

      hl("Special", { fg = colors.secondary_fixed })
      hl("SpecialChar", { fg = colors.secondary_fixed })
      hl("Tag", { fg = colors.primary })
      hl("Delimiter", { fg = colors.on_surface_variant })
      hl("SpecialComment", { fg = colors.outline_variant, italic = true })
      hl("Debug", { fg = colors.error })

      hl("Underlined", { underline = true })
      hl("Ignore", { fg = colors.outline })
      hl("Error", { fg = colors.error, bold = true })
      hl("Todo", { fg = colors.tertiary, bold = true })

      -- Diagnostics
      hl("DiagnosticError", { fg = colors.error })
      hl("DiagnosticWarn", { fg = colors.tertiary_fixed })
      hl("DiagnosticInfo", { fg = colors.primary })
      hl("DiagnosticHint", { fg = colors.secondary })
      hl("DiagnosticUnderlineError", { undercurl = true, sp = colors.error })
      hl("DiagnosticUnderlineWarn", { undercurl = true, sp = colors.tertiary_fixed })
      hl("DiagnosticUnderlineInfo", { undercurl = true, sp = colors.primary })
      hl("DiagnosticUnderlineHint", { undercurl = true, sp = colors.secondary })

      -- LSP
      hl("LspReferenceText", { bg = colors.surface_container_high })
      hl("LspReferenceRead", { bg = colors.surface_container_high })
      hl("LspReferenceWrite", { bg = colors.surface_container_high })

      -- Treesitter
      hl("@variable", { fg = colors.on_surface })
      hl("@variable.builtin", { fg = colors.tertiary })
      hl("@variable.parameter", { fg = colors.primary_fixed_dim })
      hl("@variable.member", { fg = colors.primary_fixed_dim })

      hl("@constant", { fg = colors.tertiary })
      hl("@constant.builtin", { fg = colors.tertiary })
      hl("@constant.macro", { fg = colors.tertiary })

      hl("@string", { fg = colors.secondary })
      hl("@string.escape", { fg = colors.secondary_fixed })
      hl("@string.special", { fg = colors.secondary_fixed })

      hl("@character", { fg = colors.secondary })
      hl("@number", { fg = colors.tertiary_fixed_dim })
      hl("@boolean", { fg = colors.tertiary })
      hl("@float", { fg = colors.tertiary_fixed_dim })

      hl("@function", { fg = colors.primary })
      hl("@function.builtin", { fg = colors.primary })
      hl("@function.macro", { fg = colors.tertiary })
      hl("@function.method", { fg = colors.primary })

      hl("@keyword", { fg = colors.primary })
      hl("@keyword.function", { fg = colors.primary })
      hl("@keyword.operator", { fg = colors.primary })
      hl("@keyword.return", { fg = colors.primary })

      hl("@conditional", { fg = colors.primary })
      hl("@repeat", { fg = colors.primary })
      hl("@label", { fg = colors.primary })
      hl("@operator", { fg = colors.on_surface })
      hl("@exception", { fg = colors.error })

      hl("@type", { fg = colors.tertiary_fixed })
      hl("@type.builtin", { fg = colors.tertiary_fixed })
      hl("@type.qualifier", { fg = colors.primary })

      hl("@property", { fg = colors.primary_fixed_dim })
      hl("@attribute", { fg = colors.tertiary })

      hl("@constructor", { fg = colors.tertiary_fixed })
      hl("@namespace", { fg = colors.tertiary_fixed })

      hl("@comment", { fg = colors.outline, italic = true })
      hl("@punctuation.delimiter", { fg = colors.on_surface_variant })
      hl("@punctuation.bracket", { fg = colors.on_surface_variant })
      hl("@punctuation.special", { fg = colors.secondary_fixed })

      hl("@tag", { fg = colors.primary })
      hl("@tag.attribute", { fg = colors.tertiary_fixed_dim })
      hl("@tag.delimiter", { fg = colors.on_surface_variant })

      -- Git
      hl("DiffAdd", { fg = colors.secondary, bg = colors.secondary_container })
      hl("DiffChange", { fg = colors.tertiary, bg = colors.tertiary_container })
      hl("DiffDelete", { fg = colors.error, bg = colors.error_container })
      hl("DiffText", { fg = colors.tertiary_fixed, bg = colors.tertiary_container })

      hl("GitSignsAdd", { fg = colors.secondary })
      hl("GitSignsChange", { fg = colors.tertiary })
      hl("GitSignsDelete", { fg = colors.error })

      -- Telescope
      hl("TelescopeNormal", { fg = colors.foreground, bg = "NONE" })
      hl("TelescopeBorder", { fg = colors.outline, bg = "NONE" })
      hl("TelescopePromptBorder", { fg = colors.primary, bg = "NONE" })
      hl("TelescopePromptTitle", { fg = colors.on_primary, bg = colors.primary })
      hl("TelescopePreviewTitle", { fg = colors.on_secondary, bg = colors.secondary })
      hl("TelescopeResultsTitle", { fg = colors.on_tertiary, bg = colors.tertiary })
      hl("TelescopeSelection", { fg = colors.on_primary_container, bg = colors.primary_container })
      hl("TelescopeSelectionCaret", { fg = colors.primary, bg = colors.primary_container })
      hl("TelescopeMatching", { fg = colors.primary, bold = true })

      -- NvimTree / Neo-tree
      hl("NvimTreeNormal", { fg = colors.foreground, bg = "NONE" })
      hl("NvimTreeNormalNC", { fg = colors.foreground, bg = "NONE" })
      hl("NvimTreeRootFolder", { fg = colors.primary, bold = true })
      hl("NvimTreeFolderName", { fg = colors.primary })
      hl("NvimTreeFolderIcon", { fg = colors.primary })
      hl("NvimTreeEmptyFolderName", { fg = colors.outline })
      hl("NvimTreeOpenedFolderName", { fg = colors.primary })
      hl("NvimTreeIndentMarker", { fg = colors.outline })
      hl("NvimTreeGitDirty", { fg = colors.tertiary })
      hl("NvimTreeGitNew", { fg = colors.secondary })
      hl("NvimTreeGitDeleted", { fg = colors.error })

      -- WhichKey
      hl("WhichKey", { fg = colors.primary })
      hl("WhichKeyGroup", { fg = colors.tertiary_fixed })
      hl("WhichKeyDesc", { fg = colors.foreground })
      hl("WhichKeySeparator", { fg = colors.outline })
      hl("WhichKeyFloat", { bg = "NONE" })
      hl("WhichKeyBorder", { fg = colors.outline, bg = "NONE" })

      -- Noice
      hl("NoiceCmdlinePopup", { fg = colors.foreground, bg = "NONE" })
      hl("NoiceCmdlinePopupBorder", { fg = colors.primary, bg = "NONE" })
      hl("NoiceCmdlineIcon", { fg = colors.primary })

      -- Notify
      hl("NotifyBackground", { bg = colors.surface })
      hl("NotifyERRORBorder", { fg = colors.error })
      hl("NotifyWARNBorder", { fg = colors.tertiary_fixed })
      hl("NotifyINFOBorder", { fg = colors.primary })
      hl("NotifyDEBUGBorder", { fg = colors.outline })
      hl("NotifyTRACEBorder", { fg = colors.secondary })

      -- BufferLine
      hl("BufferLineBackground", { fg = colors.on_surface_variant, bg = "NONE" })
      hl("BufferLineBufferSelected", { fg = colors.on_surface, bg = "NONE", bold = true })
      hl("BufferLineBufferVisible", { fg = colors.on_surface_variant, bg = "NONE" })
      hl("BufferLineFill", { bg = "NONE" })
      hl("BufferLineIndicatorSelected", { fg = colors.primary, bg = "NONE" })

      -- Mini
      hl("MiniIndentscopeSymbol", { fg = colors.primary })
      hl("MiniStarterHeader", { fg = colors.primary })
      hl("MiniStarterFooter", { fg = colors.secondary })
      hl("MiniStarterSection", { fg = colors.tertiary })
    end,
  },
}
