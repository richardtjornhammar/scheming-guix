; guix environment --manifest=generic_julia.scm
( specifications->manifest
 '( "julia"
    "julia-parsers"
    "julia-fixedpointnumbers"
    "julia-json"
    "julia-adapt"
    "julia-compat"
    "julia-datastructures"
    "julia-orderedcollections"
    "julia-offsetarrays"
    "emacs-julia-mode"
  )
)
