
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# High container volume usage incident for ECS.
---

This incident type refers to a situation where the usage of container volume exceeds the threshold limit, which is typically set at 80%. This can lead to performance issues and potentially cause downtime for the service or application running in the container. It requires immediate attention from the assigned engineer to investigate and resolve the issue.

### Parameters
```shell
export CLUSTER_NAME="PLACEHOLDER"

export LOG_GROUP_NAME="PLACEHOLDER"

export LOG_STREAM_NAME="PLACEHOLDER"

export EBS_VOLUME_ID="PLACEHOLDER"

export INSTANCE_ID="PLACEHOLDER"

export CONTAINER_NAME="PLACEHOLDER"
```

## Debug

### 1. Get the list of instances running in the container.
```shell
aws ecs list-container-instances --cluster ${CLUSTER_NAME}
```

### 2. Get the list of tasks running in the container.
```shell
aws ecs list-tasks --cluster ${CLUSTER_NAME} --container-instance ${INSTANCE_ARN}
```

### 3. Get the container details from the task.
```shell
aws ecs describe-tasks --cluster ${CLUSTER_NAME} --tasks ${TASK_ARN}
```

### 4. Get the container logs.
```shell
aws logs get-log-events --log-group-name ${LOG_GROUP_NAME} --log-stream-name ${LOG_STREAM_NAME} --start-time ${START_TIME} --end-time ${END_TIME}
```

### A sudden spike in user traffic causing an unexpected increase in the container's volume usage.
```shell


#!/bin/bash



# Set AWS region and instance ID

region=${REGION}

instance_id=${INSTANCE_ID}



# Get the container ID

container_id=$(aws ecs list-tasks --cluster ${CLUSTER_NAME} --region $region --container-name ${CONTAINER_NAME} --query 'taskArns[0]' --output text)



# Get the current volume usage

volume_usage=$(aws ecs describe-tasks --cluster ${CLUSTER_NAME} --region $region --tasks $container_id --query 'tasks[0].containers[0].filesystemUsage' --output text)



# Get the maximum volume capacity

volume_capacity=$(aws ecs describe-tasks --cluster ${CLUSTER_NAME} --region $region --tasks $container_id --query 'tasks[0].containers[0].filesystems[0].size' --output text)



# Calculate the percentage of volume usage

volume_percentage=$(( volume_usage * 100 / volume_capacity ))



# Check if the volume usage is above the threshold limit

if [ $volume_percentage -gt 80 ]; then

  echo "The container's volume usage is higher than the threshold limit."

  # Add logic to handle the incident here, such as scaling up the container or investigating the root cause

else

  echo "The container's volume usage is normal."

fi


```

## Repair

### Increase the storage capacity of the container volume to accommodate the growing data.
```shell


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


```