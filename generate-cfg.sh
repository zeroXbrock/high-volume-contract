#!/bin/bash

forge build
bytecode=$(cat out/SpamMe.sol/SpamMe.json | jq -r '.bytecode.object')

cat >spamConfig.toml <<EOF
[[create]]
name = "spamMe"
from = "3c44cdddb6a900fa2b585dd299e03d12fa4293bc"
bytecode = "$bytecode"

[[spam]]
to = "{spamMe}"
from = "3c44cdddb6a900fa2b585dd299e03d12fa4293bc"
signature = "consumeGas(uint256 gas)"
args = ["50000"]

[[spam]]
to = "{spamMe}"
from = "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
signature = "consumeGas(uint256 gas)"
args = ["50000"]
EOF