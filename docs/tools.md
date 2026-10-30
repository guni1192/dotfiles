# 残しているもの

GitHub Actions のワークフローは無い。

## CLI

- neovim: エディタ本体。設定は `nvim/`。
- fzf: `repos` / `gwt` と git の `co` で一覧を選ぶ。
- ghq: `repos` と `git` の `ghq.root`。
- gh: GitHub の CLI。Cursor の許可リストにある。
- ripgrep: Cursor の許可リストにある検索。
- kubectl: `zsh/kubernetes.zsh` の別名と補完、プロンプトの current-context。
- node: pnpm の実行に要る。
- tree-sitter: CLI を呼ぶ記述は無い。Neovim のパーサはプラグインの `:TSUpdate`。残すと決めたので入れたまま。
- terraform-ls: `lsp.lua` の terraform。
- lua-language-server: `lsp.lua` の Lua。
- rust-analyzer: `lsp.lua` の Rust。cargo と clippy を見る。
- yq: Cursor の許可リストにある YAML の CLI。
- gitleaks: git hook は無い。残すと決めたので入れたまま。
- herdr: 端末のワークスペース。設定は `herdr/config.toml`。
- copilot-language-server: `lsp.lua` の Copilot。
- pnpm: パッケージマネージャ。Cursor の許可リストにある。
- go: Go のツールチェーン。gopls の `go install` にも要る。
- gopls: `lsp.lua` の Go。
- jq: `jql` と `scripts/setup-git-local.sh`。
- rustup: Rust のツールチェーン。`zshenv` が `~/.cargo/env` を読む。
- claude: herdr が起動する。aqua は初回だけ。更新は `stable` チャネル。

## Neovim プラグイン

- lazy.nvim: プラグインの読み込み。初回 clone は `lazy-lock.json` の commit。
- nvim-tree: ファイルツリー。`<C-e>`。
- nvim-web-devicons: nvim-tree、bufferline、fzf-lua のアイコン。
- fzf-lua: `<c-f>` のファイルと grep。
- nvim-lspconfig: LSP の土台。
- lualine: ステータスライン。`appearance.lua`。
- bufferline: バッファの並び。`appearance.lua` の `<C-n>` / `<C-p>`。
- nvim-autopairs: 挿入モードで括弧を閉じる。
- live-preview.nvim: `LivePreview`。markdown など。
- nightfox.nvim: カラースキーム `carbonfox`。
- nvim-treesitter: ハイライトとインデント。パーサのリビジョンはロックしない。
- nvim-treesitter-textobjects: `]f` などの移動。

## シェルプラグイン

- zinit: プラグインの読み込み。commit 固定。
- zsh-256color: 256 色。`TERM` は `zshenv` でも `xterm-256color`。残すと決めた。
- zsh-autosuggestions: 入力中に履歴の続きを出す。
- zsh-syntax-highlighting: コマンドラインに色を付ける。
- zsh-completions: 追加の補完。

## 入れていないが設定は残したもの

- Cursor エディタの `cursor/permissions.json`、`cursor/hooks.json`、`cursor/cli-config.json`。IDE の許可と hooks。`zsh/cursor.zsh` は `cursor-agent` 専用だったので削除した。cursor-cli パッケージは入れない。
