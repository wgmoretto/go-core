ifeq ($(OS),Windows_NT)
setup:
	powershell -Command "New-Item -Path cmd/api, cmd/migrate -ItemType Directory -Force"
	powershell -Command "New-Item -Path internal/domain/entities, internal/domain/repositories, internal/domain/services -ItemType Directory -Force"
	powershell -Command "New-Item -Path internal/adapters/database, internal/adapters/cache, internal/adapters/external -ItemType Directory -Force"
	powershell -Command "New-Item -Path internal/handlers/http -ItemType Directory -Force"
	powershell -Command "New-Item -Path internal/config -ItemType Directory -Force"
	powershell -Command "New-Item -Path pkg/logger -ItemType Directory -Force"
	powershell -Command "New-Item -Path api, configs -ItemType Directory -Force"
	powershell -Command "New-Item -Path deployments/docker, deployments/kubernetes -ItemType Directory -Force"
	powershell -Command "New-Item -Path scripts -ItemType Directory -Force"
	powershell -Command "New-Item -Path tests/unit, tests/integration -ItemType Directory -Force"
	powershell -Command "New-Item cmd/api/main.go, cmd/migrate/main.go -Force"
	powershell -Command "New-Item internal/domain/entities/user.go -Force"
	powershell -Command "New-Item internal/domain/repositories/user_repository.go -Force"
	powershell -Command "New-Item internal/domain/services/user_service.go -Force"
	powershell -Command "New-Item internal/adapters/database/postgres.go, internal/adapters/cache/redis.go, internal/adapters/external/payment_gateway.go -Force"
	powershell -Command "New-Item internal/handlers/http/user_handler.go, internal/handlers/http/routes.go, internal/handlers/http/middleware.go -Force"
	powershell -Command "New-Item internal/config/config.go -Force"
	powershell -Command "New-Item pkg/logger/logger.go -Force"
	powershell -Command "New-Item api/openapi.yaml -Force"
	powershell -Command "New-Item configs/local.yaml, configs/production.yaml -Force"
	powershell -Command "New-Item deployments/docker/Dockerfile, deployments/kubernetes/deployment.yaml -Force"
	powershell -Command "New-Item scripts/build.sh, scripts/migrate.sh -Force"
	powershell -Command "New-Item tests/unit/.gitkeep, tests/integration/.gitkeep -Force"
	powershell -Command "New-Item go.mod, go.sum, README.md -Force"
	echo "Structure successfully created on Windows!"
else
setup:
	mkdir -p cmd/api cmd/migrate
	mkdir -p internal/{domain/{entities,repositories,services},adapters/{database,cache,external},handlers/http,config}
	mkdir -p pkg/logger api configs deployments/{docker,kubernetes} scripts tests/{unit,integration}
	touch cmd/api/main.go cmd/migrate/main.go
	touch internal/domain/entities/user.go internal/domain/repositories/user_repository.go internal/domain/services/user_service.go
	touch internal/adapters/database/postgres.go internal/adapters/cache/redis.go internal/adapters/external/payment_gateway.go
	touch internal/handlers/http/{user_handler.go,routes.go,middleware.go}
	touch internal/config/config.go pkg/logger/logger.go api/openapi.yaml
	touch configs/local.yaml configs/production.yaml
	touch deployments/docker/Dockerfile deployments/kubernetes/deployment.yaml
	touch scripts/build.sh scripts/migrate.sh
	touch tests/unit/.gitkeep tests/integration/.gitkeep go.mod go.sum README.md
	chmod +x scripts/*.sh
	echo "Structure successfully created on Unix/Linux!"
endif

build:
	go build -o bin/app ./cmd/api

dev:
	go run ./cmd/api

test:
	go test ./...
