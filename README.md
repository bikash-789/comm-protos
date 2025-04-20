# comm-protos

A centralized repository for Protocol Buffer definitions across Go microservices.

## Overview

This repository serves as a single source of truth for all protobuf definitions used in our Go-based services. By centralizing these definitions, we ensure consistent interfaces, type safety, and efficient communication between services.

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
```

## Generating Protocol Buffer Code

To generate the Go code from proto files:

```bash
# Install required tools
make init

# specify service name 
svc_dir := <service_name>

# Generate code for all services
make api
```