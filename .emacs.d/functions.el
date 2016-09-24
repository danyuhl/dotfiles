;; From http://www.emacswiki.org/emacs/UnfillRegion
(defun unfill-region (beg end)
      "Unfill the region, joining text paragraphs into a single
    logical line.  This is useful, e.g., for use with
    `visual-line-mode'."
      (interactive "*r")
      (let ((fill-column (point-max)))
        (fill-region beg end)))

;; Handy key definition
(define-key global-map "\C-\M-Q" 'unfill-region)

(defun my-set-frame-width ()
  (interactive)
  (set-frame-width (selected-frame) (cdr (assoc 'width default-frame-alist))))

(define-key global-map "\C-z" 'my-set-frame-width)

(defun lecture-mode-toggle ()
  (interactive)
  (if (not (boundp 'lecture-mode))
      (progn
        (setq-default my-default-text-height
                      (face-attribute 'default :height))
        (setq-default lecture-mode nil)))
  (setq-default lecture-mode (not lecture-mode))
  (if lecture-mode
      (set-face-attribute 'default (selected-frame) :height 130)
    (set-face-attribute 'default (selected-frame) :height
                        my-default-text-height)))

(defun reset-frame-width ()
  (interactive)
  (when (and (string= system-type "gnu/linux") window-system)
    (let* ((dconf-entry
            (shell-command-to-string
             "dconf read /com/ubuntu/user-interface/scale-factor"))
           (scale-factor (progn (string-match "'eDP1': \\([0-9]+\\)[,\}]"
                                              dconf-entry)
                                (string-to-int (match-string 1 dconf-entry))))
           ;; text-width of 88 to make room for gutter and fringes
           (text-width (truncate (/ desired-width (/ scale-factor 8.0))))
           (text-height (truncate (/ desired-height (/ scale-factor 8.0)))))
      (message "set-frame-size is %dx%d, scale-factor is %s"
               text-width text-height scale-factor)
      (set-frame-size (selected-frame) text-width text-height))))

(defun hacking-mode ()
  (interactive)
  (delete-other-windows)
  (set-frame-size (selected-frame) 200 (window-total-height))
  (split-window-right)
  (other-window 1)
  (split-window-below)
  (other-window 1)
  (shell)
  (other-window 1))
