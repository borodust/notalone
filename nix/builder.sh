source $stdenv/setup

TARGET_DIR="$out"
EXECUTABLE=$TARGET_DIR/notalone
LIB_PATH="$TARGET_DIR/lib:$libPath"

echo "LIB_PATH: $LIB_PATH"

mkdir -p $TARGET_DIR
cp -R $src/* $TARGET_DIR
chmod +w $EXECUTABLE
patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $EXECUTABLE
wrapProgram $TARGET_DIR/notalone --prefix LD_LIBRARY_PATH : "$LIB_PATH"
