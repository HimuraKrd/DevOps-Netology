local p = import '../params.libsonnet';
local params = p.components.nginx;

[
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "name": "nginx-deployment"
    },
    "spec": {
      "selector": {
        "matchLabels": {
          "app": "nginx"
        }
      },
      "replicas": 2,
      "template": {
        "metadata": {
          "labels": {
            "app": "nginx"
          }
        },
        "spec": {
          "containers": [
            {
              "name": "nginx",
              "image": "nginx:latest",
              "ports": [
                {
                  "containerPort": 80
                }
              ]
            }
          ]
        }
      }
    }
  }
]
