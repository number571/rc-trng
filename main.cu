// /opt/cuda/bin/nvcc main.cu -o main

#include <cstdint>
#include <stdint.h>
#include <stdio.h>

#define MODULE_N 256
#define CUDA_BLOCK_N 4096

__global__ void rand_uintN(uint8_t *r) { *r = blockIdx.x % MODULE_N; }

void rand_uintNs(uint8_t *gamma, int n);
void print_uintNs(uint8_t *gamma, int n);
void write_uintNs(uint8_t *gamma, int n);
void print_uintNs_count(uint8_t *gamma, int n);

int main(int argc, char *argv[]) {
  const int n = 4096;
  uint8_t gamma[n];
  
  rand_uintNs(gamma, n);
  write_uintNs(gamma, n);
  return 0;
}

void rand_uintNs(uint8_t *gamma, int n) {
  int num_count = n * MODULE_N;

  uint8_t raw_rand[num_count];
  uint8_t *dev_r;

  memset(raw_rand, 0, sizeof(raw_rand));
  cudaMalloc(&dev_r, sizeof(uint8_t));
  for (int i = 0; i < num_count; i++) {
    rand_uintN<<<CUDA_BLOCK_N, 1>>>(dev_r);
    cudaMemcpy(raw_rand + i, dev_r, sizeof(uint8_t), cudaMemcpyDeviceToHost);
  }
  cudaFree(dev_r);

  for (int i = 0; i < num_count; i += MODULE_N) {
    int sum = 0;
    for (int j = 0; j < MODULE_N; ++j) {
      sum += raw_rand[i + j];
    }
    gamma[i / MODULE_N] = sum % MODULE_N;
  }
}

void write_uintNs(uint8_t *gamma, int n) {
  fwrite(gamma, sizeof(uint8_t), n, stdout);
}
