---
layout: default
title: AWS ODBC Drivers
---

# AWS ODBC Drivers

[← Back to Home](/)

AWS provides ODBC drivers for PostgreSQL and MySQL with AWS-specific features for Amazon Aurora and RDS databases.

## AWS PostgreSQL ODBC Driver

**Latest Version:** [1.0.0](https://github.com/aws/aws-advanced-odbc-wrapper/releases/tag/1.0.0)  
**Repository:** [github.com/aws/aws-advanced-odbc-wrapper](https://github.com/aws/aws-advanced-odbc-wrapper)

### Prerequisites

Before installing the AWS Advanced ODBC Wrapper, you must install:
- UnixODBC (for Mac/Linux)
- An underlying ODBC driver: [psqlODBC PostgreSQL ODBC Driver](https://github.com/postgresql-interfaces/psqlodbc)

### Installation

**Windows:**
1. Download the `.msi` installer from the [releases page](https://github.com/aws/aws-advanced-odbc-wrapper/releases/latest)
2. Execute the installer and follow onscreen instructions
3. Two wrappers will be installed:
   - AWS Advanced ODBC Wrapper Ansi
   - AWS Advanced ODBC Wrapper Unicode

**macOS (Silicon chips only):**
```bash
# Download and extract
wget https://github.com/aws/aws-advanced-odbc-wrapper/releases/download/1.0.0/aws-advanced-odbc-wrapper-1.0.0-macos-arm64.zip
unzip aws-advanced-odbc-wrapper-1.0.0-macos-arm64.zip

# Bypass Gatekeeper
xattr -dr com.apple.quarantine /path/to/the/wrapper/

# Optional: Verify checksums
shasum -a 256 aws-advanced-odbc-wrapper-a.dylib
shasum -a 256 aws-advanced-odbc-wrapper-w.dylib
```

**Linux:**
```bash
# Download and extract
wget https://github.com/aws/aws-advanced-odbc-wrapper/releases/download/1.0.0/aws-advanced-odbc-wrapper-1.0.0-linux-x64.tar.gz
tar -xzf aws-advanced-odbc-wrapper-1.0.0-linux-x64.tar.gz

# Optional: Verify checksums
sha256sum aws-advanced-odbc-wrapper-a.so
sha256sum aws-advanced-odbc-wrapper-w.so
```

### Configuration (Linux/macOS)

Create or modify `odbcinst.ini`:
```ini
[ODBC Drivers]
AWS Advanced ODBC Wrapper Ansi      = Installed
AWS Advanced ODBC Wrapper Unicode   = Installed

[AWS Advanced ODBC Wrapper Ansi]
Driver = /path/to/aws-advanced-odbc-wrapper-a.dylib  # or .so for Linux

[AWS Advanced ODBC Wrapper Unicode]
Driver = /path/to/aws-advanced-odbc-wrapper-w.dylib  # or .so for Linux
```

Create or modify `odbc.ini`:
```ini
[ODBC Data Sources]
aws-odbc-wrapper-a = AWS Advanced ODBC Wrapper Ansi
aws-odbc-wrapper-w = AWS Advanced ODBC Wrapper Unicode

[aws-odbc-wrapper-a]
Driver          = AWS Advanced ODBC Wrapper Ansi
SERVER          = cluster.region.rds.amazonaws.com
DATABASE        = mydb
BASE_DRIVER     = /path/to/psqlodbca.dylib  # or .so for Linux

[aws-odbc-wrapper-w]
Driver          = AWS Advanced ODBC Wrapper Unicode
SERVER          = cluster.region.rds.amazonaws.com
DATABASE        = mydb
BASE_DRIVER     = /path/to/psqlodbcw.dylib  # or .so for Linux
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

- [PostgreSQL ODBC GitHub Repository](https://github.com/aws/aws-advanced-odbc-wrapper)
- [MySQL ODBC GitHub Repository](https://github.com/aws/aws-mysql-odbc)
- [PostgreSQL ODBC Documentation](https://github.com/aws/aws-advanced-odbc-wrapper/tree/main/docs)
- [MySQL ODBC Documentation](https://github.com/aws/aws-mysql-odbc/tree/main/docs)
