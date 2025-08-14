#!/bin/bash
echo "Cleaning up AWS resources..."
aws autoscaling delete-auto-scaling-group --auto-scaling-group-name my-asg --force-delete
aws autoscaling delete-launch-configuration --launch-configuration-name my-launch-config
aws elbv2 delete-load-balancer --load-balancer-arn my-load-balancer-arn
aws elbv2 delete-target-group --target-group-arn my-target-group-arn
echo "Cleanup complete."
