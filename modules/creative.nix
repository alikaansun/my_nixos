{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Creative apps
    blender          # 3D modeling and animation
    gimp             # Image editing
    kicad            # Electronics design
    freecad          # Parametric 3D CAD modeler
    ergogen          # Keyboard PCB generator
    qmk
    ardour           # Audio recording and editing
    godot
    # davinci-resolve       # Video editor
    # musescore      # Music notation software
  ];

}