local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s("card", {
    t("# "), i(1, "CardName"), t({ "", "## Front", "" }),
    i(2, "1. Definition"), t({ "", "## Back", "" }),
    i(3, "1. Definition:")
  }),
}

