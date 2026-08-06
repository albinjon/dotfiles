# Deferred: `client.request` deprecation warnings

Neovim deprecates dot-call access on `vim.lsp.Client` in favour of method-call.
Removal is scheduled for **0.13**:

```lua
-- /usr/share/nvim/runtime/lua/vim/lsp/client.lua:264
vim.deprecate('client.' .. name, 'client:' .. name, '0.13')
```

Symptom: `client.request is deprecated. Run ":checkhealth vim.deprecated" for more information`

Fixed by updating the plugins (`:Lazy sync`):

- `trouble.nvim` → `bd67efe`, which includes `7fe0ca6` "fix(lsp): deprecated warnings".
- `nvim-nio` → `edcc181`, now uses `client:request`.

The one below is still outstanding.

## tailwind-tools.nvim

Deprecated dot-calls in `lua/tailwind-tools/lsp.lua`:

- `:121` — `client.request("@/tailwindCSS/sortSelection", ...)`
- `:212` — `client.request("textDocument/documentColor", ...)`

No upstream fix exists: the pinned commit `fbe9829` (2025-05-23) is still the newest
commit touching that file. The plugin loads eagerly (no lazy trigger in
`lua/plugins/tailwind.lua`) and fires `documentColor` on `LspAttach`, so it is the
most likely source of the warning at startup in a Tailwind project.

Options when 0.13 gets close:

- Monkey-patch `require('tailwind-tools.lsp')` after the plugin loads.
- Vendor a fork with `client:request(...)`.
- File / land an upstream PR (the fix is a two-character change on each line).

Note the deprecation shim (`client.lua:256-263`) only warns when the first argument
is *not* the client itself, so `client:request(...)` — or even
`local r = client.request; r(client, ...)`, which is how trouble.nvim fixed it — is
enough to silence it.
