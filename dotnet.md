---
layout: default
title: AWS Advanced .NET Data Provider Wrapper
---

# AWS Advanced .NET Data Provider Wrapper

[← Back to Home](/)

The AWS Advanced .NET Data Provider Wrapper enhances .NET database providers with AWS-specific features for Amazon Aurora and RDS databases.

**Latest Version:** [1.0.0](https://github.com/aws/aws-advanced-dotnet-data-provider-wrapper/releases/tag/1.0.0)  
**Repository:** [github.com/aws/aws-advanced-dotnet-data-provider-wrapper](https://github.com/aws/aws-advanced-dotnet-data-provider-wrapper)

## Installation

```bash
dotnet add package AWS.AdvancedDotnetWrapper
```

**NuGet Package Manager:**
```powershell
Install-Package AWS.AdvancedDotnetWrapper
```

## Quick Start

**PostgreSQL:**
```csharp
using AWS.AdvancedDotnetWrapper;
using Npgsql;

var config = new AwsWrapperConnectionConfig
{
    Host = "cluster.region.rds.amazonaws.com",
    Database = "mydb",
    Username = "username",
    Password = "password",
    Plugins = "failover,iam"
};

using var conn = new AwsWrapperConnection<NpgsqlConnection>(config);
await conn.OpenAsync();

using var cmd = conn.CreateCommand();
cmd.CommandText = "SELECT 1";
var result = await cmd.ExecuteScalarAsync();
```

**MySQL:**
```csharp
using AWS.AdvancedDotnetWrapper;
using MySqlConnector;

var config = new AwsWrapperConnectionConfig
{
    Host = "cluster.region.rds.amazonaws.com",
    Database = "mydb",
    Username = "username",
    Password = "password",
    Plugins = "failover,iam"
};

using var conn = new AwsWrapperConnection<MySqlConnection>(config);
await conn.OpenAsync();
```

## Key Features

- **Failover Plugin**: Automatic failover for Aurora clusters
- **IAM Authentication Plugin**: AWS IAM database authentication
- **Secrets Manager Plugin**: Credential management via AWS Secrets Manager
- **Read/Write Splitting Plugin**: Intelligent query routing
- **Host Monitoring Plugin**: Connection health tracking
- **Provider Support**: Compatible with Npgsql (PostgreSQL) and MySqlConnector (MySQL)

## Configuration

Configure plugins via connection config:

```csharp
var config = new AwsWrapperConnectionConfig
{
    Plugins = "failover,iam,secretsManager",
    FailoverTimeoutMs = 60000,
    Region = "us-east-1"
};
```

## Common Configurations

### Basic Failover

```csharp
var config = new AwsWrapperConnectionConfig
{
    Host = "cluster.region.rds.amazonaws.com",
    Database = "mydb",
    Username = "username",
    Password = "password",
    Plugins = "failover"
};

using var conn = new AwsWrapperConnection<NpgsqlConnection>(config);
await conn.OpenAsync();
```

### IAM Authentication

```csharp
var config = new AwsWrapperConnectionConfig
{
    Host = "cluster.region.rds.amazonaws.com",
    Database = "mydb",
    Username = "iamuser",
    Plugins = "failover,iam",
    Region = "us-east-1"
};

using var conn = new AwsWrapperConnection<NpgsqlConnection>(config);
await conn.OpenAsync();
```

### Secrets Manager

```csharp
var config = new AwsWrapperConnectionConfig
{
    Plugins = "failover,secretsManager",
    SecretId = "arn:aws:secretsmanager:region:account:secret:name",
    Region = "us-east-1"
};

using var conn = new AwsWrapperConnection<NpgsqlConnection>(config);
await conn.OpenAsync();
```

### Read/Write Splitting

```csharp
var config = new AwsWrapperConnectionConfig
{
    Host = "cluster.region.rds.amazonaws.com",
    Database = "mydb",
    Username = "username",
    Password = "password",
    Plugins = "failover,readWriteSplitting"
};

using var conn = new AwsWrapperConnection<NpgsqlConnection>(config);
await conn.OpenAsync();

// Reads go to reader
using var readCmd = conn.CreateCommand();
readCmd.CommandText = "SELECT * FROM users";
var reader = await readCmd.ExecuteReaderAsync();

// Writes go to writer
using var writeCmd = conn.CreateCommand();
writeCmd.CommandText = "INSERT INTO users VALUES (@name, @email)";
writeCmd.Parameters.AddWithValue("@name", "name");
writeCmd.Parameters.AddWithValue("@email", "email");
await writeCmd.ExecuteNonQueryAsync();
```

## Async/Await Support

```csharp
using var conn = new AwsWrapperConnection<NpgsqlConnection>(config);
await conn.OpenAsync();

using var cmd = conn.CreateCommand();
cmd.CommandText = "SELECT * FROM users WHERE id = @id";
cmd.Parameters.AddWithValue("@id", userId);

using var reader = await cmd.ExecuteReaderAsync();
while (await reader.ReadAsync())
{
    // Process results
}
```

## Transaction Handling

```csharp
using var conn = new AwsWrapperConnection<NpgsqlConnection>(config);
await conn.OpenAsync();

using var transaction = await conn.BeginTransactionAsync();
try
{
    using var cmd = conn.CreateCommand();
    cmd.Transaction = transaction;
    cmd.CommandText = "INSERT INTO users VALUES (@name, @email)";
    cmd.Parameters.AddWithValue("@name", "name");
    cmd.Parameters.AddWithValue("@email", "email");
    await cmd.ExecuteNonQueryAsync();
    
    await transaction.CommitAsync();
}
catch
{
    await transaction.RollbackAsync();
    throw;
}
```

## Resources

- [GitHub Repository](https://github.com/aws/aws-advanced-dotnet-data-provider-wrapper)
- [API Documentation](https://github.com/aws/aws-advanced-dotnet-data-provider-wrapper/tree/main/docs)
- [Examples](https://github.com/aws/aws-advanced-dotnet-data-provider-wrapper/tree/main/examples)
