---
layout: default
title: AWS Advanced Node.js Wrapper
---

# AWS Advanced Node.js Wrapper

[← Back to Home](/)

The AWS Advanced Node.js Wrapper enhances Node.js database drivers with AWS-specific features for Amazon Aurora and RDS databases.

**Repository:** [github.com/aws/aws-advanced-nodejs-wrapper](https://github.com/aws/aws-advanced-nodejs-wrapper)

## Installation

```bash
npm install aws-advanced-nodejs-wrapper
```

## Quick Start

**PostgreSQL:**
```javascript
const { AwsPgClient } = require('aws-advanced-nodejs-wrapper');

const client = new AwsPgClient({
  host: 'db-instance.cluster-xyz.us-east-1.rds.amazonaws.com',
  database: 'mydb',
  user: 'username',
  password: 'password',
  plugins: 'failover,iam'
});

await client.connect();
const result = await client.query('SELECT 1');
await client.end();
```

**MySQL:**
```javascript
const { AwsMySQLClient } = require('aws-advanced-nodejs-wrapper');

const client = new AwsMySQLClient({
  host: 'db-instance.cluster-xyz.us-east-1.rds.amazonaws.com',
  database: 'mydb',
  user: 'username',
  password: 'password',
  plugins: 'failover,iam'
});

await client.connect();
const [rows] = await client.query('SELECT 1');
await client.end();
```

## Key Features

- **Failover Plugin**: Fast failover for Aurora clusters
- **IAM Authentication Plugin**: AWS IAM database authentication
- **Secrets Manager Plugin**: Automatic credential retrieval
- **Read/Write Splitting Plugin**: Query routing optimization
- **Aurora Connection Tracker Plugin**: Enhanced connection management
- **Driver Support**: Compatible with pg (PostgreSQL) and mysql2 (MySQL)

## Configuration

Enable and configure plugins:

```javascript
const client = new AwsPgClient({
  plugins: 'failover,iam,secretsManager',
  failoverTimeoutMs: 60000,
  clusterId: 'my-cluster'
});
```

## Common Configurations

### Basic Failover

```javascript
const { AwsPgClient } = require('aws-advanced-nodejs-wrapper');

const client = new AwsPgClient({
  host: 'cluster.region.rds.amazonaws.com',
  database: 'mydb',
  user: 'username',
  password: 'password',
  plugins: 'failover'
});

await client.connect();
const result = await client.query('SELECT 1');
await client.end();
```

### IAM Authentication

```javascript
const client = new AwsPgClient({
  host: 'cluster.region.rds.amazonaws.com',
  database: 'mydb',
  user: 'iamuser',
  plugins: 'failover,iam',
  region: 'us-east-1'
});

await client.connect();
```

### Secrets Manager

```javascript
const client = new AwsPgClient({
  plugins: 'failover,secretsManager',
  secretId: 'arn:aws:secretsmanager:region:account:secret:name',
  region: 'us-east-1'
});

await client.connect();
```

### Read/Write Splitting

```javascript
const client = new AwsPgClient({
  host: 'cluster.region.rds.amazonaws.com',
  database: 'mydb',
  user: 'username',
  password: 'password',
  plugins: 'failover,readWriteSplitting'
});

await client.connect();

// Reads go to reader
const users = await client.query('SELECT * FROM users');

// Writes go to writer
await client.query('INSERT INTO users VALUES ($1, $2)', ['name', 'email']);
```

## MySQL Example

```javascript
const { AwsMySQLClient } = require('aws-advanced-nodejs-wrapper');

const client = new AwsMySQLClient({
  host: 'cluster.region.rds.amazonaws.com',
  database: 'mydb',
  user: 'username',
  password: 'password',
  plugins: 'failover,iam'
});

await client.connect();
const [rows] = await client.query('SELECT 1');
await client.end();
```

## Connection Pooling

```javascript
const { AwsPgPool } = require('aws-advanced-nodejs-wrapper');

const pool = new AwsPgPool({
  host: 'cluster.region.rds.amazonaws.com',
  database: 'mydb',
  user: 'username',
  password: 'password',
  plugins: 'failover',
  max: 20,
  idleTimeoutMillis: 30000
});

const client = await pool.connect();
try {
  const result = await client.query('SELECT * FROM users');
} finally {
  client.release();
}

await pool.end();
```

## Resources

- [GitHub Repository](https://github.com/aws/aws-advanced-nodejs-wrapper)
- [API Documentation](https://github.com/aws/aws-advanced-nodejs-wrapper/tree/main/docs)
- [Examples](https://github.com/aws/aws-advanced-nodejs-wrapper/tree/main/examples)
