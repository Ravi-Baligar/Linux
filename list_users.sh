#!/bin/bash


#####################################################################
# Author: Ravi Baligar

# Date : 22 may 2025

# This scripts gives the list of user who have access to github repo

#####################################################################


# Github API Url
API_URL="https://api.github.com"

# Username and token
USERNAME= $username
TOKEN= $token


#User and Repository information
REPO_Owner= $1
REPO_NAME= $2


#helper function 
# $0 refers to the script name.
# $# is how many arguments were passed to the function (or script, depending on where it's called).
function helper() {
    expected_arg=2
    if [ $# -ne $expected_arg ]; then
        echo "Usage: $0 <repo_owner> <repo_name>"
        exit 1
    fi
}

#Function to make Github API request
function github_api_get() {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}


# Function to list users with read access to the repository
function list_users_with_read_access() {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display the list of collaborators with read access
    # -z is a string test operator used to check whether a string is empty.
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}




echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
helper
list_users_with_read_access
