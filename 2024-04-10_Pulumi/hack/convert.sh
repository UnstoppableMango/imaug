#!/bin/bash

root="$(git rev-parse --show-toplevel)/2024-04-10_Pulumi"

pulumi convert \
    --from bicep \
    --language typescript \
    --generate-only \
    --out "$root"
