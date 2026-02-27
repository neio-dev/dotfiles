return {
    'L3MON4D3/LuaSnip',
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        local ls = require("luasnip")
        local s = ls.snippet
        local t = ls.text_node

        ls.add_snippets("php", {
            s("pubf", { t("public function ") }),
            s("privf", { t("private function ") }),
            s("protf", { t("protected function ") }),
        })
    end,
}
