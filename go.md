---
layout: default
title: AWS Advanced Go Wrapper
---

# AWS Advanced Go Wrapper

[← Back to Home](/)

The AWS Advanced Go Wrapper is a Go database driver wrapper that provides AWS-specific enhancements for connecting to Amazon Aurora and RDS databases.

**Latest Version:** [2025-12-16](https://github.com/aws/aws-advanced-go-wrapper/releases/tag/release-2025-12-16)  
**Repository:** [github.com/aws/aws-advanced-go-wrapper](https://github.com/aws/aws-advanced-go-wrapper)

## Installation

```bash
go get github.com/aws/aws-advanced-go-wrapper
```

## Quick Start

**PostgreSQL:**
```go
import (
    "database/sql"
    _ "github.com/aws/aws-advanced-go-wrapper/pgdriver"
)

db, err := sql.Open("aws-wrapper:postgres", 
    "host=db-instance.cluster-xyz.us-east-1.rds.amazonaws.com "+
    "user=username password=password dbname=mydb "+
    "plugins=failover,iam")
if err != nil {
    panic(err)
}
defer db.Close()
```

**MySQL:**
```go
import (
    "database/sql"
    _ "github.com/aws/aws-advanced-go-wrapper/mysqldriver"
)

db, err := sql.Open("aws-wrapper:mysql",
    "username:password@tcp(db-instance.cluster-xyz.us-east-1.rds.amazonaws.com:3306)/mydb?plugins=failover,iam")
if err != nil {
    panic(err)
}
defer db.Close()
```

## Key Features

- **Failover Plugin**: Automatic failover for Aurora clusters
- **IAM Authentication Plugin**: AWS IAM database authentication
- **Secrets Manager Plugin**: Credential management via AWS Secrets Manager
- **Read/Write Splitting Plugin**: Intelligent query routing
- **Host Monitoring Plugin**: Connection health tracking
- **Driver Support**: Compatible with pgx (PostgreSQL) and go-sql-driver/mysql (MySQL)

## Configuration

Configure plugins via connection string or DSN:

```go
db, err := sql.Open("aws-wrapper:postgres",
    "host=myhost plugins=failover,iam failoverTimeoutMs=60000")
```

## Common Configurations

### Basic Failover

```go
import (
    "database/sql"
    _ "github.com/aws/aws-advanced-go-wrapper/pgdriver"
)

db, err := sql.Open("aws-wrapper:postgres", 
    "host=cluster.region.rds.amazonaws.com "+
    "user=username password=password dbname=mydb "+
    "plugins=failover")
if err != nil {
    panic(err)
}
defer db.Close()

rows, err := db.Query("SELECT * FROM users")
```

### IAM Authentication

```go
db, err := sql.Open("aws-wrapper:postgres",
    "host=cluster.region.rds.amazonaws.com "+
    "user=iamuser dbname=mydb "+
    "plugins=failover,iam "+
    "region=us-east-1")
```

### Secrets Manager

```go
db, err := sql.Open("aws-wrapper:postgres",
    "plugins=failover,secretsManager "+
    "secretId=arn:aws:secretsmanager:region:account:secret:name "+
    "region=us-east-1")
```

### Read/Write Splitting

```go
db, err := sql.Open("aws-wrapper:postgres",
    "host=cluster.region.rds.amazonaws.com "+
    "user=username password=password dbname=mydb "+
    "plugins=failover,readWriteSplitting")

// Reads go to reader
rows, err := db.Query("SELECT * FROM users")

// Writes go to writer
_, err = db.Exec("INSERT INTO users VALUES ($1, $2)", "name", "email")
```

## MySQL Example

```go
import (
    "database/sql"
    _ "github.com/aws/aws-advanced-go-wrapper/mysqldriver"
)

db, err := sql.Open("aws-wrapper:mysql",
    "username:password@tcp(cluster.region.rds.amazonaws.com:3306)/mydb?plugins=failover,iam")
if err != nil {
    panic(err)
}
defer db.Close()
```

## Connection Pooling

```go
db, err := sql.Open("aws-wrapper:postgres", dsn)
if err != nil {
    panic(err)
}

// Configure connection pool
db.SetMaxOpenConns(25)
db.SetMaxIdleConns(5)
db.SetConnMaxLifetime(5 * time.Minute)
db.SetConnMaxIdleTime(10 * time.Minute)
```

## Context Support

```go
ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
defer cancel()

rows, err := db.QueryContext(ctx, "SELECT * FROM users WHERE id = $1", userID)
if err != nil {
    return err
}
defer rows.Close()
```

## Transaction Handling

```go
tx, err := db.Begin()
if err != nil {
    return err
}
defer tx.Rollback()

_, err = tx.Exec("INSERT INTO users VALUES ($1, $2)", "name", "email")
if err != nil {
    return err
}

err = tx.Commit()
```

## Resources

- [GitHub Repository](https://github.com/aws/aws-advanced-go-wrapper)
- [API Documentation](https://github.com/aws/aws-advanced-go-wrapper/tree/main/docs)
- [Examples](https://github.com/aws/aws-advanced-go-wrapper/tree/main/examples)
