local ls = require('luasnip')
local snippet = ls.s

local cond = require('luasnip.extras.conditions')
local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep

local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local mathzone = cond.make_condition(function()
  return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
end)

ls.add_snippets("tex", {
  -- Begin env
  snippet({trig = "^beg", regTrig = true}, fmt([[
  \begin{{{}}}
    {}
  \end{{{}}}
  ]], {
      i(1, "document"),
      i(0),
      rep(1)
    })),

  -- Inline math
  snippet({trig = "mk", regTrig = true}, fmt([[
  ${}${}
  ]], {
      i(1),
      i(0)
    })),

  -- Math mode
  snippet({trig = "dm", regTrig = true}, fmt([[
  \[
    {}
  \] {}
  ]], {
      i(1),
      i(0)
    })),

  -- Subscript
  snippet({trig = "(%a)(%d)", regTrig = true, condition = mathzone}, f(function(_, snip)
    return snip.captures[1] .. "_" .. snip.captures[2]
  end)),

  snippet({trig = "(%a)_(%d%d)", regTrig = true, condition = mathzone}, f(function(_, snip)
    return snip.captures[1] .. "_{" .. snip.captures[2] .. "}"
  end)),

  -- Superscrits
  snippet({trig = "sr", wordTrig = false, condition = mathzone}, t("^2")),
  snippet({trig = "cb", wordTrig = false, condition = mathzone}, t("^3")),
  snippet({trig = "td", wordTrig = false, condition = mathzone}, fmt("^{{{}}}{}", {i(1), i(0)})),

  -- Fractions
  snippet({trig = "//", condition = mathzone}, fmt("\\frac{{{}}}{{{}}}{}", {i(1), i(2), i(3)})),
  snippet({trig = "((\\d+)|(\\d*)(\\\\)?([A-Za-z]+)((\\^|_)(\\{\\d+\\}|\\d))*)/", trigEngine = "ecma", condition = mathzone}, fmt("\\frac{{{}}}{{{}}}{}", {
    f(function(_, snip) return snip.captures[1] end),
    i(1),
    i(0)
  })),
  snippet({trig = "^.*\\)/", trigEngine = "ecma", condition = mathzone}, fmt("{}{{{}}}{}", {f(function(_, snip)
    local stripped = snip.env.LS_TRIGGER:sub(1, -2)
    local depth = 0
    local j = #stripped
    
    while true do
      if stripped:sub(j, j) == ")" then
        depth = depth + 1
      end
      if stripped:sub(j, j) == "(" then
        depth = depth -1
      end
      if depth == 0 then
        break
      end
      j = j - 1
    end
    return stripped:sub(1, j - 1) .. "\\frac{" .. stripped:sub(j + 1, -2) .. "}"
  end),
  i(1),
  i(0)
  })),

  -- Vector, hat, bar
  snippet({trig = "bar", wordTrig = false, priority = 10, condition = mathzone}, fmt("\\overline{{{}}}{}", {
    i(1),
    i(0)
  })),

  snippet({trig = "(%a)bar", regTrig = true, wordTrig = false, priority = 100, condition = mathzone}, f(function(_, snip)
    return "\\overline{" .. snip.captures[1] .. "}"
  end)),

  snippet({trig = "hat", wordTrig = false, priority = 10, condition = mathzone}, fmt("\\hat{{{}}}{}", {
    i(1),
    i(0)
  })),

  snippet({trig = "(%a)hat", regTrig = true, wordTrig = false, priority = 100, condition = mathzone}, f(function(_, snip)
    return "\\hat{" .. snip.captures[1] .. "}"
  end)),

  snippet({trig = "(%a+),%.", regTrig = true, wordTrig = false, condition = mathzone}, f(function(_, snip)
    return "\\vec{" .. snip.captures[1] .. "}"
  end)),

  -- Others
  snippet({trig = "(?<!\\\\)(sin|cos|arccot|cot|csc|ln|log|exp|star|perp)", trigEngine = "ecma", condition = mathzone}, f(function(_, snip)
    return "\\" .. snip.captures[1]
  end)),

  snippet({trig = "(?<!\\\\)(arcsin|arccos|arctan|arccot|arccsc|arcsec|pi|zeta|int)", trigEngine = "ecma", condition = mathzone}, f(function(_, snip)
    return "\\" .. snip.captures[1]
  end)),

  snippet({trig = "sq", wordTrig = false, condition = mathzone}, {t("\\sqrt{"), i(1), t("}", i(0))}),

  snippet({trig = "norm", wordTrig = false, condition = mathzone}, fmt("|{}|{}", {i(1), i(0)})),

  snippet({trig = "xx", wordTrig = false, condition = mathzone}, t("\\times")),

  snippet({trig = "->", wordTrig = false, condition = mathzone}, t("\\to")),

  snippet({trig = "<->", wordTrig = false, condition = mathzone}, t("\\leftrightarrow")),

  snippet({trig = "!>", wordTrig = false, condition = mathzone}, t("\\mapsto")),

  snippet({trig = "invs", wordTrig = false, condition = mathzone}, t("^{-1}")),

  snippet({trig = "lim", snippetType = "snippet"}, fmt("\\lim_{{{} \\to {}}}", {
    i(1, "x"),
    i(2, "\\infty")
  })),

  snippet({trig = "ooo", wordTrig = false}, t("\\infty")),

  snippet({trig = "<=", wordTrig = false}, t("\\le")),

  snippet({trig = ">=", wordTrig = false}, t("\\ge")),
}, {type = "autosnippets"})

ls.filetype_extend("plaintex", { "tex" })

-- vim: ts=2 sts=2 sw=2 et
