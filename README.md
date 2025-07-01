# Go Project Structure Guide

This document explains the standard Go project structure following Go community conventions and best practices.

## Project Layout

```
projeto/
├── cmd/                     # Main applications
│   └── server/              # Server application entry point
│       └── main.go          # Application entry point
├── internal/                # Private application code
│   ├── handlers/            # HTTP handlers/controllers
│   ├── services/            # Business logic layer
│   └── models/              # Data models/structures
├── pkg/                     # Public library code
│   ├── logger/              # Reusable logging utilities
│   └── validator/           # Validation utilities
├── web/                     # Web assets and templates
│   ├── static/              # Static files (CSS, JS, images)
│   │   ├── css/
│   │   ├── js/
│   │   └── images/
│   ├── templates/           # HTML templates
│   │   ├── base.html
│   │   └── pages/
│   └── assets_dev.go        # External assets configuration
├── api/                     # API definitions and documentation
├── configs/                 # Configuration files
├── scripts/                 # Build and deployment scripts
├── docs/                    # Project documentation
├── assets_prod.go           # Embedded assets configuration
├── go.mod                   # Go module definition
├── go.sum                   # Go module checksums
├── Dockerfile               # Container configuration
├── docker-compose.yml       # Multi-container configuration
└── README.md                # Project documentation
```

## Directory Explanations

### `/cmd`
Contains the main applications for the project. The directory name for each application should match the name of the executable you want to have.

- **Purpose**: Entry points for different applications
- **Convention**: One subdirectory per executable
- **Example**: `cmd/server/main.go`, `cmd/worker/main.go`, `cmd/cli/main.go`

```go
// cmd/server/main.go
package main

import (
    "myproject/internal/handlers"
    "myproject/internal/services"
)

func main() {
    // Application initialization
}
```

### `/internal`
Private application and library code. This is the code you don't want others importing in their applications or libraries.

- **Purpose**: Private code that cannot be imported by external projects
- **Go Enforcement**: The Go compiler enforces this privacy
- **Structure**: Organize by feature or layer

#### `/internal/handlers`
HTTP handlers, controllers, or any request/response handling logic.

```go
// internal/handlers/user.go
package handlers

type UserHandler struct {
    userService services.UserService
}

func (h *UserHandler) GetUser(w http.ResponseWriter, r *http.Request) {
    // Handler implementation
}
```

#### `/internal/services`
Business logic layer, service implementations.

```go
// internal/services/user.go
package services

type UserService interface {
    GetUser(id int) (*models.User, error)
    CreateUser(user *models.User) error
}

type userService struct {
    repo repositories.UserRepository
}
```

#### `/internal/models`
Data structures, models, and domain objects.

```go
// internal/models/user.go
package models

type User struct {
    ID    int    `json:"id" db:"id"`
    Name  string `json:"name" db:"name"`
    Email string `json:"email" db:"email"`
}
```

### `/pkg`
Library code that's safe to use by external applications. Other projects will import these libraries expecting them to work.

- **Purpose**: Public library code
- **When to use**: When you want to share code with other projects
- **Examples**: Utilities, helpers, common functionality

```go
// pkg/logger/logger.go
package logger

func New() *Logger {
    // Logger implementation
}
```

### `/web`
Web application specific components: static web assets, server side templates and SPAs.

#### `/web/static`
Static files like CSS, JavaScript, images, fonts.

```
web/static/
├── css/
│   ├── main.css
│   └── components.css
├── js/
│   ├── app.js
│   └── utils.js
└── images/
    ├── logo.png
    └── icons/
```

#### `/web/templates`
Server-side templates (HTML templates, etc.).

```html
<!-- web/templates/base.html -->
<!DOCTYPE html>
<html>
<head>
    <title>{{.Title}}</title>
    <link rel="stylesheet" href="/static/css/main.css">
</head>
<body>
    {{template "content" .}}
</body>
</html>
```

### Asset Management Files

#### `assets_dev.go` (Development)
Configuration for external assets during development.

```go
//go:build dev

package main

import "github.com/gin-gonic/gin"

func setupAssets(r *gin.Engine) {
    // External assets for development
    r.Static("/static", "./web/static")
    r.LoadHTMLGlob("web/templates/*")
}
```

#### `assets_prod.go` (Production)
Configuration for embedded assets in production.

```go
//go:build !dev

package main

import (
    "embed"
    "html/template"
    "net/http"
    "github.com/gin-gonic/gin"
)

//go:embed web/*
var webFiles embed.FS

func setupAssets(r *gin.Engine) {
    // Embedded assets for production
    r.StaticFS("/static", http.FS(webFiles))
    tmpl := template.Must(template.New("").ParseFS(webFiles, "web/templates/*.html"))
    r.SetHTMLTemplate(tmpl)
}
```

### `/api`
OpenAPI/Swagger specs, JSON schema files, protocol definition files.

```
api/
├── openapi.yaml
├── user.proto
└── schemas/
    └── user.json
```

### `/configs`
Configuration file templates or default configs.

```
configs/
├── config.yaml
├── database.yaml
└── env/
    ├── development.yaml
    ├── staging.yaml
    └── production.yaml
```

### `/scripts`
Scripts to perform various build, install, analysis, etc operations.

```
scripts/
├── build.sh
├── deploy.sh
├── migrate.sh
└── test.sh
```

### `/docs`
Design and user documents (in addition to your godoc generated documentation).

```
docs/
├── API.md
├── DEPLOYMENT.md
├── ARCHITECTURE.md
└── images/
    └── architecture-diagram.png
```

## Go Module Files

### `go.mod`
Defines the module path and lists dependencies.

```go
module myproject

go 1.21

require (
    github.com/gin-gonic/gin v1.9.1
    github.com/lib/pq v1.10.9
    gorm.io/gorm v1.25.4
)
```

### `go.sum`
Contains cryptographic checksums of dependencies (lockfile equivalent).

## Container Files

### `Dockerfile`
Container configuration for the application.

```dockerfile
FROM golang:1.21-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -o main cmd/server/main.go

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/

COPY --from=builder /app/main .

EXPOSE 8080
CMD ["./main"]
```

### `docker-compose.yml`
Multi-container application configuration.

```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8080:8080"
    depends_on:
      - db
    environment:
      - DB_HOST=db

  db:
    image: postgres:15
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

## Build Commands

### Development
```bash
# Run with external assets
go run -tags=dev cmd/server/main.go

# Install dependencies
go mod tidy

# Run tests
go test ./...
```

### Production
```bash
# Build with embedded assets
go build -o app cmd/server/main.go

# Build for different platforms
GOOS=linux GOARCH=amd64 go build -o app-linux cmd/server/main.go

# Build with Docker
docker build -t myapp .
docker-compose up -d
```

## Best Practices

### 1. **Visibility Rules**
- Use `internal/` for private code
- Use `pkg/` for reusable libraries
- Export only what's necessary (PascalCase vs camelCase)

### 2. **Package Naming**
- Short, concise package names
- No underscores or mixed caps
- Avoid plurals

### 3. **Import Organization**
```go
import (
    // Standard library first
    "context"
    "fmt"
    "net/http"
    
    // Third-party packages
    "github.com/gin-gonic/gin"
    "github.com/lib/pq"
    
    // Local packages last
    "myproject/internal/handlers"
    "myproject/internal/services"
)
```

### 4. **Error Handling**
```go
// Define package-level errors
var (
    ErrUserNotFound = errors.New("user not found")
    ErrInvalidInput = errors.New("invalid input")
)

// Return errors explicitly
func GetUser(id int) (*User, error) {
    if id <= 0 {
        return nil, ErrInvalidInput
    }
    // ...
}
```

### 5. **Configuration Management**
```go
// Use struct for configuration
type Config struct {
    Server   ServerConfig   `yaml:"server"`
    Database DatabaseConfig `yaml:"database"`
    Redis    RedisConfig    `yaml:"redis"`
}

// Environment-specific configs
func LoadConfig(env string) (*Config, error) {
    // Load from configs/env/{env}.yaml
}
```

## Common Anti-Patterns to Avoid

1. **Don't create `/src` directory** - Go projects don't need it
2. **Don't put everything in `/pkg`** - Use it only for truly reusable code
3. **Don't create deep package hierarchies** - Keep it simple and flat
4. **Don't use generic names** - Be specific about package purposes
5. **Don't ignore the `/internal` convention** - Use it to enforce privacy

## Conclusion

This structure provides a solid foundation for Go projects of any size. It follows Go community conventions, enforces proper separation of concerns, and scales well as your project grows. Remember that not every project needs every directory - start simple and add structure as needed.