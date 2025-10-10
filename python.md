---
layout: default
title: AWS Advanced Python Wrapper
---

# AWS Advanced Python Wrapper

[← Back to Home](/)

The AWS Advanced Python Wrapper is a Python database driver wrapper that adds AWS-specific features to standard Python database drivers for Aurora and RDS.

**Repository:** [github.com/aws/aws-advanced-python-wrapper](https://github.com/aws/aws-advanced-python-wrapper)

## Installation

```bash
pip install aws-advanced-python-wrapper
```

## Quick Start

```python
import aws_advanced_python_wrapper
from aws_advanced_python_wrapper import AwsWrapperConnection

config = {
    'host': 'db-instance.cluster-xyz.us-east-1.rds.amazonaws.com',
    'database': 'mydb',
    'user': 'username',
    'password': 'password',
    'plugins': 'failover,iam'
}

conn = AwsWrapperConnection.connect(config, driver_dialect='pg8000')
cursor = conn.cursor()
cursor.execute("SELECT 1")
```

## Key Features

- **Failover Plugin**: Automatic failover for Aurora clusters
- **IAM Authentication Plugin**: AWS IAM database authentication
- **Secrets Manager Plugin**: Retrieve credentials from AWS Secrets Manager
- **Read/Write Splitting Plugin**: Intelligent query routing
- **Host Monitoring Plugin**: Connection health monitoring
- **Driver Dialect Support**: Works with psycopg2, pg8000, PyMySQL, and mysql-connector-python

## Configuration

Configure plugins and settings via connection parameters:

```python
config = {
    'plugins': 'failover,iam,secretsManager',
    'failover_timeout_ms': 60000,
    'cluster_id': 'my-cluster'
}
```

## Common Configurations

### Basic Failover

```python
config = {
    'host': 'cluster.region.rds.amazonaws.com',
    'database': 'mydb',
    'user': 'username',
    'password': 'password',
    'plugins': 'failover'
}

conn = AwsWrapperConnection.connect(config, driver_dialect='pg8000')
```

### IAM Authentication

```python
config = {
    'host': 'cluster.region.rds.amazonaws.com',
    'database': 'mydb',
    'user': 'iamuser',
    'plugins': 'failover,iam',
    'region': 'us-east-1'
}

conn = AwsWrapperConnection.connect(config, driver_dialect='pg8000')
```

### Secrets Manager

```python
config = {
    'plugins': 'failover,secrets_manager',
    'secret_id': 'arn:aws:secretsmanager:region:account:secret:name',
    'region': 'us-east-1'
}

conn = AwsWrapperConnection.connect(config, driver_dialect='pg8000')
```

### Read/Write Splitting

```python
config = {
    'host': 'cluster.region.rds.amazonaws.com',
    'database': 'mydb',
    'user': 'username',
    'password': 'password',
    'plugins': 'failover,read_write_splitting'
}

conn = AwsWrapperConnection.connect(config, driver_dialect='pg8000')

# Reads go to reader
cursor = conn.cursor()
cursor.execute("SELECT * FROM users")

# Writes go to writer
cursor.execute("INSERT INTO users VALUES (%s, %s)", ('name', 'email'))
conn.commit()
```

## Supported Driver Dialects

- **PostgreSQL**: `pg8000`, `psycopg2`, `psycopg`
- **MySQL**: `pymysql`, `mysql-connector-python`

## Context Manager Support

```python
with AwsWrapperConnection.connect(config, driver_dialect='pg8000') as conn:
    with conn.cursor() as cursor:
        cursor.execute("SELECT 1")
        result = cursor.fetchone()
```

## Resources

- [GitHub Repository](https://github.com/aws/aws-advanced-python-wrapper)
- [API Documentation](https://github.com/aws/aws-advanced-python-wrapper/tree/main/docs)
- [Examples](https://github.com/aws/aws-advanced-python-wrapper/tree/main/examples)
