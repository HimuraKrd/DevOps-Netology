
// this file has the param overrides for the default environment
local base = import './base.libsonnet';

base {
  components +: {
        netologyQbec +: {
          replicasFront: 3,
          replicasBack: 3,
          replicasDb: 3,
          imageFront: "mbagirov/netology-13-front",
          imageBack: "mbagirov/netology-13-backend",
          imageDb: "postgres:13-alpine",
          pvName: "pv-prod",
          pvcName: "pvc-prod",
    },
  },
}
