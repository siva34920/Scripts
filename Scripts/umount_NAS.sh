#!/bin/bash
# Check if a mount point is available on the server and remove it using Ansible

# Validate argument count
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <mount_point>"
  echo "Example: $0 /mnt/storage"
  exit 1
fi

mount_point="$1"

# Verify the mount point is currently mounted
if mountpoint -q "$mount_point"; then
  echo "Mount point $mount_point is active. Executing playbook to remove entry and unmount..."
  ansible-playbook -i inv /etc/ansible/remove_mount.yml \
    --extra-vars "mount_point=$mount_point"
else
  echo "No mount point $mount_point found on this server."
  exit 0
fi