{
  flake.nixosModules.hermes =
    {
      pkgs,
      config,
      inputs,
      ...
    }:
    {
      imports = [
        inputs.hermes-agent.nixosModules.default
      ];
      environment.systemPackages = [ pkgs.claude-code ];
      services.hermes-agent = {
        enable = true;
        settings.model.default = "anthropic/claude-sonnet-4.6";
        # Optional: enable container mode if needed
        # container.enable = true;
        addToSystemPackages = true;

        # To use secrets, you would uncomment out below and add the secrets file
        # environmentFiles = [ config.sops.secrets."hermes-env".path ];
      };
    };

  flake.darwinModules.hermes =
    { pkgs, inputs, ... }:
    let
      hermesAgentPkg = inputs.hermes-agent.packages.${pkgs.system}.default;
      # hermes-agent-env (Python 3.12) has all of anthropic's deps except
      # anthropic itself and docstring-parser. Inject them via PYTHONPATH.
      missingPythonPkgs = with pkgs.python312Packages; [
        anthropic
        docstring-parser
      ];
      extraPythonPath = pkgs.lib.makeSearchPath pkgs.python312.sitePackages missingPythonPkgs;
      hermesWrapped = pkgs.symlinkJoin {
        name = "hermes-agent-with-anthropic";
        paths = [ hermesAgentPkg ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/hermes \
            --prefix PYTHONPATH : "${extraPythonPath}"
        '';
      };
    in
    {
      environment.systemPackages = [
        hermesWrapped
        pkgs.claude-code
      ];
    };
}
