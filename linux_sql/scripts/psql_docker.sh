#!/bin/bash

# Capture CLI arguments
cmd=$1
db_username=$2
db_password=$3

# Function to check if container exists and is running
container_exists_and_running() {
    docker inspect -f '{{.State.Running}}' jrvs-psql 2>/dev/null
}

# Check Docker service status and start if not running
sudo systemctl is-active --quiet docker || sudo systemctl start docker

# Check container status
docker inspect jrvs-psql >/dev/null 2>&1
container_status=$?

# Use switch case to handle create|stop|start options
case $cmd in
    create)
        # Check if the container is already created
        if [ $container_status -eq 0 ]; then
            echo 'Error: PostgreSQL container "jrvs-psql" is already created.'
            exit 1
        fi

        # Check number of CLI arguments
        if [ $# -ne 3 ]; then
            echo 'Error: "create" command requires username and password.'
            exit 1
        fi

        # Check if username and password are provided
        if [ -z "$db_username" ] || [ -z "$db_password" ]; then
            echo 'Error: Username and password must be provided for container creation.'
            exit 1
        fi

        # Create PostgreSQL container
        echo "Creating PostgreSQL container 'jrvs-psql'..."
        docker volume create pgdata >/dev/null 2>&1
        docker run -d --name jrvs-psql \
            -e POSTGRES_USER=$db_username \
            -e POSTGRES_PASSWORD=$db_password \
            -p 5432:5432 \
            postgres:latest >/dev/null 2>&1
        echo "PostgreSQL container 'jrvs-psql' created successfully."
        ;;

    start)
        # Check if container has been created
        if [ $container_status -ne 0 ]; then
            echo 'Error: PostgreSQL container "jrvs-psql" is not created.'
            exit 1
        fi

        # Check if container is already running
        if container_exists_and_running; then
            echo 'Error: PostgreSQL container "jrvs-psql" is already running.'
            exit 1
        fi

        # Start the container
        docker container start jrvs-psql >/dev/null 2>&1
        echo "PostgreSQL container 'jrvs-psql' started."
        ;;

    stop)
        # Check if container has been created
        if [ $container_status -ne 0 ]; then
            echo 'Error: PostgreSQL container "jrvs-psql" is not created.'
            exit 1
        fi

        # Check if container is running
        if ! container_exists_and_running; then
            echo 'Error: PostgreSQL container "jrvs-psql" is not running.'
            exit 1
        fi

        # Stop the container
        docker container stop jrvs-psql >/dev/null 2>&1
        echo "PostgreSQL container 'jrvs-psql' stopped."
        ;;

    *)
        echo 'Error: Invalid command.'
        echo 'Usage: ./psql_docker.sh {create <db_username> <db_password> | start | stop}'
        exit 1
        ;;
esac

exit 0

