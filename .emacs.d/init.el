(require 'package)

;; MELPAを追加
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
;; Marmaladeを追加
(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/") t)

;; 初期化
(package-initialize)

;; multi-term
;;(require 'multi-term)

;; color-theme
;;(when(require 'color-theme)
;;  (color-theme-initialize)
;;  (when(require 'color-theme-solarized)
;;    (color-theme-solarized-dark)))
(load-theme 'wombat)

(require 'powerline)
(powerline-default-theme)

(load-theme 'wombat t)
(enable-theme 'wombat)

;; 括弧補完
;;(require 'smartparens-config)
;;(smartparens-global-mode t)

;; auto-complete
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

;; yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;; auto-complete-c-headers
(defun my:ac-c-header-init()
  (require 'auto-complete-c-headers)
  ;; Macのインクルードパス
  (add-to-list 'ac-sources 'ac-source-c-headers)
  (add-to-list 'achead:include-directories
               '"/usr/local/Cellar/gcc6/6.2.0/include/c++/6.2.0")
  (add-to-list 'achead:include-directories
               '"/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk/usr/include")
  ;; Linuxのインクルードパス
  (add-to-list 'achead:include-directories '"/usr/local/include/boost/")
  (add-to-list 'achead:include-directories '"/usr/include")
  (add-to-list 'achead:include-directories '"/usr/include/c++/6.2.1"))

;; google-c-style.el
(defun my-c-c++-mode-init ()
  (require 'google-c-style)
  (google-set-c-style)
  ;; (google-make-newline-indent)
  )
(add-hook 'c-mode-hook 'my-c-c++-mode-init)
(add-hook 'c++-mode-hook 'my-c-c++-mode-init)

;; c/c++ hooks
(add-hook 'c++-mode-hook 'my:ac-c-header-init)
(add-hook 'c-mode-hook 'my:ac-c-header-init)

;; インデント設定
(defun my-c-c++-mode-init()
  (setq c-basic-offset 4)
  )
(add-hook 'c-mode-hook 'my-c-c++-mode-init)
(add-hook 'c++-mode-hook 'my-c-c++-mode-init)

;; C++ refactaring for mac
(define-key global-map (kbd "C-c ;") 'iedit-mode)


;; C/C++ tab key setting
(setq c-tab-always-indent nil)
;;; Python
;; elpy
(elpy-enable)

;; key-binding
(define-key yas-minor-mode-map (kbd "C-c k") 'yas-expand)
(define-key global-map (kbd "C-c o") 'iedit-mode)

;;; Ruby
;; (require 'rbenv)
;;(global-rbenv-mode)
;;(setq rbenv-installation-dir "/usr/local/var/rbenv")
;; ruby-block
(require 'ruby-block)
(setq ruby-block-highlight-toggle t)
(require 'ruby-end)

;; smart compile
(require 'smart-compile)
  (define-key ruby-mode-map (kbd "C-c c") 'smart-compile)
  (define-key ruby-mode-map (kbd "C-c C-c") (kbd "C-c c C-m"))


;; 環境を日本語、UTF-8にする
(set-locale-environment nil)
(set-language-environment "Japanese")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

;; スタートアップメッセージを表示させない
(setq inhibit-startup-message t)

;; バックアップファイルを作成させない
(setq make-backup-files nil)

;; 終了時にオートセーブファイルを削除する
(setq delete-auto-save-files t)

;; タブにスペースを使用する
(setq-default tab-width 4 indent-tabs-mode nil)

;; 改行コードを表示する
(setq eol-mnemonic-dos "(CRLF)")
(setq eol-mnemonic-mac "(CR)")
(setq eol-mnemonic-unix "(LF)")

;; 複数ウィンドウを禁止する
(setq ns-pop-up-frames nil)

;; メニューバーを消す
(menu-bar-mode -1)

;; ツールバーを消す
(tool-bar-mode -1)

;; 列数を表示する
(column-number-mode t)

;; 行数を表示する
(global-linum-mode t)

;; カーソルの点滅をやめる
(blink-cursor-mode 0)

;; カーソル行をハイライトする
(global-hl-line-mode t)

;; 対応する括弧を光らせる
(show-paren-mode 1)

;; スペース、タブなどを可視化する
;(global-whitespace-mode 1)

;; スクロールは１行ごとに
(setq scroll-conservatively 1)

;; C-kで行全体を削除する
(setq kill-whole-line t)

;; "yes or no" の選択を "y or n" にする
(fset 'yes-or-no-p 'y-or-n-p)

;; beep音を消す
(defun my-bell-function ()
  (unless (memq this-command
        '(isearch-abort abort-recursive-edit exit-minibuffer
              keyboard-quit mwheel-scroll down up next-line previous-line
              backward-char forward-char))
    (ding)))
(setq ring-bell-function 'my-bell-function)
