#!/bin/bash

SG_ID="sg-06c49cdb6bad433fc" #replace with your ID
AMI_ID="ami-0220d79f3f480ecf5"

for instance in $@
do
   INSTANCE_ID=$( aws ec2 run-instances \
   --image id $AMI_ID \
   --instance-type t3.micro \
   --security-group-ids $SG_ID \
   --tag-specifications "ResourceType=instance, Tags=[{Key=Name,Value=$instance}]" \
   --query 'Instances[0],InstanceId' \
   --output text )

   if [ $instance == "frontend" ]; then
        Ip=$(
            aws ec2 describe-instances \
            --instance-ids $IMSTANCE_ID \
            --query 'Reservations[].Instances[].PrivateIpAddress' \
            --output text
        )
    else
        IP=$(
            aws ec2 describe-instances \
            --instance-ids $IMSTANCE_ID \
            --query 'Reservations[].Instances[].PublicIpAddress' \
            --output text   
        )
    fi

    echo "IP Addewss: $IP"     
done
