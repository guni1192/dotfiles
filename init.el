;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; el-get
(when load-file-name 
  (setq user-emacs-directory (file-name-directory load-file-name))) 
 
(add-to-list 'load-path (locate-user-emacs-file "el-get/el-get")) 
(unless (require 'el-get nil 'noerror) 
  (with-current-buffer 
      (url-retrieve-synchronously 
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el") 
    (goto-char (point-max)) 
    (eval-print-last-sexp)))
;;
;; パッケージリスト
;; {{{
;; General
(el-get-bundle auto-complete)
(el-get-bundle yasnippet)
(el-get-bundle multi-term)
(el-get-bundle powerline)
(el-get-bundle smart-compile)
(el-get-bundle smartparens)
(el-get-bundle ccann/badger-theme)
(el-get-bundle haskell-mode)
(el-get-bundle bliss-theme)
(el-get-bundle monokai-theme)

;;(el-get-bundle evil)
;; C/C++
(el-get-bundle auto-complete-c-headers)
(el-get-bundle google-c-style)
;; Ruby
;;(el-get-bundle ruby-block)
;;(el-get-bundle ruby-end)
;; Python
(el-get-bundle elpy)
(el-get-bundle py-autopep8)
(el-get-bundle ac-python)
(el-get-bundle epc)
(el-get-bundle deferred)
(el-get-bundle python-environment)
(el-get-bundle jedi)

;; web
(el-get-bundle web-mode)
;;; }}}


;; emacs theme
(load-theme 'monokai t)

(require 'powerline)
(powerline-center-theme)

;; 括弧補完
(require 'smartparens-config)
(smartparens-global-mode t)

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
(require 'epc)
(require 'ac-python)
(require 'python)
(setenv "PYTHONPATH" "/usr/lib/python3.5/site-packages")
(require 'jedi)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)                 ; optional
;; autopep8
;; $ pip install autopep8 pylint
(require 'py-autopep8)
(setq py-autopep8-options '("--max-line-length=200"))
(setq flycheck-flake8-maximum-line-length 200)
(py-autopep8-enable-on-save)
;; flycheck
(el-get 'sync 'flycheck)
(require 'python)

(defun tnoda/turn-on-flycheck-mode ()
  (flycheck-mode 1))
(add-hook 'python-mode-hook 'tnoda/turn-on-flycheck-mode)

;;; Ruby
;;(require 'ruby-block)
;;(setq ruby-block-highlight-toggle t)
;;(require 'ruby-end)


;; 環境を日本語、UTF-8にする
(set-locale-environment nil)
(set-language-environment "Japanese")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

;; mozc
;;(when (require 'mozc nil t) 
;;  (setq default-input-method "japanese-mozc")
  
;; スタートアップメッセージを表示させない
(setq inhibit-startup-message t)

;; バックアップファイルを作成させない
(setq make-backup-files nil)

;; 終了時にオートセーブファイルを削除する
(setq delete-auto-save-files t)

;; タブにスペースを使用する
(setq-default tab-width 4 indent-tabs-mode nil)

;; タブの可視化
(global-whitespace-mode 1)
(setq whitespace-space-regexp "\\(\u3000\\)")
(setq whitespace-style '(face tabs tab-mark spaces space-mark))
(setq whitespace-display-mappings ())
(set-face-foreground 'whitespace-tab "yellow")
(set-face-underline  'whitespace-tab t)
(set-face-foreground 'whitespace-space "yellow")
(set-face-background 'whitespace-space "red")
(set-face-underline  'whitespace-space t)

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

;; Color
(if window-system (progn
    (set-background-color "Black")
    (set-foreground-color "LightGray")
    (set-cursor-color "Gray")
    (set-frame-parameter nil 'alpha 70) ;透明度
    ))

;; 透明度を変更するコマンド M-x set-alpha
;; http://qiita.com/marcy@github/items/ba0d018a03381a964f24
(defun set-alpha (alpha-num)
  "set frame parameter 'alpha"
  (interactive "nAlpha: ")
  (set-frame-parameter nil 'alpha (cons alpha-num '(90))))
