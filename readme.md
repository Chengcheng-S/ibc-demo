# plante
**plante** is a blockchain(use cosmos ibc-go) built using Cosmos SDK and Tendermint and created with [Ignite CLI](https://ignite.com/cli).

## Get started

```
ignite chain serve  -c earth.yml
```

another terminal
```
ignite chain serve  -c mars.yml
```

setup relayer
```
./setup.sh
```

relayer server
```
ignite relayer hermes start "earth" "mars"
```

## Tips
- If you keep getting errors when starting the relayer, you can try to modify the `max_gas` in the configuration file. I have checked many times and it is because of the gas setting problem.

- `http://localhost:26657/status`  `http://localhost:26659/status` We can observe the status of the chain through these two links. The port number depends on the rpc configuration in `setup.sh`.

