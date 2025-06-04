{ pkgs, lib, stdenvNoCC, themeConfig ? null }:

stdenvNoCC.mkDerivation rec {
  pname = "sddm-steavenlinux";
  version = "1.0";

  src = pkgs.fetchFromGitHub {
    owner = "SteavenLinux";
    repo = "SteavenSddm";
    rev = "main";
    hash = "sha256-ZSfe4cjaG5i9bGyXiPtYCSLer8iNVVFrR9BqOvZ8dzQ="; # Replace with actual hash
  };

  dontWrapQtApps = true;


  installPhase =
    let
      iniFormat = pkgs.formats.ini { };
      configFile = iniFormat.generate "" { General = themeConfig; };

      basePath = "$out/share/sddm/themes/SteavenLinux";
    in
    ''
      mkdir -p ${basePath}
      cp -r $src/usr/share/sddm/themes/SteavenLinux/* ${basePath}
    ''
    + lib.optionalString (themeConfig != null) ''
      ln -sf ${configFile} ${basePath}/theme.conf.user
    '';

  meta = {
    description = "Custom SDDM theme by SteavenLinux";
    homepage = "https://github.com/SteavenLinux/SteavenSddm";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ]; # Add yourself here if desired
  };
}
