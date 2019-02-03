

(require 'package)

; find package information from following archives
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

(package-initialize)
(package-refresh-contents)

(mapcar (lambda (package)
          ; install package if not already installed
          (unless (package-installed-p package)
            (package-install package)))

        ; list of packages to be installed
        '(undo-tree
          ansi
          dash
          column-marker
          async
          elscreen
          goto-chg
          git-commit
          fill-column-indicator
          evil-tabs
          evil
          s
          pylint
          powerline
          multi-term
          moe-theme
          with-editor))

