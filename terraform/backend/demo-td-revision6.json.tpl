[
    {
        "name": "final-test-api",
        "image": "901512289056.dkr.ecr.ap-northeast-2.amazonaws.com/terraform-test:latest",
        "cpu": 0,
        "portMappings": [
            {
                "name": "final-test-api-3000-tcp",
                "containerPort": 3000,
                "hostPort": 3000,
                "protocol": "tcp",
                "appProtocol": "http"
            }
        ],
        "essential": true,
        "environment": [],
        "environmentFiles": [],
        "mountPoints": [],
        "volumesFrom": [],
        "secrets": [
            {
                "name": "WRITE_HOSTNAME",
                "valueFrom": "${db_write_hostname}"
            },
            {
                "name": "PASSWORD",
                "valueFrom": "${db_password}"
            },
            {
                "name": "DATABASE",
                "valueFrom": "${database}"
            },
            {
                "name": "READ_HOSTNAME",
                "valueFrom": "${db_reader_hostname}"
            },
            {
                "name": "USERNAME",
                "valueFrom": "${db_name}"
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-create-group": "true",
                "awslogs-group": "/ecs/test/example",
                "awslogs-region": "ap-northeast-2",
                "awslogs-stream-prefix": "ecs"
            }
        }
    }
]