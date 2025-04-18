{ config, pkgs, ... }:

{
  # OLLAMA & OPENWEBUI
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };

  services.open-webui.enable = true;
}