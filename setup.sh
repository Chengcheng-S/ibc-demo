#bin/bash
ignite relayer hermes configure "earth" "http://localhost:26657" "http://localhost:9090" "mars" "http://localhost:26659" "http://localhost:9092" --chain-a-faucet "http://0.0.0.0:4500" --chain-b-faucet "http://0.0.0.0:4501" --chain-a-port-id "blog" --chain-b-port-id "blog" --channel-version "blog-1"
