(defvar pt-file "~/.emacs-practice-log.txt")
(defvar pt-exercises-file "~/.emacs-practice-exercises.txt")

(defun pt-log-session (minutes note bpm)
  (interactive "nDuration (Minutes): \nnBPM: \nsNotes: ")
  (let* ((exercise (pt-select-exercise))
	(entry (format "%s | %s | %smin | %d | %s\n"
		       (format-time-string "%Y-%m-%d %H:%M")
		       exercise
		       minutes
		       bpm
		       note)))
    (append-to-file entry nil pt-file)
    (message "Saved: %s" exercise)))

(defun pt-log-view ()
  (interactive)
  (find-file pt-file)
  (goto-char (point-max)))

(defun pt-log-summary ()
  (interactive)
  (with-temp-buffer
    (insert-file-contents pt-file)
    (let ((sessions 0) (total 0))
      (while (re-search-forward "|\\s-*\\([0-9]+\\)min" nil t)
	(cl-incf sessions)
	(cl-incf total (string-to-number (match-string 1))))
      (message "%d sessions, %d minutes total (%.1f hours)"
	       sessions total (/ total 60.0)))))

(defun pt-load-exercises ()
  (if (file-exists-p pt-exercises-file)
	(with-temp-buffer
	  (insert-file-contents pt-exercises-file)
	  (split-string (buffer-string) "\n" t))
    '()))

(defun pt-add-exercise (name)
  (interactive "sExercise Name: ")
  (let ((entry (format "%s\n" name)))
    (append-to-file entry nil pt-exercises-file)
    (message "Saved Exercise: %s" name)))

(defun pt-select-exercise ()
  (completing-read "Exercise: " (pt-load-exercises)))
