{ pkgs ? import <nixpkgs> { } }:
let
  cclib = "${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH";
  cudalib = "${pkgs.cudaPackages.cuda_cudart.lib}/lib";
  nvidialib = "${pkgs.linuxPackages.nvidiaPackages.stable}/lib";
in pkgs.mkShell {
  name = "cuda-env-shell";
  buildInputs = with pkgs; [
    cudaPackages.cuda_nvcc
    cudaPackages.cuda_cudart
    wget
    (python3.withPackages (py-packages: with py-packages; [ pip setuptools ]))
  ];
  shellHook = ''
    export LD_LIBRARY_PATH=${cclib}:${nvidialib}:${cudalib}:$LD_LIBRARY_PATH
  '';
}
