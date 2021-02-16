; guix environment --manifest=manifest.scm
( specifications->manifest
 '( "python"
    "python-numpy"
    "python-pandas"
    "python-matplotlib"
    "python-seaborn"
    "python-networkx"
    "python-scipy"
    "python-statsmodels"
    "python-pip"
  )
)
