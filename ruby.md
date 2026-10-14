---
layout: default
title: AWS Advanced Ruby Driver Wrapper
---

# AWS Advanced Ruby Driver Wrapper

[← Back to Home](/)

The AWS Advanced Ruby Driver Wrapper adds AWS-specific features to the community `mysql2` and `pg` Ruby drivers for Aurora and RDS. It integrates with ActiveRecord through drop-in `aws_mysql2` and `aws_postgresql` adapters.

**Latest Version:** [1.0.1](https://github.com/aws/aws-advanced-ruby-driver-wrapper/releases/tag/v1.0.1)  
**Repository:** [github.com/aws/aws-advanced-ruby-driver-wrapper](https://github.com/aws/aws-advanced-ruby-driver-wrapper)

## Installation

Add the wrapper and the underlying driver to your Gemfile:

```ruby
gem 'aws_advanced_ruby_driver_wrapper'

# MySQL
gem 'mysql2'

# PostgreSQL
gem 'pg'
```

```bash
bundle install
```

## Quick Start

Require the entry point for your database:

```ruby
# MySQL
require 'aws_advanced_ruby_driver_wrapper/mysql'

# PostgreSQL
require 'aws_advanced_ruby_driver_wrapper/postgresql'
```

Then change the adapter in `config/database.yml`:

```yaml
production:
  adapter: aws_postgresql   # or aws_mysql2
  host: my-cluster.cluster-xyz.us-east-1.rds.amazonaws.com
  database: mydb
  username: username
  password: password
```

When `wrapper_plugins` is not set, the wrapper loads `failover` and `initial_connection`.

## Key Features

- **Failover Plugin**: Automatic failover for Aurora clusters
- **Global Database Failover Plugin**: Failover awareness for Aurora Global Databases
- **IAM Authentication Plugin**: AWS IAM database authentication
- **Secrets Manager Plugin**: Retrieve credentials from AWS Secrets Manager
- **Custom Endpoint Plugin**: Aurora custom endpoint awareness
- **Blue/Green Deployment Plugin**: Minimizes downtime during Blue/Green switchover
- **Initial Connection Strategy Plugin**: Controls how the initial connection is established
- **KMS Encryption Plugin**: Column-level encryption with AWS KMS data keys

The `iam` and `secrets_manager` plugins are mutually exclusive; configuring both raises a `PluginConflictError`.

## Configuration

Add wrapper properties alongside the ActiveRecord keys. Setting `wrapper_plugins` replaces the default list, so include the defaults you want to keep:

```yaml
production:
  adapter: aws_postgresql
  host: my-cluster.cluster-xyz.us-east-1.rds.amazonaws.com
  database: mydb
  username: iamuser
  wrapper_plugins: failover,initial_connection,iam
  iam_region: us-east-1
  failover_timeout_sec: 300.0
```

## Using the Driver Directly

```ruby
# PostgreSQL (pg)
conn = AwsAdvancedRubyDriverWrapper::WrapperPgConnection.new(
  host: 'my-cluster.cluster-xyz.us-east-1.rds.amazonaws.com',
  dbname: 'mydb',
  user: 'username',
  password: 'password',
  wrapper_plugins: 'failover',
  failover_timeout_sec: 300.0
)

# MySQL (mysql2)
conn = AwsAdvancedRubyDriverWrapper::WrapperMysql2Client.new(
  host: 'my-cluster.cluster-xyz.us-east-1.rds.amazonaws.com',
  database: 'mydb',
  username: 'username',
  password: 'password',
  wrapper_plugins: 'failover',
  failover_timeout_sec: 300.0
)
```

## Resources

- [GitHub Repository](https://github.com/aws/aws-advanced-ruby-driver-wrapper)
- [Documentation](https://aws.github.io/aws-advanced-wrapper-docs/ruby/overview)
- [Plugin Compatibility](https://aws.github.io/aws-advanced-wrapper-docs/ruby/compatibility)
