{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  vimUtils,
}:
let
  version = "0.4.4-unstable-2026-08-24";
  src = fetchFromGitHub {
    owner = "alikaansun";
    repo = "jupynvim";
    rev = "9a20cb6f9c4ff6027e8e61e32e0da788df37a266";
    hash = "sha256-OahjUv5NYK2J80ks1kAvC4N2f0L0U/xNP8vvGGrVXec=";
  };
  jupynvim-core = rustPlatform.buildRustPackage {
    pname = "jupynvim-core";
    inherit version src;

    sourceRoot = "${src.name}/core";

    cargoHash = "sha256-cZKHYCFtzU1ULNp7TY/4/l6SrzGF3ghnBF5y5nvxuWw=";

    meta.mainProgram = "jupynvim-core";
  };
in
vimUtils.buildVimPlugin {
  pname = "jupynvim";
  inherit version src;

  postInstall = ''
    rm -rf $out/core
    substituteInPlace $out/lua/jupynvim/backend/connect.lua \
      --replace-fail 'M._plugin_root() .. "/core/target/release/jupynvim-core"' \
                     '"${lib.getExe jupynvim-core}"'
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "vimPlugins.jupynvim.jupynvim-core";
    };

    # needed for the update script
    inherit jupynvim-core;
  };

  meta = {
    description = "Jupyter notebooks in Neovim with native cell rendering and kernel execution";
    homepage = "https://github.com/sheng-tse/jupynvim";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alikaansun ];
  };
}
