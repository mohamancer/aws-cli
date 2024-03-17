#todo
#!/bin/bash

# Function to display EC2 instances and their public IPs
display_ec2_info() {
    running_count=0
    stopped_count=0

    echo "EC2 Instances:"
    echo "--------------"

    # Loop through each EC2 instance
    while read -r line; do
        instance_id=$(echo "$line" | awk '{print $1}')
        state=$(echo "$line" | awk '{print $2}')
        public_ip=$(echo "$line" | awk '{print $3}')

        # Count instances based on their state
        if [ "$state" == "running" ]; then
            ((running_count++))
            echo "Instance ID: $instance_id | Public IP: $public_ip (Running)"
        elif [ "$state" == "stopped" ]; then
            ((stopped_count++))
            echo "Instance ID: $instance_id (Stopped)"
        fi
    done <<< "$(aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]' --output text)"

    echo "--------------"
    echo "Total Running Instances: $running_count"
    echo "Total Stopped Instances: $stopped_count"
}

# Main function
main() {
    # Check if AWS CLI is installed
    if ! command -v aws &>/dev/null; then
        echo "AWS CLI is not installed. Please install it and configure AWS credentials."
        exit 1
    fi

    echo "Fetching EC2 instance information..."
    display_ec2_info
}

# Execute the main function
main
