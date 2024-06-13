#!/bin/bash

# Assign CLI arguments to variables
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

# Check number of arguments
if [ "$#" -ne 5 ]; then
    echo "Usage: $0 psql_host psql_port db_name psql_user psql_password"
    exit 1
fi

# Save current timestamp in UTC format
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

# Retrieve server CPU and memory usage data
cpu_idle=$(vmstat 1 2 | awk 'NR==3 {print $15}')
cpu_kernel=$(vmstat 1 2 | awk 'NR==3 {print $14}')
memory_free=$(free -m | awk 'NR==2 {print $4}')

# Construct the INSERT statement with a subquery to get host_id by hostname
insert_stmt="INSERT INTO host_usage(timestamp, host_id, cpu_idle, cpu_kernel, memory_free)
VALUES ('$timestamp', (SELECT id FROM host_info WHERE hostname='$hostname'), $cpu_idle, $cpu_kernel, $memory_free);"

# Set up environment variable for psql command
export PGPASSWORD=$psql_password

# Execute the INSERT statement through the psql CLI tool
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"

# Capture exit status of psql command
exit $?
