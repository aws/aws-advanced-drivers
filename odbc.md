---
layout: default
title: AWS ODBC Drivers
---

# AWS ODBC Drivers

[← Back to Home](/)

AWS provides ODBC drivers for PostgreSQL and MySQL with AWS-specific features for Amazon Aurora and RDS databases.

## AWS PostgreSQL ODBC Driver

**Latest Version:** [1.0.1](https://github.com/aws/aws-pgsql-odbc/releases/tag/1.0.1)  
**Repository:** [github.com/aws/aws-pgsql-odbc](https://github.com/aws/aws-pgsql-odbc)

### Installation

**Windows:**
Download and run the MSI installer from the [releases page](https://github.com/aws/aws-pgsql-odbc/releases/latest).

**macOS:**
```bash
brew install aws-pgsql-odbc
```

**Linux:**
```bash
# Download the appropriate package for your distribution
wget https://github.com/aws/aws-pgsql-odbc/releases/download/1.0.1/aws-pgsql-odbc-1.0.1.tar.gz
tar -xzf aws-pgsql-odbc-1.0.1.tar.gz
cd aws-pgsql-odbc-1.0.1
./configure
make
sudo make install
```

### Connection String

```
DRIVER={Amazon PostgreSQL ODBC Driver};SERVER=cluster.region.rds.amazonaws.com;PORT=5432;DATABASE=mydb;UID=username;PWD=password;enableClusterFailover=true
```

### Key Features

- **Failover Support**: Automatic failover for Aurora PostgreSQL clusters
- **IAM Authentication**: AWS IAM database authentication
- **Enhanced Monitoring**: Connection health tracking
- **SSL/TLS Support**: Secure connections to RDS/Aurora

### Configuration Options

- `enableClusterFailover=true` - Enable Aurora cluster failover
- `failoverTimeoutMs=60000` - Failover timeout in milliseconds
- `enableIAM=true` - Enable IAM authentication
- `sslMode=require` - SSL connection mode

## AWS MySQL ODBC Driver

**Latest Version:** [1.1.0](https://github.com/aws/aws-mysql-odbc/releases/tag/1.1.0)  
**Repository:** [github.com/aws/aws-mysql-odbc](https://github.com/aws/aws-mysql-odbc)

### Installation

**Windows:**
Download and run the MSI installer from the [releases page](https://github.com/aws/aws-mysql-odbc/releases/latest).

**macOS:**
```bash
brew install aws-mysql-odbc
```

**Linux:**
```bash
# Download the appropriate package for your distribution
wget https://github.com/aws/aws-mysql-odbc/releases/download/1.1.0/aws-mysql-odbc-1.1.0.tar.gz
tar -xzf aws-mysql-odbc-1.1.0.tar.gz
cd aws-mysql-odbc-1.1.0
./configure
make
sudo make install
```

### Connection String

```
DRIVER={Amazon MySQL ODBC Driver};SERVER=cluster.region.rds.amazonaws.com;PORT=3306;DATABASE=mydb;USER=username;PASSWORD=password;enableClusterFailover=true
```

### Key Features

- **Failover Support**: Automatic failover for Aurora MySQL clusters
- **IAM Authentication**: AWS IAM database authentication
- **Enhanced Monitoring**: Connection health tracking
- **SSL/TLS Support**: Secure connections to RDS/Aurora

### Configuration Options

- `enableClusterFailover=true` - Enable Aurora cluster failover
- `failoverTimeoutMs=60000` - Failover timeout in milliseconds
- `enableIAM=true` - Enable IAM authentication
- `sslMode=REQUIRED` - SSL connection mode
- `enableIAM=true` - Enable IAM authentication
- `sslMode=require` - SSL connection mode

## Common Configurations

### Basic Failover (PostgreSQL)

```
DRIVER={Amazon PostgreSQL ODBC Driver};
SERVER=cluster.region.rds.amazonaws.com;
PORT=5432;
DATABASE=mydb;
UID=username;
PWD=password;
enableClusterFailover=true;
failoverTimeoutMs=60000
```

### Basic Failover (MySQL)

```
DRIVER={Amazon MySQL ODBC Driver};
SERVER=cluster.region.rds.amazonaws.com;
PORT=3306;
DATABASE=mydb;
USER=username;
PASSWORD=password;
enableClusterFailover=true;
failoverTimeoutMs=60000
```

### IAM Authentication (PostgreSQL)

```
DRIVER={Amazon PostgreSQL ODBC Driver};
SERVER=cluster.region.rds.amazonaws.com;
PORT=5432;
DATABASE=mydb;
UID=iamuser;
enableClusterFailover=true;
enableIAM=true;
region=us-east-1
```

### IAM Authentication (MySQL)

```
DRIVER={Amazon MySQL ODBC Driver};
SERVER=cluster.region.rds.amazonaws.com;
PORT=3306;
DATABASE=mydb;
USER=iamuser;
enableClusterFailover=true;
enableIAM=true;
region=us-east-1
```

## Using with Applications

### Python (pyodbc)

```python
import pyodbc

conn_str = (
    "DRIVER={Amazon PostgreSQL ODBC Driver};"
    "SERVER=cluster.region.rds.amazonaws.com;"
    "PORT=5432;"
    "DATABASE=mydb;"
    "UID=username;"
    "PWD=password;"
    "enableClusterFailover=true"
)

conn = pyodbc.connect(conn_str)
cursor = conn.cursor()
cursor.execute("SELECT 1")
result = cursor.fetchone()
conn.close()
```

### C/C++

```c
#include <sql.h>
#include <sqlext.h>

SQLHENV env;
SQLHDBC dbc;
SQLHSTMT stmt;

SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, &env);
SQLSetEnvAttr(env, SQL_ATTR_ODBC_VERSION, (void*)SQL_OV_ODBC3, 0);
SQLAllocHandle(SQL_HANDLE_DBC, env, &dbc);

SQLCHAR connStr[] = "DRIVER={Amazon PostgreSQL ODBC Driver};"
                    "SERVER=cluster.region.rds.amazonaws.com;"
                    "PORT=5432;DATABASE=mydb;UID=username;PWD=password;"
                    "enableClusterFailover=true";

SQLDriverConnect(dbc, NULL, connStr, SQL_NTS, NULL, 0, NULL, SQL_DRIVER_NOPROMPT);
SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt);

// Execute queries
SQLExecDirect(stmt, (SQLCHAR*)"SELECT 1", SQL_NTS);

// Cleanup
SQLFreeHandle(SQL_HANDLE_STMT, stmt);
SQLDisconnect(dbc);
SQLFreeHandle(SQL_HANDLE_DBC, dbc);
SQLFreeHandle(SQL_HANDLE_ENV, env);
```

### .NET (System.Data.Odbc)

```csharp
using System.Data.Odbc;

string connStr = "DRIVER={Amazon PostgreSQL ODBC Driver};" +
                 "SERVER=cluster.region.rds.amazonaws.com;" +
                 "PORT=5432;DATABASE=mydb;UID=username;PWD=password;" +
                 "enableClusterFailover=true";

using var conn = new OdbcConnection(connStr);
conn.Open();

using var cmd = conn.CreateCommand();
cmd.CommandText = "SELECT 1";
var result = cmd.ExecuteScalar();
```

## DSN Configuration

### Windows

1. Open ODBC Data Source Administrator
2. Click "Add" under System DSN or User DSN
3. Select "Amazon MySQL ODBC Driver" or "Amazon PostgreSQL ODBC Driver"
4. Configure connection parameters
5. Test connection

### Linux/macOS

Edit `/etc/odbc.ini` or `~/.odbc.ini`:

```ini
[MyAuroraDB]
Driver = Amazon PostgreSQL ODBC Driver
Server = cluster.region.rds.amazonaws.com
Port = 5432
Database = mydb
enableClusterFailover = true
failoverTimeoutMs = 60000
```

Connect using DSN:
```
DSN=MyAuroraDB;UID=username;PWD=password
```

## Troubleshooting

### Driver Not Found

Ensure the driver is properly installed and registered:

**Windows:** Check ODBC Data Source Administrator

**Linux/macOS:** Check `/etc/odbcinst.ini`:
```bash
cat /etc/odbcinst.ini
```

### Connection Timeout

Increase `failoverTimeoutMs` or check network connectivity:
```
failoverTimeoutMs=120000
```

### IAM Authentication Issues

Verify:
- AWS credentials are configured
- IAM user has `rds-db:connect` permission
- Database user is configured for IAM authentication

## Resources

- [MySQL ODBC GitHub Repository](https://github.com/aws/aws-mysql-odbc)
- [PostgreSQL ODBC GitHub Repository](https://github.com/aws/aws-pgsql-odbc)
- [MySQL ODBC Documentation](https://github.com/aws/aws-mysql-odbc/tree/main/docs)
- [PostgreSQL ODBC Documentation](https://github.com/aws/aws-pgsql-odbc/tree/main/docs)
