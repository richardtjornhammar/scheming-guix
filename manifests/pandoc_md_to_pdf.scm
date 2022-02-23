; guix environment --manifest=generic_julia.scm
; pandoc -s README.md -o readme.pdf
( specifications->manifest
 '( "make"
    "texlive"
    "emacs-graphviz-dot-mode"
    "dot2tex"
    "texlive-pstool"
    "graphviz"
    "texlive-pdftex"
    "pandoc"
  )
)
