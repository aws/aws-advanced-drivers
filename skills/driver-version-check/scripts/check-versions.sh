#!/bin/bash
# Check latest GitHub release versions for all AWS Advanced Driver wrappers
# Usage: ./check-versions.sh
# Output: Pipe-separated table of driver, documented version, latest version, status

set -eo pipefail

DRIVERS=(
  "JDBC|aws/aws-advanced-jdbc-wrapper|4.2.0"
  "Python|aws/aws-advanced-python-wrapper|3.0.0"
  "Node.js|aws/aws-advanced-nodejs-wrapper|2.1.1"
  ".NET|aws/aws-advanced-dotnet-data-provider-wrapper|2.1.0"
  "Go|aws/aws-advanced-go-wrapper|2026-07-02"
  "ODBC PostgreSQL|aws/aws-advanced-odbc-wrapper|1.2.0"
  "MySQL ODBC|aws/aws-mysql-odbc|1.2.0"
)

echo "Driver|Documented|Latest|Status"
echo "------|----------|------|------"

for entry in "${DRIVERS[@]}"; do
  IFS='|' read -r driver repo doc_version <<< "$entry"

  # Get latest release tag via redirect
  latest=$(curl -sI "https://github.com/${repo}/releases/latest" \
    | grep -i "^location:" \
    | sed 's|.*/tag/||' \
    | tr -d '\r\n' \
    | sed 's/^release-//')

  if [ -z "$latest" ]; then
    latest="ERROR"
    status="❌ Failed to fetch"
  elif [ "$latest" = "$doc_version" ]; then
    status="✅ Current"
  else
    status="⚠️ UPDATE NEEDED"
  fi

  echo "${driver}|${doc_version}|${latest}|${status}"
done
