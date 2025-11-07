---
layout: default
title: AWS Advanced Drivers
---

# AWS Advanced Drivers

The AWS Advanced Drivers are wrapper libraries that enhance standard database drivers with AWS-specific features for Amazon Aurora and RDS. They intercept database calls and add functionality like fast failover, IAM authentication, and intelligent connection management without requiring application code changes.

## How They Work

The wrappers use a **plugin architecture** that sits between your application and the underlying database driver. When your application makes a database call, the wrapper intercepts it, applies configured plugins, and forwards it to the actual driver.

```
Application → AWS Wrapper → Plugins → Database Driver → Database
```

### Plugin Pipeline

Each wrapper implements a plugin pipeline where plugins execute in sequence:

1. **Connection Interception**: Wrapper captures connection requests
2. **Plugin Execution**: Each enabled plugin processes the request
3. **Driver Delegation**: Final call goes to the underlying driver
4. **Response Processing**: Plugins can modify responses on the way back

## Available Wrappers

- **[JDBC](jdbc)** - For Java applications
- **[Python](python)** - For Python applications  
- **[Node.js](nodejs)** - For Node.js applications
- **[Go](go)** - For Go applications
- **[.NET](dotnet)** - For .NET applications

## Core Features

### Failover Plugin

Detects database failures and automatically reconnects to a healthy instance in Aurora clusters.

**How it works:**
- Monitors connection health continuously
- Detects writer/reader failures in milliseconds
- Maintains cluster topology cache
- Reconnects to new writer during failover (typically 1-30 seconds vs 60+ seconds with standard drivers)

**Configuration:**
- `failoverTimeoutMs`: Maximum time to attempt failover (default: 60000)
- `failoverMode`: Reader or writer failover strategy
- `clusterTopologyRefreshMs`: How often to refresh cluster state

### IAM Authentication Plugin

Generates and uses AWS IAM authentication tokens instead of passwords.

**How it works:**
- Generates short-lived authentication tokens using AWS credentials
- Tokens are valid for 15 minutes
- Automatically refreshes tokens before expiration
- Uses AWS SDK credentials chain (environment, profile, IAM role, etc.)

**Benefits:**
- No hardcoded passwords
- Centralized access control via IAM
- Automatic credential rotation
- CloudTrail audit logging

### Secrets Manager Plugin

Retrieves database credentials from AWS Secrets Manager.

**How it works:**
- Fetches credentials at connection time
- Caches credentials to reduce API calls
- Automatically refreshes when secrets rotate
- Supports both single-user and multi-user rotation

**Configuration:**
- `secretId`: ARN or name of the secret
- `region`: AWS region for Secrets Manager

### Read/Write Splitting Plugin

Routes queries to appropriate endpoints based on operation type.

**How it works:**
- Analyzes SQL statements to determine if read or write
- Directs SELECT queries to reader instances
- Directs INSERT/UPDATE/DELETE to writer instance
- Maintains separate connection pools for readers and writers

**Benefits:**
- Offloads read traffic from writer
- Better resource utilization
- Improved application performance

### Host Monitoring Plugin

Tracks connection health and performance metrics.

**How it works:**
- Monitors connection latency and errors
- Maintains health scores for each host
- Removes unhealthy hosts from rotation
- Integrates with CloudWatch for metrics

## Connection String Format

Each wrapper uses a specific format to enable the wrapper functionality:

**JDBC:**
```
jdbc:aws-wrapper:postgresql://host:port/database
```

**Python:**
```python
AwsWrapperConnection.connect(config, driver_dialect='pg8000')
```

**Node.js:**
```javascript
new AwsPgClient({ host, database, plugins: '...' })
```

**Go:**
```
aws-wrapper:postgres://host:port/database?plugins=...
```

## Plugin Configuration

Enable plugins via connection properties:

```
plugins=failover,iam,secretsManager,readWriteSplitting
```

Plugins execute in the order specified. Common configurations:

- **Basic Aurora**: `failover`
- **IAM Auth**: `failover,iam`
- **Full Featured**: `failover,iam,secretsManager,readWriteSplitting`

## Performance Considerations

- **Failover**: Adds 1-5ms overhead per connection
- **IAM Auth**: Token generation takes 50-100ms (cached for 15 minutes)
- **Secrets Manager**: Initial fetch takes 100-200ms (cached)
- **Read/Write Splitting**: Minimal overhead (<1ms per query)

## Best Practices

1. **Enable only needed plugins** - Each plugin adds overhead
2. **Configure appropriate timeouts** - Balance between fast failover and false positives
3. **Use connection pooling** - Reduces IAM token generation overhead
4. **Monitor plugin metrics** - Track failover frequency and success rates
5. **Test failover scenarios** - Verify behavior during actual failures

## Getting Started

Choose your language and follow the specific installation and configuration guide.
