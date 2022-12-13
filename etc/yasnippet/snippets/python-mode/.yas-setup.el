;; from Xaldev
;; https://emacs.stackexchange.com/questions/19422/library-for-automatically-inserting-python-docstring-in-google-style

(defun python-args-to-google-docstring (text &optional make-fields)
  "Return a reST docstring format for the python arguments in yas-text."
  (let* ((indent (concat "\n" (make-string (current-column) 32)))
         (args (python-split-args text))
         (nr 0)
         (formatted-args
          (mapconcat
           (lambda (x)
             (concat "    "
                     (nth 0 x)
                     " \("
                     (if make-fields (format "${%d:type arg%d}" (cl-incf nr) (/ (+ nr 1) 2)))
                     (if (nth 1 x) (concat ", default: " (nth 1 x)))
                     "\): "
                     (if make-fields (format "${%d:descr arg%d}" (cl-incf nr) (/ nr 2)))
                     ))
           args
           indent)))
    (unless (string= formatted-args "")
      (concat
       (mapconcat 'identity
                  (list "" "Args:" formatted-args)
                  indent)
       "\n"))))
