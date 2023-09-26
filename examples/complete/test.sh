set -e

echo -e "\nwaiting for the lambda function to run..."
sleep 60

echo -e "\nchecking lambda logs"
aws logs tail $CLOUDWATCH_LOG_GROUP | grep -i "connected successfully"