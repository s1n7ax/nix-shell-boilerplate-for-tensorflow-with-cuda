# nix-shell-tensorflow-with-cuda

Nix shell created for using tensorflow with CUDA.

## How to setup

- Install Nvidia driver in NixOS

```nix
hardware.nvidia = {
  modesetting.enable = true;
  open = false;
  nvidiaSettings = true;
  package = config.boot.kernelPackages.nvidiaPackages.stable;
};
```

### Using direnv

- If you are using direnv and added the shell hook, the just `cd` to dir

### Manual

- `cd` into the directory and run `nix-shell`

## Known issues

GPU can be used but cuDNN fails due to ![tensorflow/#62075](https://github.com/tensorflow/tensorflow/issues/62075)

```text
[nix-shell:~/Workspace/tensorflow]$ python3 -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"
2024-01-16 07:43:43.560064: E external/local_xla/xla/stream_executor/cuda/cuda_dnn.cc:9261] Unable to register cuDNN factory: Attempting to register factory for plugin cuDNN when one has already been registered
2024-01-16 07:43:43.560107: E external/local_xla/xla/stream_executor/cuda/cuda_fft.cc:607] Unable to register cuFFT factory: Attempting to register factory for plugin cuFFT when one has already been registered
2024-01-16 07:43:43.560799: E external/local_xla/xla/stream_executor/cuda/cuda_blas.cc:1515] Unable to register cuBLAS factory: Attempting to register factory for plugin cuBLAS when one has already been registered
2024-01-16 07:43:43.564357: I tensorflow/core/platform/cpu_feature_guard.cc:182] This TensorFlow binary is optimized to use available CPU instructions in performance-critical operations.
To enable the following instructions: AVX2 FMA, in other operations, rebuild TensorFlow with the appropriate compiler flags.
2024-01-16 07:43:44.097919: W tensorflow/compiler/tf2tensorrt/utils/py_utils.cc:38] TF-TRT Warning: Could not find TensorRT
2024-01-16 07:43:44.462809: I external/local_xla/xla/stream_executor/cuda/cuda_executor.cc:901] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero. See more at https://github.com/torvalds/linux/blob/v6.0/Documentation/ABI/testing/sysfs-bus-pci#L344-L355
2024-01-16 07:43:44.495784: I external/local_xla/xla/stream_executor/cuda/cuda_executor.cc:901] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero. See more at https://github.com/torvalds/linux/blob/v6.0/Documentation/ABI/testing/sysfs-bus-pci#L344-L355
2024-01-16 07:43:44.495952: I external/local_xla/xla/stream_executor/cuda/cuda_executor.cc:901] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero. See more at https://github.com/torvalds/linux/blob/v6.0/Documentation/ABI/testing/sysfs-bus-pci#L344-L355
[PhysicalDevice(name='/physical_device:GPU:0', device_type='GPU')]
(venv)
```
