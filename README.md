# comm-protos

A centralized repository for Protocol Buffer definitions across Go microservices.

## Overview

This repository serves as a single source of truth for all protobuf definitions used in our Go-based services. By centralizing these definitions, we ensure consistent interfaces, type safety, and efficient communication between services.

## Installation

To use this package in your Go project:

```bash
go get github.com/bikash-789/comm-protos@v1.0.0
```

## Structure

```
comm-protos/
├── luminex/            # Luminex service protos
│   └── v1/             # Version 1 of Luminex service protos
└── <future-service>/   # Future service protos can be added here
```

## Usage

Import the generated Go code in your service:

```go
import (
    luminexpb "github.com/bikash-789/comm-protos/luminex/v1"
    "github.com/bikash-789/comm-protos/luminex/v1/request"
    "github.com/bikash-789/comm-protos/luminex/v1/response"
)

// Example: Create a repository request
func ExampleCreateRepositoryRequest() {
    req := &request.RepositoryRequest{
        Owner: "bikash-789",
        Repo:  "comm-protos",
    }
    
    // Use the request with your gRPC client...
}
```

## Development

### Generating Protocol Buffer Code

To generate the Go code from proto files:

```bash
# Install required tools
make init

# Generate code for all services
make api
```

### Adding a New Service

1. Create a new directory for your service: `mkdir -p newservice/v1`
2. Add your proto files to this directory
3. Run `make api svc_dir=newservice` to generate code

## Benefits

- **Consistency**: All services use the same message definitions
- **Version Control**: Service interfaces can evolve independently through versioning
- **Reduced Duplication**: Define common messages once and reuse them
- **Type Safety**: Strongly typed interfaces between services

## Versioning

This package follows [Semantic Versioning](https://semver.org/). 
- Major version changes indicate breaking API changes
- Minor version changes add functionality in a backward compatible manner
- Patch version changes make backward compatible bug fixes