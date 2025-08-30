{
  miniflux = {
    hostName = "miniflux.arondil.local";
    tailscaleHostName = "miniflux.taild325e4.ts.net";  # Add port
    IP="0.0.0.0";
    port = 8080;
  };

  openWebUI = {
    IP="0.0.0.0";
    hostName = "ai.arondil.local";
    port = 11111;
  };

  ollama = {
    IP="127.0.0.1";
    port = 11434;
  };
}