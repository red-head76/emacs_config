;;; Compiled snippets and support files for `latex-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'latex-mode
		     '(("v" "\\vec{$1}$0" "vector" nil nil nil "/home/luis/.emacs.d/etc/yasnippet/snippets/latex-mode/vector" nil nil)
		       ("tikzlib" "\\usetikzlibrary{$1}\n$0" "tikzlib" nil nil nil "/home/luis/.emacs.d/etc/yasnippet/snippets/latex-mode/tikzlib" nil nil)
		       ("tikzimg" "\\documentclass{article}\n\\usepackage{tikz}\n\\begin{document}\n$0\n\\end{document}\n\n%%% Local Variables:\n%%% TeX-master: \"./`(current-buffer)`\"\n%%% End:\n" "tikzimg" nil nil nil "/home/luis/.emacs.d/etc/yasnippet/snippets/latex-mode/tikzimg" nil nil)
		       ("t" "\\text{$1}$0" "text" nil nil nil "/home/luis/.emacs.d/etc/yasnippet/snippets/latex-mode/text" nil nil)
		       ("subfile" "\\documentclass[../main.tex]{subfiles}\n\\begin{document}\n\n\\section{`(substring (prin1-to-string (current-buffer)) 9 -5)`}\n\\label{sec:`(substring (prin1-to-string (current-buffer)) 9 -5)`}\n\n\\end{document}\n%%% Local Variables:\n%%% TeX-master: \"./`(current-buffer)`\"\n%%% End:\n" "subfile" nil nil nil "/home/luis/.emacs.d/etc/yasnippet/snippets/latex-mode/subfile" nil nil)
		       ("sq" "\\sqrt{$1}$0" "sqrt" nil nil nil "/home/luis/.emacs.d/etc/yasnippet/snippets/latex-mode/sqrt" nil nil)
		       ("orgtable" "\\begin{table}[htbp]\n  \\centering\n  \n  #+ORGTBL: SEND ${1:tablename} orgtbl-to-latex :splice nil :skip 0\n  ${4: $(org-table-create)}\n\n  $0\n  % BEGIN RECEIVE ORGTBL $1\n  % END RECEIVE ORGTBL $1\n  \\caption{${2:caption}}\n  \\label{${3:waiting for reftex-label call...$(unless yas/modified-p (reftex-label nil 'dont-insert))}}\n\\end{table}" "orgtable" nil nil nil "/home/luis/.emacs.d/etc/yasnippet/snippets/latex-mode/orgtable" nil nil)
		       ("myfig" "\\begin{figure}[ht]\n    \\centering\n    \\includegraphics[width=${1:0.8}\\textwidth]{${2:path.pdf}}\n    \\caption[${3:short caption}]{$3: ${4:}}\n    \\label{fig:${5:$3}}\n\\end{figure}\n$0" "myfig" nil nil nil "/home/luis/.emacs.d/etc/yasnippet/snippets/latex-mode/myfig" nil nil)
		       ("mysf" "\\begin{subfigure}[b]{${1:0.3}\\textwidth}\n  \\includegraphics[width=\\textwidth]{${2:path.pdf}}\n\\end{subfigure}\n$0" "my subfigure" nil nil nil "/home/luis/.emacs.d/etc/yasnippet/snippets/latex-mode/my_subfigure" nil nil)
		       ("LV" "%%% Local Variables:\n%%% mode: latex\n%%% mode: auto-fill\n%%% mode: flyspell\n%%% TeX-master: \"../main\"\n%%% eval: (ispell-change-dictionary \"german\")\n%%% eval: (flyspell-buffer)\n%%% End:\n$0" "Local Variables" nil nil nil "/home/luis/.emacs.d/etc/yasnippet/snippets/latex-mode/Local_Variables" nil nil)))


;;; Do not edit! File generated at Wed Nov 16 16:50:41 2022
