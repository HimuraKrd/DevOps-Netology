
// this file has the baseline default parameters
{
  components: {
    netologyQbec: {
      replicasFront: 1,
      replicasBack: 1,
      replicasDb: 1,
      imageFront: "mbagirov/netology-13-front",
      imageBack: "mbagirov/netology-13-backend",
      imageDb: "postgres:13-alpine",
      pvName: "pv-prod",
      pvcName: "pvc-prod",
    },
  },
}
