with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "notalone-1.2.2";
  builder = ./builder.sh;
  nativeBuildInputs = [ pkgs.makeWrapper pkgs.patchelf ];
  libPath = lib.makeLibraryPath [ pkgs.libGL
                                  pkgs.pulseaudio
                                  xorg.libXxf86vm
                                  xorg.libX11
                                  xorg.libxcb
                                  xorg.libXinerama
                                  xorg.libXcursor
                                  xorg.libXrandr ];
  src = fetchzip {
    url = "https://github.com/borodust/notalone/releases/download/v1.2.2/notalone-x86-64-linux-v1.2.2.zip";
    sha256 = "03lqzk3nrqs8d0sd2xj78z1jijvjxvfh8dycq9vsbq53s6932qh5";
  };
}
