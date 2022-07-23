local p = import '../params.libsonnet';
local params = p.components.netologyQbec;

[
  {
    "apiVersion": "v1",
    "kind": "PersistentVolume",
    "metadata": {
      "name": "back-" + params.pvName
    },
    "spec": {
      "storageClassName": "nfs",
      "accessModes": [
        "ReadWriteMany"
      ],
      "capacity": {
        "storage": "1G"
      },
      "hostPath": {
        "path": "/data/backend/"
      }
    }
  },
  {
    "apiVersion": "v1",
    "kind": "PersistentVolume",
    "metadata": {
      "name": "front-" + params.pvName
    },
    "spec": {
      "storageClassName": "nfs",
      "accessModes": [
        "ReadWriteMany"
      ],
      "capacity": {
        "storage": "1G"
      },
      "hostPath": {
        "path": "/data/frontend/"
      }
    }
  },
{
    "apiVersion": "v1",
    "kind": "PersistentVolumeClaim",
    "metadata": {
      "name": "back-" + params.pvcName
    },
    "spec": {
      "resources": {
        "requests": {
          "storage": "1G"
        }
      },
      "volumeMode": "Filesystem",
      "accessModes": [
        "ReadWriteMany"
      ]
    }
  },
  {
    "apiVersion": "v1",
    "kind": "PersistentVolumeClaim",
    "metadata": {
      "name": "front-" + params.pvcName
    },
    "spec": {
      "resources": {
        "requests": {
          "storage": "1G"
        }
      },
      "volumeMode": "Filesystem",
      "accessModes": [
        "ReadWriteMany"
      ]
    }
  },
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "name": "frontend",
    },
    "spec": {
      "replicas" : params.replicasFront,
      "selector": {
        "matchLabels": {
          "app": "frontend"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "app": "frontend"
          }
        },
        "spec": {
          "containers": [
            {
              "name": "frontend",
              "image": params.imageFront,
              "resources": {
                "limits": {
                  "memory": "128Mi",
                  "cpu": "500m"
                }
              },
              "ports": [
                {
                  "containerPort": 80
                }
              ],
              "env": [
                {
                  "name": "BASE_URL",
                  "value": "http://localhost:9000"
                }
              ],
              "volumeMounts": [
                {
                  "mountPath": "/static/front",
                  "name": "front-" + params.pvName
                }
              ]
            }
          ],
          "volumes": [
            {
              "name": "front-" + params.pvName,
              "persistentVolumeClaim": {
                "claimName": "front-" + params.pvcName
              }
            }
          ]
        }
      }
    }
  },
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
      "name": "frontend",
    },
    "spec": {
      "selector": {
        "app": "frontend"
      },
      "ports": [
        {
          "name": "frontend",
          "protocol": "TCP",
          "port": 8080,
          "targetPort": 80
        }
      ]
    }
  },
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "name": "backend",
    },
    "spec": {
      "replicas": params.replicasBack,
      "selector": {
        "matchLabels": {
          "app": "backend"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "app": "backend"
          }
        },
        "spec": {
          "containers": [
            {
              "name": "backend",
              "image": params.imageBack,
              "resources": {
                "limits": {
                  "memory": "128Mi",
                  "cpu": "500m"
                }
              },
              "ports": [
                {
                  "containerPort": 9000
                }
              ],
              "env": [
                {
                  "name": "DATABASE_URL",
                  "value": "postgres://postgres:postgres@postgres:5432/news"
                }
              ],
              "volumeMounts": [
                {
                  "name": "back-" + params.pvName,
                  "mountPath": "/static/backend"
                }
              ]
            }
          ],
          "volumes": [
            {
              "name": "back-" + params.pvName,
              "persistentVolumeClaim": {
                "claimName": "back-" + params.pvcName
              }
            }
          ]
        }
      }
    }
  },
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
      "name": "backend"
    },
    "spec": {
      "selector": {
        "app": "backend"
      },
      "ports": [
        {
          "name": "backend",
          "protocol": "TCP",
          "port": 9000,
          "targetPort": 9000
        }
      ]
    }
  },
  {
    "apiVersion": "apps/v1",
    "kind": "StatefulSet",
    "metadata": {
      "name": "db",
    },
    "spec": {
      "selector": {
        "matchLabels": {
          "app": "db"
        }
      },
      "serviceName": "db",
      "replicas": params.replicasDb,
      "template": {
        "metadata": {
          "labels": {
            "app": "db"
          }
        },
        "spec": {
          "containers": [
            {
              "name": "db",
              "image": "postgres:13-alpine",
              "ports": [
                {
                  "containerPort": 5432
                }
              ],
              "volumeMounts": [
                {
                  "name": "db-data",
                  "mountPath": "/var/lib/postgresql/data"
                }
              ],
              "env": [
                {
                  "name": "POSTGRES_PASSWORD",
                  "value": "postgres"
                },
                {
                  "name": "POSTGRES_USER",
                  "value": "postgres"
                },
                {
                  "name": "POSTGRES_DB",
                  "value": "news"
                }
              ],
            }
          ],
          "volumes": [
            {
              "name": "db-data",
              "persistentVolumeClaim": {
                "claimName": "front-" + params.pvcName
              }
            }
          ]
        }
      }
    }
  },
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
      "name": "db",
      "namespace": "prod"
    },
    "spec": {
      "selector": {
        "app": "db"
      },
      "ports": [
        {
          "name": "db",
          "protocol": "TCP",
          "port": 5432,
          "targetPort": 5432
        }
      ],
      "type": "ClusterIP"
    }
  }
]