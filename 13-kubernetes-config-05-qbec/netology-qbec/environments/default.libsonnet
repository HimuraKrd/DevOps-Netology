
// this file has the param overrides for the default environment
local base = import './base.libsonnet';

base {
  components +: {
        netologyQbec +: {
          replicasFront: 1,
          replicasBack: 1,
          replicasDb: 1,
          imageFront: "mbagirov/netology-13-front",
          imageBack: "mbagirov/netology-13-backend",
          imageDb: "postgres:13-alpine",
    },
  },
}
