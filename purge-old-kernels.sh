#!/bin/bash

## Script to remove all old kernels except that's in use

for kernel in $(dpkg --get-selections | grep -e linux-image-3-* | cut -f1); do
  if [ "linux-image-$(uname -r)" == "$kernel" ]; then
    echo "$kernel : IN USE!!!"
  else
    kernels_to_remove="$kernels_to_remove $kernel"
  fi

done

sudo apt-get purge $kernels_to_remove
