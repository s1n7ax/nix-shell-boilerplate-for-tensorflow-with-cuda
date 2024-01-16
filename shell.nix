{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  name = "cuda-env-shell";
  buildInputs = with pkgs; [
    cudaPackages.cuda_nvcc
    cudaPackages.cuda_cudart
    (python3.withPackages (py-packages: with py-packages; [ pip setuptools ]))
  ];
  shellHook = ''
    LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH
    LD_LIBRARY_PATH=${pkgs.cudaPackages.cuda_cudart.lib}/lib:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH=${pkgs.linuxPackages.nvidiaPackages.stable}/lib:$LD_LIBRARY_PATH
  '';
}
