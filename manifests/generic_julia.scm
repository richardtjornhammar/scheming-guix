; guix environment --manifest=generic_julia.scm
( specifications->manifest
 '( "glibc"
    "curl"
    "openssl"
    "p7zip"
    "julia"
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
