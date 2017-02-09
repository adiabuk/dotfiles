;vim:fdm=marker

; {{{ load stuff
(add-to-list 'load-path "~/.emacs.d/additional")
(load-library "termshell")

(set-terminal-coding-system 'utf-8)
(setq explicit-shell-file-name "/bin/bash")
(fset 'yes-or-no-p 'y-or-n-p)

(global-set-key (kbd "C-x t") 'term/shell)
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

(require 'powerline)
(require 'moe-theme)
(powerline-moe-theme)

(global-linum-mode 1)

; keystrokes
(setq echo-keystrokes 0.1
      use-dialog-box nil
      visible-bell t)
(show-paren-mode t)

; }}}

; {{{ Evil mode
;(add-to-list 'load-path "~/.emacs.d/evil") ;;no need with 24
;(require 'evil)
;(evil-mode 1)
;(global-evil-tabs-mode t)
; }}}

; {{{ package manager
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list 'package-archives
   '("melpa" . "http://melpa.org/packages/") t)
  (add-to-list 'package-archives
   '("marmalade" . "http://marmalade-repo.org/packages/"))
  (package-initialize))
; }}}

; {{{ variables
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(custom-enabled-themes (quote (wheatgrass)))
 '(global-hl-line-mode nil)
 '(ido-mode (quote both) nil (ido))
 ; }}}

; {{{ Git
 '(magit-git-executable "/usr/bin/git"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
; }}}

; {{{ color column
;(require 'column-marker)
;; (require 'fill-column-indicator)
(add-hook 'after-change-major-mode-hook 'fci-mode)
; }}}

; {{{ Custom splitting functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom splitting functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
(defun vsplit-last-buffer ()
  (interactive)
  (split-window-vertically)
  (other-window 1 nil)
  (switch-to-next-buffer)
  )
(defun hsplit-last-buffer ()
  (interactive)
  (split-window-horizontally)
  (other-window 1 nil)
  (switch-to-next-buffer)
  )
 
(global-set-key (kbd "C-x 2") 'vsplit-last-buffer)
(global-set-key (kbd "C-x 3") 'hsplit-last-buffer)
; }}}

; {{{ Hide welcome screen
(setq inhibit-splash-screen t
      initial-scratch-message nil
      initial-major-mode 'org-mode)
; }}}

; {{{ remove scroll/tool bar
(scroll-bar-mode -1)
(tool-bar-mode -1)
; }}}

; {{{ run current file
(global-set-key (kbd "C-x r") 'xah-run-current-file)
(defun xah-run-current-file ()
  "Execute the current file.
For example, if the current buffer is the file x.py, then it'll call 「python x.py」 in a shell.
The file can be Emacs Lisp, PHP, Perl, Python, Ruby, JavaScript, Bash, Ocaml, Visual Basic, TeX, Java, Clojure.
File suffix is used to determine what program to run.

If the file is modified, ask if you want to save first.

URL `http://ergoemacs.org/emacs/elisp_run_current_file.html'
version 2015-08-23"
  (interactive)
  (let* (
         (ξsuffix-map
          ;; (‹extension› . ‹shell program name›)
          `(
            ("php" . "php")
            ("pl" . "perl")
            ("py" . "python")
            ("py3" . ,(if (string-equal system-type "windows-nt") "c:/Python32/python.exe" "python3"))
            ("rb" . "ruby")
            ("js" . "node") ; node.js
            ("sh" . "bash")
            ("clj" . "java -cp /home/xah/apps/clojure-1.6.0/clojure-1.6.0.jar clojure.main")
            ("ml" . "ocaml")
            ("vbs" . "cscript")
            ("tex" . "pdflatex")
            ("latex" . "pdflatex")
            ("java" . "javac")
            ;; ("pov" . "/usr/local/bin/povray +R2 +A0.1 +J1.2 +Am2 +Q9 +H480 +W640")
            ))
         (ξfname (buffer-file-name))
         (ξfSuffix (file-name-extension ξfname))
         (ξprog-name (cdr (assoc ξfSuffix ξsuffix-map)))
         (ξcmd-str (concat ξprog-name " \""   ξfname "\"")))

    (when (buffer-modified-p)
      (when (y-or-n-p "Buffer modified. Do you want to save first?")
        (save-buffer)))

    (cond
     ((string-equal ξfSuffix "el") (load ξfname))
     ((string-equal ξfSuffix "java")
      (progn
        (shell-command ξcmd-str "*xah-run-current-file output*" )
        (shell-command
         (format "java %s" (file-name-sans-extension (file-name-nondirectory ξfname))))))
     (t (if ξprog-name
            (progn
              (message "Running…")
              (shell-command ξcmd-str "*xah-run-current-file output*" ))
          (message "No recognized program file suffix for this file."))))))
; }}}


