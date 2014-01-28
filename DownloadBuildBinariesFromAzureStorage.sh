#!/bin/bash

# Store the original IFS (Internal Field Separator)
originalIFS=$IFS

if [ $# -ne 4 ]
then
    echo "Usage: $0 <storageAccountName> <storageAccountKey> <containerName> <destinationPath>"
    exit 2
fi

storageAccountName=$1
storageAccountKey=$2
containerName=$3
destination=$4

# Change the IFS to newline character (\n) so that each output line is store into the array blobList.
IFS=$'\n'

# List all the blobs in the container and get the name of the blobs into an array
blobNames=(`azure storage blob list --account-name $storageAccountName --account-key $storageAccountKey --container $containerName --json | grep '"name":' | awk -F': ' '{print $2}' | awk -F',' '{print $1}' | awk -F'"' '{print $2}'`)

# Restore the original TFS
IFS=$originalIFS

# Download each blob into the destination path. This will replace any files / folders with the same name already present in the destination path
for blob in "${blobNames[@]}"
do
    azure storage blob download --account-name $storageAccountName --account-key $storageAccountKey --container $containerName --blob "$blob" --destination "$destination" --quiet
done
