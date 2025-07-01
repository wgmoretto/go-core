# Enterprise App Lite - Go Project

> Minimalistic yet highly scalable Go application structure, maintaining fundamental principles of Clean Architecture and DDD, ready for rapid development and future scalability.

---

## 🚀 Project Structure

```
enterprise-app-lite/
├── cmd/
│   ├── api/
│   │   └── main.go
│   └── migrate/
│       └── main.go
├── internal/
│   ├── domain/
│   │   ├── entities/
│   │   │   └── user.go
│   │   ├── repositories/
│   │   │   └── user_repository.go
│   │   └── services/
│   │       └── user_service.go
│   ├── adapters/
│   │   ├── database/
│   │   │   └── postgres.go
│   │   ├── cache/
│   │   │   └── redis.go
│   │   └── external/
│   │       └── payment_gateway.go
│   ├── handlers/
│   │   └── http/
│   │       ├── user_handler.go
│   │       ├── routes.go
│   │       └── middleware.go
│   └── config/
│       └── config.go
├── pkg/
│   └── logger/
│       └── logger.go
├── api/
│   └── openapi.yaml
├── configs/
│   ├── local.yaml
│   └── production.yaml
├── deployments/
│   ├── docker/
│   │   └── Dockerfile
│   └── kubernetes/
│       └── deployment.yaml
├── scripts/
│   ├── build.sh
│   └── migrate.sh
├── tests/
│   ├── unit/
│   └── integration/
├── Makefile
├── go.mod
├── go.sum
└── README.md
```

---

## 🛠️ Useful Commands (Makefile)

```bash
make setup        # Creates directory structure
make dev          # Runs the project locally
make build        # Builds the application
make test         # Runs all tests
```

## 📌 Architectural Principles Applied

* **Clean Architecture**: Clear separation of responsibilities.
* **Domain-Driven Design (DDD)**: Focus on business entities and rules.
* **Simple Scalability**: Ready for incremental expansion as required.

---

✅ **Ready to Use** – Clone this repository and run:

```bash
make setup
```

Your project is now ready for development!

---

## 🚀 Enterprise-Grade High Scalability Structure

For projects requiring extensive scalability, complexity, and enterprise-level robustness, consider using the full structure with advanced capabilities, such as:

* **Multiple Entry Points** (API, CLI, gRPC, Workers)
* **Advanced CQRS and Event Sourcing Patterns**
* **Multi-Service & Multi-Adapter Support**
* **Robust Observability and Security Layers**
* **Comprehensive Testing Suite**

Refer to the [Enterprise-Level Go Structure] (#HIGH_LEVEL_STRUCT.md) for full details.
