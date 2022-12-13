;;; Compiled snippets and support files for `emacs-lisp-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'emacs-lisp-mode
		     '(("pkg" ";; Package: ${1:Packagename}\n;; ________________________________________\n(require '$1)\n$0" "package" nil nil nil "/home/luis/.emacs.d/etc/yasnippet/snippets/emacs-lisp-mode/package" nil nil)
		       ("if" "(if (${1:condition})\n (${2:true_body})\n (${3:false_body})\n )\n$0" "if" nil nil nil "/home/luis/.emacs.d/etc/yasnippet/snippets/emacs-lisp-mode/if" nil nil)))


;;; Do not edit! File generated at Wed Nov 16 16:50:41 2022
