{
  flake.vars = {
    
    nextcloud = {
      hostName = "nextcloud.arondil.local";
      IP = "0.0.0.0";
      port = 10081;

    };

    miniflux = {
      hostName = "miniflux.arondil.local";
      IP = "0.0.0.0";
      port = 8080;
    };

    openWebUI = {
      hostName = "ai.arondil.local";
      IP = "0.0.0.0";
      port = 11111;
    };

    ollama = {
      IP = "127.0.0.1";
      port = 11434;
    };

    audiobookshelf = {
      hostName = "audiobookshelf.arondil.local";
      IP = "0.0.0.0";
      port = 13378;
    };
  };
}
