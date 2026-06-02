{
  flake.nixosModules.hermes =
    { pkgs, config, inputs, ... }:
    {
      imports = [
        inputs.hermes-agent.nixosModules.default
      ];

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
    {
      # For macOS, hermes-agent doesn't provide a nix-darwin module out of the box.
      # It natively supports the standard CLI workflow via the package.
      environment.systemPackages = [
        inputs.hermes-agent.packages.${pkgs.system}.default
      ];

      # After adding this package, you will run:
      # hermes setup
      # hermes gateway install (sets up launchd user service)
    };
}
