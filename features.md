---
layout: default
title: Features
---

# Features

[← Back to Home](/)

## Failover Plugin

The Failover Plugin provides fast detection and recovery from database failures in Aurora clusters.

### How It Works

1. **Topology Discovery**: Wrapper queries Aurora cluster to discover all instances and their roles (writer/reader)
2. **Health Monitoring**: Continuously monitors connection health using lightweight queries
3. **Failure Detection**: Detects failures through connection errors, timeouts, or health check failures
4. **Failover Execution**: When writer fails, connects to new writer; when reader fails, connects to different reader
5. **Topology Refresh**: Updates cluster topology after failover completes

### Configuration Options

- `failoverTimeoutMs` (default: 60000): Maximum time to complete failover
- `failoverClusterTopologyRefreshRateMs` (default: 5000): How often to refresh topology
- `failoverReaderConnectTimeoutMs` (default: 30000): Timeout for reader connections
- `failoverWriterReconnectIntervalMs` (default: 2000): Delay between writer reconnection attempts

### Typical Failover Times

- **Writer Failover**: 1-30 seconds (vs 60-120 seconds without wrapper)
- **Reader Failover**: <1 second (immediate switch to healthy reader)

## IAM Authentication Plugin

Enables AWS IAM database authentication without managing passwords.

### How It Works

1. **Token Generation**: Uses AWS SDK to generate authentication token from IAM credentials
2. **Token Caching**: Caches token for up to 15 minutes (token lifetime)
3. **Automatic Refresh**: Generates new token before expiration
4. **Connection**: Uses token as password in database connection

### Prerequisites

- Database user must be configured for IAM authentication
- Application must have IAM permissions: `rds-db:connect`
- AWS credentials available via standard credential chain

### IAM Policy Example

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": "rds-db:connect",
    "Resource": "arn:aws:rds-db:region:account:dbuser:cluster-id/db-user"
  }]
}
```

### Configuration Options

- `iamDefaultPort` (default: 5432 for PostgreSQL, 3306 for MySQL): Port for token generation
- `iamTokenExpiration` (default: 900): Token cache duration in seconds
- `iamRegion`: AWS region (auto-detected if not specified)

## Secrets Manager Plugin

Retrieves database credentials from AWS Secrets Manager.

### How It Works

1. **Secret Fetch**: Retrieves secret from Secrets Manager at connection time
2. **Credential Extraction**: Parses JSON secret for username, password, host, port
3. **Caching**: Caches credentials to reduce API calls
4. **Rotation Support**: Detects secret rotation and fetches new credentials

### Secret Format

```json
{
  "username": "dbuser",
  "password": "dbpassword",
  "host": "cluster.region.rds.amazonaws.com",
  "port": 5432,
  "dbname": "mydb"
}
```

### Configuration Options

- `secretId`: Secret ARN or name (required)
- `secretRegion`: AWS region for Secrets Manager
- `secretRefreshIntervalMs` (default: 300000): How often to check for rotation

### Prerequisites

- IAM permissions: `secretsmanager:GetSecretValue`
- Secret must exist in Secrets Manager

## Read/Write Splitting Plugin

Routes queries to appropriate database instances based on operation type.

### How It Works

1. **SQL Analysis**: Parses SQL statement to determine operation type
2. **Routing Decision**: 
   - SELECT → Reader instance
   - INSERT/UPDATE/DELETE → Writer instance
   - DDL statements → Writer instance
3. **Connection Management**: Maintains separate connections to readers and writers
4. **Load Balancing**: Distributes read queries across available readers

### Configuration Options

- `readWriteSplittingStrategy` (default: `random`): How to select reader (`random`, `roundRobin`, `leastConnections`)
- `readWriteSplittingInternalPoolSize` (default: 5): Connection pool size per instance

### Limitations

- Requires explicit transaction management
- Read-after-write consistency not guaranteed (replication lag)
- Not suitable for applications requiring strong consistency

## Host Monitoring Plugin

Tracks database instance health and performance.

### How It Works

1. **Connection Monitoring**: Tracks connection success/failure rates
2. **Latency Tracking**: Measures query response times
3. **Health Scoring**: Assigns health score to each instance
4. **Unhealthy Host Removal**: Temporarily removes unhealthy instances from rotation
5. **Recovery Detection**: Periodically retries unhealthy instances

### Configuration Options

- `monitoringConnectionCheckIntervalMs` (default: 5000): Health check frequency
- `monitoringFailureDetectionTimeMs` (default: 30000): Time to mark instance unhealthy
- `monitoringFailureDetectionIntervalMs` (default: 5000): Interval between failure checks
- `monitoringFailureDetectionCount` (default: 3): Failures before marking unhealthy

### Metrics Collected

- Connection success/failure rate
- Query latency (min, max, avg)
- Active connection count
- Instance availability percentage

## Aurora Connection Tracker Plugin

Optimizes connection management for Aurora clusters.

### How It Works

1. **Connection Tracking**: Maintains registry of all connections to cluster
2. **Stale Connection Detection**: Identifies connections to instances no longer in cluster
3. **Automatic Cleanup**: Closes stale connections
4. **Connection Reuse**: Reuses existing connections when possible

### Configuration Options

- `connectionTrackerIntervalMs` (default: 30000): How often to check for stale connections
- `connectionTrackerMaxIdleTimeMs` (default: 1800000): Max idle time before cleanup

## Plugin Compatibility

Not all plugins work together. Compatible combinations:

✅ **Compatible:**
- Failover + IAM
- Failover + Secrets Manager
- Failover + Read/Write Splitting
- IAM + Secrets Manager (use one or the other)
- All monitoring plugins with any feature plugin

❌ **Incompatible:**
- IAM + Secrets Manager (both provide credentials)
- Read/Write Splitting + certain transaction modes

## Custom Plugins

All wrappers support custom plugin development. Implement the plugin interface for your language:

- **JDBC**: Extend `ConnectionPlugin` interface
- **Python**: Extend `Plugin` class
- **Node.js**: Implement `Plugin` interface
- **Go**: Implement `Plugin` interface

Custom plugins can intercept any database operation and add custom logic.
