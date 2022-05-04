#!/bin/bash
mkfs.ext4 /dev/nvme1n1
mkdir /data
mount -t ext4 /dev/nvme1n1 /data
echo "/dev/nvme1n1	/data	ext4	auto	0	0" >> /etc/fstab