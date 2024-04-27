#!/usr/bin/env bash

cdp() {
  cd "$(~/.local/bin/dir_select)"
}

declare awsprofiles
awsp() {
  if [ -z "$awsprofiles" ]; then
    awsprofiles=$(aws configure list-profiles)
  fi
  export AWS_PROFILE=$(echo "$awsprofiles" | fzf -1 -q "$*")
  echo "switched to profile: $AWS_PROFILE"
}

cognito() {
  printf '%-14s ' "User Pool ID:"
  poolID=$(aws cognito-idp list-user-pools --max-results 50 --output text --query 'UserPools[].Id' | fzf -1)
  if [ -z "$poolID" ]; then
    exit 1
  fi
  echo "$poolID"

  usernames=$(aws cognito-idp list-users --user-pool-id "$poolID" --query "Users[].Username" --output json | jq -r '.[]')
  printf '%-14s ' "Username:"
  username=$(echo "$usernames" | fzf -1 -q "$1")
  if [ -z "$username" ]; then
    return
  fi
  echo "$username"

  availableGroups=$(aws cognito-idp list-groups --user-pool-id "$poolID" --output json --query "Groups[].GroupName" | jq -r '.[]')
  currentGroups=$(aws cognito-idp admin-list-groups-for-user --user-pool-id "$poolID" --username "$username" --output json --query "Groups[].GroupName" | jq -r '.[]')
  groups=$(echo "$availableGroups" | fzf --multi --preview-window="top:50%" --preview-label="Current groups" --preview "echo \"$currentGroups"\")
  if [ -z "$groups" ]; then
    return
  fi
  printf '%-14s ' "Groups:"

  echo

  diff --color=always -u <(echo "$currentGroups" | sort) <(echo "$groups" | sort) | tail -n +4

  echo

  read -r -p "Continue? [y/N] " -n 1
  echo
  if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
    return
  fi

  for g in $groups; do
    if [[ ! " ${currentGroups[*]} " =~ $g ]]; then
      echo "* Adding to $g"
      aws cognito-idp admin-add-user-to-group --user-pool-id "$poolID" --username "$username" --group-name "$g"
    fi
  done

  for g in $currentGroups; do
    if [[ ! " ${groups[*]} " =~ $g ]]; then
      echo "* Removing from $g"
      aws cognito-idp admin-remove-user-from-group --user-pool-id "$poolID" --username "$username" --group-name "$g"
    fi
  done
}

# TODO: make region configurable in AWS scripts

ec2connect() {
  region="eu-central-1"

  instances=$(aws ec2 describe-instances --region $region --query "Reservations[*].Instances[*].{InstanceId:InstanceId,PrivateIP:PrivateIpAddress,Name:Tags[?Key=='Name']|[0].Value,Type:InstanceType}" --filters Name=instance-state-name,Values=running --output text)
  instanceID=$(echo "$instances" | fzf -1 -q "$*" | awk '{print $1}')

  if [ -z "$instanceID" ]; then
    echo "no instance selected"
  fi
  aws ssm start-session --region $region --target "$instanceID"
}

ecsconnect() {
  printf '%-12s ' "cluster:"
  cluster=$(aws ecs list-clusters --query 'clusterArns' | jq -r '.[]' | cut -d '/' -f2 | fzf -1 -q "$1")
  if [ -z "$cluster" ]; then
    echo "no cluster found"
    return
  fi
  echo "$cluster"

  printf '%-12s ' "service:"
  service=$(aws ecs list-services --cluster "$cluster" --query 'serviceArns' | jq -r '.[]' | cut -d '/' -f3 | fzf -1 -q "$2")
  if [ -z "$service" ]; then
    echo "no service found"
    return
  fi
  echo "$service"

  printf '%-12s ' "container:"
  taskDef=$(aws ecs describe-services --services "$service" --cluster "$cluster" | jq -r '.services[].taskDefinition')
  if [ -z "$taskDef" ]; then
    echo "no task definition found"
    return
  fi

  container=$(aws ecs describe-task-definition --task-definition "$taskDef" | jq -r '.taskDefinition.containerDefinitions[] | select(.linuxParameters.initProcessEnabled == true) | .name' | fzf -1 -q "$3")
  if [ -z "$container" ]; then
    echo "no container with SSM enabled found"
    return
  fi
  echo "$container"

  printf '%-12s ' "task:"
  taskID=$(aws ecs list-tasks --cluster "$cluster" --service "$service" --query 'taskArns' | jq -r '.[]' | cut -d'/' -f3 | fzf -1 -q "$4")
  if [ -z "$taskID" ]; then
    echo "no task found"
    return
  fi
  echo "$taskID"

  echo "---"

  echo "connecting to $cluster/$service/$taskID/$container"

  aws ecs execute-command --interactive --command /bin/sh --task "$taskID" --cluster "$cluster" --container "$container"
}

ecr() {
  region="eu-central-1"
  aws ecr get-login-password --region $region |
    docker login --password-stdin --username AWS \
      "$(aws sts get-caller-identity --query Account --output text).dkr.ecr.$region.amazonaws.com"
}
