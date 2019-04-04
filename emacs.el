(show-paren-mode 1) ; Show matching parens
(put 'upcase-region 'disabled nil)

(add-to-list 'load-path "~/elisp/")
(setq path-to-ctags "/usr/local/bin/ctags")

(server-start)

;; Settings only applicable under X
(cond (window-system
       (global-font-lock-mode t) ; Turn on font lock.
       (set-cursor-color "red") ; Make the cursor red (easier to see).
       ; Set title for frame and icon (%f == file name, %b == buffer name)
       (setq frame-title-format "Emacs - %f") 
       (setq icon-title-format "Emacs - %f")
       (setq default-frame-alist '((width . 140) (height . 90) (menu-bar-lines . 1)))
       ))

(defun create-tags (dir-name)
    "Create tags file."
    (interactive "DDirectory: ")
    (shell-command
     (format "%s -f TAGS -e -R %s" path-to-ctags (directory-file-name dir-name)))
  )

; Function to go to beginning of line or first non-space character.
; From http://www.emacswiki.org/cgi-bin/wiki/BackToIndentationOrBeginning
(defun programming-home ()
  (interactive)
  (if (= (point) (save-excursion (back-to-indentation) (point)))
      (beginning-of-line)
    (back-to-indentation)))

; Bind control up and down to scroll without moving the point.
(defun gcm-scroll-down ()
  (interactive)
  (scroll-up 1))

(defun gcm-scroll-up ()
  (interactive)
  (scroll-down 1))

; Scroll by 1 line at a time.
(setq scroll-step 1)

; Several key bindings.
;; Make ctrl-x h call help since Ctrl-h may be brain dead.
(global-set-key [?\C-x ?h] 'help-command)  ;; overrides mark-whole-buffer
;; Bind home to go to beginning of line or first non-space character.
(global-set-key [home] 'programming-home)
(global-set-key [end] 'end-of-line)
;; Bind control up and down to scroll without moving the point.
(global-set-key [(control down)] 'gcm-scroll-down)
(global-set-key [(control up)]   'gcm-scroll-up)
(global-set-key [C-tab] 'bury-buffer)   ; Enable C-tab (Windows style).
(global-set-key [?\C-x ?t] 'insert-date-time) ; Insert date-time.
(global-set-key "\M-g" 'goto-line)
(global-set-key "\C-l" 'goto-line)
;(global-set-ket "\C-c \C-c" 'comment-region)

;; May need these for xterm, putty/telnet/ssh.
;(global-set-key "\e[1~" 'back-to-indentation-or-beginning)   ;not screen
;(global-set-key "\eOH" 'back-to-indentation-or-beginning)    ;Needed on remote xterm?
;(global-set-key [end] 'end-of-line)           ;inactive by default?
;(global-set-key "\e[4~" 'end-of-line)
;(global-set-key "\eOF" 'end-of-line)          ;Needed on remote xterm?

; Change "yes or no" questions to use "y or n".
(fset 'yes-or-no-p 'y-or-n-p)

; Insert ISO 8601 Format Date/Time string at the point.
(defun insert-date-time(prefix)
  "Insert ISO 8601 format date-time, date or time string at the point (with no, one or two prefixes, repsectively."
  (interactive "P")
  (insert (format-time-string (cond ((not prefix) "%Y-%m-%dT%T%z")
                                    ((equal prefix '(4)) "%Y-%m-%d")
                                    ((equal prefix '(16)) "%T")
                                    (current-time)))))


;; Package Stuff. Don't modify anything below this line by hand.
(package-initialize)

;; load emacs 24's package system. Add MELPA repository.
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   ;; '("melpa" . "http://stable.melpa.org/packages/") ; many packages won't show if using stable
   '("melpa" . "http://melpa.milkbox.net/packages/")
   t))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (wheatgrass)))
 '(package-selected-packages (quote (color-theme-modern go-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

