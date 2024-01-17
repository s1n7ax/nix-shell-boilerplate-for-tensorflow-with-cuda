{ pkgs ? import <nixpkgs> { } }:
with pkgs;
let
  cclib = "${stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH";
  nvidialib = "${linuxPackages.nvidiaPackages.stable}/lib";
in pkgs.mkShell {
  name = "cuda-env-shell";

  buildInputs = with pkgs; [
    virtualenv
    wget
    (python3.withPackages (py-packages: with py-packages; [ pip jupyterlab ]))
  ];

  shellHook = ''
    export LD_LIBRARY_PATH=${cclib}:${nvidialib}:$LD_LIBRARY_PATH

    VIRTUALENV="./venv"
    NEW_ENV=0

    if [ ! -d "$VIRTUALENV" ]; then
      virtualenv venv
      NEW_ENV=1
    fi

    source venv/bin/activate

    if [ $NEW_ENV -eq 1 ]; then
      pip install -I --require-virtualenv -r requirements.txt
    fi
  '';
}
