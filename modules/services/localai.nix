{ ... }:

{
  # OLLAMA & OPENWEBUI
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    loadModels = [ "llama3.2:3b" "deepseek-r1:1.5b"];
  };

  services.open-webui={
    enable = true;
    port = 11111;
    };
}