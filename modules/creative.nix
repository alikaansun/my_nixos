{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Creative apps
    blender          # 3D modeling and animation
    gimp             # Image editing
    kicad            # Electronics design
    freecad          # Parametric 3D CAD modeler
    ergogen          # Keyboard PCB generator
    ardour           # Audio recording and editing
    # davinci-resolve       # Video editor
    # musescore      # Music notation software
  ];
}