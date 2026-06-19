---
name: driver-version-check
description: Check latest GitHub release versions for AWS Advanced Driver wrappers and compare against documented versions. Use when asked to "check versions", "update versions", "are drivers up to date", or for scheduled version monitoring.
tags: [skill, versions, drivers, github, releases]
---

# Driver Version Check

## Overview
Checks the latest GitHub release for each AWS Advanced Driver wrapper and compares it to the version documented in the project's markdown files.

## Usage
Use this skill when:
- Checking if any driver has a new release
- Running scheduled version monitoring (cron jobs)
- Updating the markdown files with new versions
- Comparing documented vs actual latest versions

## Core Concepts

### Tracked Drivers

| Driver | MD File | GitHub Releases URL | Current Documented Version |
|--------|---------|--------------------|-----------------------------|
| JDBC Wrapper | `jdbc.md` | `https://github.com/aws/aws-advanced-jdbc-wrapper/releases/latest` | 4.1.0 |
| Python Wrapper | `python.md` | `https://github.com/aws/aws-advanced-python-wrapper/releases/latest` | 3.0.0 |
| Node.js Wrapper | `nodejs.md` | `https://github.com/aws/aws-advanced-nodejs-wrapper/releases/latest` | 2.1.1 |
| .NET Wrapper | `dotnet.md` | `https://github.com/aws/aws-advanced-dotnet-data-provider-wrapper/releases/latest` | 2.0.0 |
| Go Wrapper | `go.md` | `https://github.com/aws/aws-advanced-go-wrapper/releases/latest` | 2026-05-26 |
| ODBC PostgreSQL Wrapper | `odbc.md` | `https://github.com/aws/aws-advanced-odbc-wrapper/releases/latest` | 1.2.0 |
| MySQL ODBC Driver | `odbc.md` | `https://github.com/aws/aws-mysql-odbc/releases/latest` | 1.2.0 |

### How to Check

For each driver, fetch the GitHub releases latest redirect URL:
```
https://github.com/{org}/{repo}/releases/latest
```
This redirects to the actual tag URL, revealing the latest version.

Alternatively, use the GitHub API:
```
https://api.github.com/repos/{org}/{repo}/releases/latest
```
The `tag_name` field contains the latest version.

### Procedure

1. For each driver in the table above, use `web_fetch` on the GitHub releases/latest URL
2. Extract the version from the redirected URL or page content
3. Compare against the documented version in the table
4. Report any mismatches

### Reporting Format

```
## Driver Version Report

| Driver | Documented | Latest | Status |
|--------|-----------|--------|--------|
| JDBC   | 4.0.1     | 4.0.2  | ⚠️ UPDATE NEEDED |
| Python | 2.1.0     | 2.1.0  | ✅ Current |
...
```

### Updating Versions

When a new version is found, update:
1. The "Latest Version" line in the relevant `.md` file
2. Any version references in code examples (Maven/Gradle/pip/npm coordinates)
3. Any download URLs containing the version number
