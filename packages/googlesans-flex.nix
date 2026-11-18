{
  lib,
  stdenv,
  fetchFromGitHub,
  fontc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "googlesans-flex";
  version = "5.000";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "googlesans-flex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dF8uLSOwPODMAdEEUFtJT4wJAL+PHpUNtcZN8CPb3Sg=";
  };

  nativeBuildInputs = [
    fontc
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -p fonts/variable
    fontc sources/GoogleSansFlex.glyphspackage --flatten-components --decompose-transformed-components --output-file "fonts/variable/GoogleSansFlex[ROND,opsz,slnt,wdth,wght].ttf"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/googlesans-flex
    cp fonts/variable/* $out/share/fonts/googlesans-flex/

    runHook postInstall
  '';

  meta = {
    description = "Google Sans Flex font family";
    homepage = "https://github.com/googlefonts/googlesans-flex";
    changelog = "https://github.com/googlefonts/googlesans-flex/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
})
