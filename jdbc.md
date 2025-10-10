---
layout: default
title: AWS Advanced JDBC Wrapper
---

# AWS Advanced JDBC Wrapper

[← Back to Home](/)

The AWS Advanced JDBC Wrapper is a JDBC driver wrapper that provides advanced features for Java applications connecting to Amazon Aurora and RDS databases.

**Repository:** [github.com/aws/aws-advanced-jdbc-wrapper](https://github.com/aws/aws-advanced-jdbc-wrapper)

## Installation

Add the dependency to your project:

**Maven:**
```xml
<dependency>
    <groupId>software.amazon.jdbc</groupId>
    <artifactId>aws-advanced-jdbc-wrapper</artifactId>
    <version>2.3.0</version>
</dependency>
```

**Gradle:**
```gradle
implementation 'software.amazon.jdbc:aws-advanced-jdbc-wrapper:2.3.0'
```

## Quick Start

```java
import software.amazon.jdbc.Driver;
import java.sql.*;

String url = "jdbc:aws-wrapper:postgresql://db-instance.cluster-xyz.us-east-1.rds.amazonaws.com:5432/mydb";
Properties props = new Properties();
props.setProperty("user", "username");
props.setProperty("password", "password");

try (Connection conn = DriverManager.getConnection(url, props)) {
    // Use connection
}
```

## Key Features

- **Failover Plugin**: Fast failover for Aurora clusters
- **IAM Authentication Plugin**: AWS IAM database authentication
- **Secrets Manager Plugin**: Automatic credential management
- **Read/Write Splitting Plugin**: Route queries to appropriate endpoints
- **Enhanced Monitoring Plugin**: CloudWatch integration
- **Connection Plugin Pipeline**: Extensible plugin architecture

## Configuration

Enable plugins via connection properties:

```java
props.setProperty("wrapperPlugins", "failover,iam,secretsManager");
```

## Common Configurations

### Basic Failover

```java
Properties props = new Properties();
props.setProperty("wrapperPlugins", "failover");
props.setProperty("user", "username");
props.setProperty("password", "password");

String url = "jdbc:aws-wrapper:postgresql://cluster.region.rds.amazonaws.com:5432/mydb";
Connection conn = DriverManager.getConnection(url, props);
```

### IAM Authentication

```java
Properties props = new Properties();
props.setProperty("wrapperPlugins", "failover,iam");
props.setProperty("user", "iamuser");

String url = "jdbc:aws-wrapper:postgresql://cluster.region.rds.amazonaws.com:5432/mydb";
Connection conn = DriverManager.getConnection(url, props);
```

### Secrets Manager

```java
Properties props = new Properties();
props.setProperty("wrapperPlugins", "failover,secretsManager");
props.setProperty("secretId", "arn:aws:secretsmanager:region:account:secret:name");

String url = "jdbc:aws-wrapper:postgresql://cluster.region.rds.amazonaws.com:5432/mydb";
Connection conn = DriverManager.getConnection(url, props);
```

### Read/Write Splitting

```java
Properties props = new Properties();
props.setProperty("wrapperPlugins", "failover,readWriteSplitting");
props.setProperty("user", "username");
props.setProperty("password", "password");

String url = "jdbc:aws-wrapper:postgresql://cluster.region.rds.amazonaws.com:5432/mydb";
Connection conn = DriverManager.getConnection(url, props);

// Reads go to reader instances
ResultSet rs = conn.createStatement().executeQuery("SELECT * FROM users");

// Writes go to writer instance
conn.createStatement().executeUpdate("INSERT INTO users VALUES (...)");
```

## Supported Drivers

- PostgreSQL: `org.postgresql.Driver`
- MySQL: `com.mysql.cj.jdbc.Driver`, `com.mysql.jdbc.Driver`
- MariaDB: `org.mariadb.jdbc.Driver`

## Resources

- [GitHub Repository](https://github.com/aws/aws-advanced-jdbc-wrapper)
- [API Documentation](https://github.com/aws/aws-advanced-jdbc-wrapper/tree/main/docs)
- [Examples](https://github.com/aws/aws-advanced-jdbc-wrapper/tree/main/examples)
