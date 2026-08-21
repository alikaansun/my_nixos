{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  vimUtils,
}:
let
  version = "0.4.4-unstable-2026-08-09";
  src = fetchFromGitHub {
    owner = "alikaansun";
    repo = "jupynvim";
    rev = "6b76d320885605dc0ca13e4912a5888e714f9214";
    hash = "sha256-zM3tIsVfeqbr6K3/7ZmyEKvkgRqRCUK7AHSOtX9+yzM=";
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
