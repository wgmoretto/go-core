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
	powershell -Command "Set-Content -Path cmd/api/main.go -Value 'package main'"
	powershell -Command "Set-Content -Path cmd/migrate/main.go -Value 'package main'"
	powershell -Command "Set-Content -Path internal/domain/entities/user.go -Value 'package entities'"
	powershell -Command "Set-Content -Path internal/domain/repositories/user_repository.go -Value 'package repositories'"
	powershell -Command "Set-Content -Path internal/domain/services/user_service.go -Value 'package services'"
	powershell -Command "Set-Content -Path internal/adapters/database/postgres.go -Value 'package database'"
	powershell -Command "Set-Content -Path internal/adapters/cache/redis.go -Value 'package cache'"
	powershell -Command "Set-Content -Path internal/adapters/external/payment_gateway.go -Value 'package external'"
	powershell -Command "Set-Content -Path internal/handlers/http/user_handler.go -Value 'package http'"
	powershell -Command "Set-Content -Path internal/handlers/http/routes.go -Value 'package http'"
	powershell -Command "Set-Content -Path internal/handlers/http/middleware.go -Value 'package http'"
	powershell -Command "Set-Content -Path internal/config/config.go -Value 'package config'"
	powershell -Command "Set-Content -Path pkg/logger/logger.go -Value 'package logger'"
	powershell -Command "New-Item -Path api/openapi.yaml -Force"
	powershell -Command "New-Item -Path configs/local.yaml, configs/production.yaml -Force"
	powershell -Command "New-Item -Path deployments/docker/Dockerfile, deployments/kubernetes/deployment.yaml -Force"
	powershell -Command "New-Item -Path scripts/build.sh, scripts/migrate.sh -Force"
	powershell -Command "New-Item -Path tests/unit/.gitkeep, tests/integration/.gitkeep -Force"
	powershell -Command "New-Item -Path go.mod, go.sum, README.md -Force"
	echo "Structure successfully created on Windows!"
else
setup:
	mkdir -p cmd/api cmd/migrate
	mkdir -p internal/{domain/{entities,repositories,services},adapters/{database,cache,external},handlers/http,config}
	mkdir -p pkg/logger api configs deployments/{docker,kubernetes} scripts tests/{unit,integration}
	echo "package main" > cmd/api/main.go
	echo "package main" > cmd/migrate/main.go
	echo "package entities" > internal/domain/entities/user.go
	echo "package repositories" > internal/domain/repositories/user_repository.go
	echo "package services" > internal/domain/services/user_service.go
	echo "package database" > internal/adapters/database/postgres.go
	echo "package cache" > internal/adapters/cache/redis.go
	echo "package external" > internal/adapters/external/payment_gateway.go
	echo "package http" > internal/handlers/http/user_handler.go
	echo "package http" > internal/handlers/http/routes.go
	echo "package http" > internal/handlers/http/middleware.go
	echo "package config" > internal/config/config.go
	echo "package logger" > pkg/logger/logger.go
	touch api/openapi.yaml
	touch configs/local.yaml configs/production.yaml
	touch deployments/docker/Dockerfile deployments/kubernetes/deployment.yaml
	touch scripts/build.sh scripts/migrate.sh
	touch tests/unit/.gitkeep tests/integration/.gitkeep
	chmod +x scripts/*.sh
	echo "Structure successfully created on Unix/Linux!"
endif

build:
	go build -o bin/app ./cmd/api

dev:
	go run ./cmd/api

test:
	go test ./...
