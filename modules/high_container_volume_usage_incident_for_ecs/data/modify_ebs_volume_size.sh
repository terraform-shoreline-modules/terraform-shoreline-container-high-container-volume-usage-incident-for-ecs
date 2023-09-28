

#!/bin/bash



# Set AWS region and EBS volume ID

region="${AWS_REGION}"

volume_id="${EBS_VOLUME_ID}"



# Get the current size of the EBS volume

current_size=$(aws ec2 describe-volumes --region $region --volume-ids $volume_id | jq -r '.Volumes[0].Size')



# Calculate the new size (increase by 10 GB)

new_size=$((current_size + 10))



# Modify the EBS volume size

aws ec2 modify-volume --region $region --volume-id $volume_id --size $new_size