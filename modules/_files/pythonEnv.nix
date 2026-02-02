{ pkgs }:
pkgs.python313.withPackages (
  ps: with ps; [
    decorator
    ipython
    ipympl
    ipykernel
    jupyter
    jupyterlab
    notebook
    kiwisolver
    matplotlib
    matplotlib-inline
    numpy
    numpy-stl
    pandas
    pip
    scipy
    setuptools
    setuptools-scm
    six
    svgwrite
    wheel
    pyclipper
    pyyaml
    openpyxl
  ] ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    pyautogui
  ]
)
