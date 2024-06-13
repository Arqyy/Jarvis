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

# Save machine statistics in MB and current machine hostname to variables
vmstat_mb=$(vmstat --unit M)
hostname=$(hostname -f)

# Retrieve hardware specification variables
memory_free=$(echo "$vmstat_mb" | awk 'NR==3 {print $4}')
cpu_idle=$(echo "$vmstat_mb" | awk 'NR==3 {print $15}')
cpu_kernel=$(echo "$vmstat_mb" | awk 'NR==3 {print $14}')
disk_io=$(vmstat -d | awk 'NR==3 {print $10}')
disk_available=$(df -BM / | awk 'NR==2 {print substr($4, 1, length($4)-1)}')
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

# Subquery to find matching id in host_info table
host_id="(SELECT id FROM host_info WHERE hostname='$hostname')"

# Construct the INSERT statement for host_info table
insert_stmt="INSERT INTO host_info(hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, total_mem, timestamp)
VALUES ('$hostname', '$cpu_number', '$cpu_architecture', '$cpu_model', '$cpu_mhz', '$l2_cache', '$total_mem', '$timestamp');"

# Set up environment variable for psql command
export PGPASSWORD=$psql_password

# Execute the INSERT statement through the psql CLI tool
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"

# Capture exit status of psql command
exit $?
