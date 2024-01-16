{ pkgs ? import <nixpkgs> { } }:
let
  cclib = "${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH";
  # cudalib = "${pkgs.cudaPackages.cuda_cudart.lib}/lib";
  nvidialib = "${pkgs.linuxPackages.nvidiaPackages.stable}/lib";
in pkgs.mkShell {
  name = "cuda-env-shell";
  buildInputs = with pkgs;
    [
      # linuxHeaders
      # cudaPackages.cuda_gdb
      # cudaPackages.cuda_nvvp
      # cudaPackages.cuda_nvtx
      # cudaPackages.cuda_nvcc
      # cudaPackages.cuda_cccl
      # cudaPackages.cuda_nvrtc
      # cudaPackages.cuda_cupti
      # cudaPackages.cuda_nvprof
      # cudaPackages.cuda_nsight
      # cudaPackages.cuda_cudart
      # cudaPackages.cuda_nvprune
      # cudaPackages.cuda_nvml_dev
      # cudaPackages.cuda_nvdisasm
      # cudaPackages.cuda_memcheck
      # cudaPackages.cuda_cuxxfilt
      # cudaPackages.cuda_cuobjdump
      # cudaPackages.cuda_demo_suite
      # cudaPackages.cuda_profiler_api
      # cudaPackages.cuda_sanitizer_api
      # cudaPackages.cuda_documentation
      # cudaPackages.cuda-samples
      # wget
      (python310.withPackages
        (py-packages: with py-packages; [ pip setuptools tensorflowWithCuda ]))
    ];
  shellHook = ''
    export LD_LIBRARY_PATH=${cclib}:${nvidialib}:$LD_LIBRARY_PATH
  '';
}
# export LD_LIBRARY_PATH=${cclib}:${nvidialib}:${cudalib}:$LD_LIBRARY_PATH
