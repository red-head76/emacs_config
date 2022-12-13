;;; Compiled snippets and support files for `python-mode'
;;; contents of the .yas-setup.el support file:
;;;
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
;;; Snippet definitions:
;;;
(yas-define-snippets 'python-mode
		     '(("fig" "fig, ax = plt.subplots(figsize=(4.5, 3.2), tight_layout=True)\n$0" "subplots" nil nil nil "/home/luis/.emacs.d/etc/yasnippet/snippets/python-mode/subplots" nil nil)
		       ("sns" "import seaborn as sns\n\nsns.set_theme(\"paper\")\n$0\n" "Import seaborn" nil
			("general")
			nil "/home/luis/.emacs.d/etc/yasnippet/snippets/python-mode/seaborn" nil nil)
		       ("rcf" "plt.rcParams.update({\"font.size\":${1:14}})\n$0" "rcFontsize" nil nil nil "/home/luis/.emacs.d/etc/yasnippet/snippets/python-mode/rcFontsize" nil nil)
		       ("defg" "def ${1:name}($2):\n    \\\"\\\"\\\"\n    $3\n    ${2:$(python-args-to-google-docstring yas-text t)}\n    ${5:Returns:\n        $6\n    }\n    \\\"\\\"\\\"\n    ${0:$$(let ((beg yas-snippet-beg)\n(end yas-snippet-end))\n(yas-expand-snippet\n(buffer-substring-no-properties beg end) beg end\n(quote ((yas-indent-line nil) (yas-wrap-around-region nil))))\n(delete-trailing-whitespace beg (- end 1)))}" "Python Google style Docstring" nil nil nil "/home/luis/.emacs.d/etc/yasnippet/snippets/python-mode/defgoogle" nil nil)))


;;; Do not edit! File generated at Wed Nov 16 16:50:41 2022
