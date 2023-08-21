#!/usr/bin/env bash
# Copyright (c) 2023 b-data GmbH.
# Distributed under the terms of the MIT License.

set -e

mkdir -p "$HOME/.julia/config"

# Copy user-specific startup files if home directory is bind mounted
if [ ! -f "$HOME/.julia/config/startup_ijulia.jl" ]; then
  cp -a /etc/skel/.julia/config/startup_ijulia.jl \
    "$HOME/.julia/config"
fi
if [ ! -f "$HOME/.julia/config/startup.jl" ]; then
  cp -a /etc/skel/.julia/config/startup.jl \
    "$HOME/.julia/config"
fi
