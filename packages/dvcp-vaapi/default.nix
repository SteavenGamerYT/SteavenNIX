{ stdenv, lib, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "dvcp-vaapi";
  version = "0.2";

  src = fetchurl {
    url = "https://github.com/nowrep/dvcp-vaapi/releases/download/v${version}/vaapi_encoder.dvcp.bundle.zip";
    sha256 = "affcc0f4986e8e0b7d911ccfa4f8b8c5fff463d23a913987ee26e05208a1d30c";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/opt/resolve/IOPlugins
    unzip $src

    cp -r vaapi_encoder.dvcp.bundle $out/opt/resolve/IOPlugins/
  '';

  meta = {
    description = "VAAPI encoder plugin for Blackmagic DaVinci Resolve Studio";
    homepage = "https://github.com/nowrep/dvcp-vaapi";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
