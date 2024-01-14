{ pkgs ? import <nixpkgs> {
  overlays = [
    (final: prev: {
      cudatoolkit = prev.cudatoolkit.overrideAttrs (finalAttrs: previousAttrs: {
        pname = previousAttrs.pname;
        src = pkgs.runCommand "${previousAttrs.pname}.run" {
          nativeBuildInputs = [ pkgs.axel ];
          outputHashMode = previousAttrs.src.outputHashMode;
          outputHashAlgo = previousAttrs.src.outputHashAlgo;
          outputHash = previousAttrs.src.outputHash;
        } ''
          axel \
            --num-connections=10 \
            --verbose \
            --insecure \
            --output "$out" \
            "${previousAttrs.src.url}"
        '';
      });
    })
  ];
} }:
pkgs.mkShell {
  name = "cuda-env-shell";
  buildInputs = with pkgs; [
    cudatoolkit
    cudaPackages.cudnn
    (python3.withPackages (py-packages: with py-packages; [ pip setuptools ]))
  ];
  shellHook = ''
    export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.cudatoolkit}/lib:${pkgs.cudaPackages.cudnn}/lib:${pkgs.cudatoolkit.lib}/lib:$LD_LIBRARY_PATH
    alias pip="PIP_PREFIX='$(pwd)/_build/pip_packages' TMPDIR='$HOME' \pip"
    export PYTHONPATH="$(pwd)/_build/pip_packages/lib/python3.7/site-packages:$PYTHONPATH"
    export PATH="$(pwd)/_build/pip_packages/bin:$PATH"
    unset SOURCE_DATE_EPOCH

    export CUDA_PATH=${pkgs.cudatoolkit}
    export LD_LIBRARY_PATH=${pkgs.linuxPackages.nvidiaPackages.stable}/lib:$LD_LIBRARY_PATH
    export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidiaPackages.stable}/lib"
    export EXTRA_CCFLAGS="-I/usr/include"
  '';
}
