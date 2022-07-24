#!/usr/bin/env bash

set -euo pipefail

nix run .#node2nix -- -i node-packages.json -18
