# 補完機能を使用する
autoload -U compinit promptinit
compinit
zstyle ':completion::complete:*' use-cache true
zstyle ':completion:*:default' menu select=1

# 大文字、小文字を区別せず補完する
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 補完でカラーを使用する
autoload colors
zstyle ':completion:*' list-colors "${LS_COLORS}"

# kill の候補にも色付き表示
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'

# コマンドにsudoを付けても補完
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# 予測入力させる
autoload predict-on

# 入力途中の履歴補完を有効化する
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# "|,:"を単語の一部とみなさない
WORDCHARS="$WORDCHARS|:"

# タブキーの連打で自動的にメニュー補完
setopt AUTO_MENU
# 曖昧な補完で、自動的に選択肢をリストアップ
setopt AUTO_LIST
# 変数名を補完する
setopt AUTO_PARAM_KEYS
# プロンプト文字列で各種展開を行なう
setopt PROMPT_SUBST
# サスペンド中のプロセスと同じコマンド名を実行した場合はリジュームする
setopt AUTO_RESUME
# ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
setopt MARK_DIRS
# 補完対象のファイルの末尾に識別マークをつける
setopt LIST_TYPES
# BEEPを鳴らさない
setopt NO_BEEP
# 補完候補など表示する時はその場に表示し、終了時に画面から消す
setopt ALWAYS_LAST_PROMPT
# クォートされていない変数拡張が行われたあとで、フィールド分割
setopt SH_WORD_SPLIT
# 定義された全ての変数は自動的にexportする
setopt ALL_EXPORT
# ディレクトリ名を補完すると、末尾がスラッシュになる。
setopt AUTO_PARAM_SLASH
# 普通のcdでもスタックに入れる
setopt AUTO_PUSHD
# コマンドのスペルの訂正を使用する
setopt CORRECT
# aliasを展開して補完
unsetopt complete_aliases
# "*" にドットファイルをマッチ
unsetopt GLOB_DOTS
# 補完候補を詰めて表示
setopt LIST_PACKED
# ディレクトリスタックに、同じディレクトリを入れない
setopt PUSHD_IGNORE_DUPS
# 補完の時にベルを鳴らさない
setopt NO_LIST_BEEP
# ^Dでログアウトしないようにする
unsetopt IGNORE_EOF
# ジョブの状態をただちに知らせる
setopt NOTIFY
# 複数のリダイレクトやパイプに対応
setopt MULTIOS
# ファイル名を数値的にソート
setopt NUMERIC_GLOB_SORT
# =以降でも補完できるようにする
setopt MAGIC_EQUAL_SUBST
# 補完候補リストの日本語を正しく表示
setopt PRINT_EIGHT_BIT
# 右プロンプトに入力がきたら消す
setopt TRANSIENT_RPROMPT
# 戻り値が0以外の場合終了コードを表示
unsetopt PRINT_EXIT_VALUE
# echo {a-z}などを使えるようにする
setopt BRACE_CCL
# 余分な空白は詰めて記録
setopt HIST_IGNORE_SPACE
# ヒストリファイルを上書きするのではなく、追加するようにする
setopt APPEND_HISTORY
# 前のコマンドと同じならヒストリに入れない
setopt HIST_IGNORE_DUPS
# 重複するヒストリを持たない
setopt HIST_IGNORE_ALL_DUPS
# ヒストリを呼び出してから実行する間に一旦編集可能
unsetopt HIST_VERIFY
# 履歴をインクリメンタルに追加
setopt INC_APPEND_HISTORY
# history コマンドをヒストリに入れない
setopt HIST_NO_STORE
# 履歴から冗長な空白を除く
setopt HIST_REDUCE_BLANKS
# 改行コードで終らない出力もちゃんと出力する
setopt NO_PROMPTCR
# コマンドラインがどのように展開され実行されたかを表示する
unsetopt XTRACE
# コマンドラインでも # 以降をコメントと見なす
setopt INTERACTIVE_COMMENTS
# デフォルトの複数行コマンドライン編集ではなく、１行編集モードになる
unsetopt SINGLE_LINE_ZLE
# 語の途中でもカーソル位置で補完
setopt COMPLETE_IN_WORD
# バックグラウンドジョブが終了したらすぐに知らせる。
setopt NO_TIFY

# ライン操作はEmacsスタイルで行う
bindkey -e

# 補完候補のメニュー選択で、矢印キーの代わりにhjklで移動出来るようにする。
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

unsetopt AUTOREMOVESLASH

export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=100000

setopt hist_ignore_dups
setopt EXTENDED_HISTORY

function fzf-history-selection() {
    BUFFER=`history -n 1 | fzf`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N fzf-history-selection
bindkey '^R' fzf-history-selection
