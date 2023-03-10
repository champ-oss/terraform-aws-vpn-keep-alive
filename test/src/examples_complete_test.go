package test

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/cloudwatchlogs"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"os"
	"strings"
	"testing"
	"time"
)

// TestExamplesComplete tests a typical deployment of this module
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/complete",
		BackendConfig: map[string]interface{}{
			"bucket": os.Getenv("TF_STATE_BUCKET"),
			"key":    os.Getenv("TF_VAR_git"),
		},
		EnvVars: map[string]string{},
		Vars:    map[string]interface{}{},
	}
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	time.Sleep(60 * time.Second) // wait for the lambda to run

	logger.Log(t, "Creating AWS Session")
	sess := getAWSSession()

	cloudwatchLogGroup := terraform.Output(t, terraformOptions, "cloudwatch_log_group")
	region := terraform.Output(t, terraformOptions, "region")

	logStream := GetLogStream(sess, region, cloudwatchLogGroup)
	logger.Log(t, "getting logs from log stream: ", logStream)
	outputLogs := GetLogs(sess, region, cloudwatchLogGroup, logStream)

	logger.Log(t, "checking message in log stream for expected value")
	expectedResponse := "connected successfully"
	foundResponse := false
	for _, message := range outputLogs {
		if strings.Contains(*message.Message, expectedResponse) {
			foundResponse = true
			break
		}
	}
	assert.True(t, foundResponse)
}

// getAWSSession Logs in to AWS and return a session
func getAWSSession() *session.Session {
	fmt.Println("Getting AWS Session")
	sess, err := session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	})
	if err != nil {
		fmt.Println(err)
	}
	return sess
}

func GetLogs(session *session.Session, region string, logGroup string, logStream *string) []*cloudwatchlogs.OutputLogEvent {
	svc := cloudwatchlogs.New(session, aws.NewConfig().WithRegion(region))

	params := &cloudwatchlogs.GetLogEventsInput{
		LogGroupName:  aws.String(logGroup),
		LogStreamName: aws.String(*logStream),
	}
	resp, _ := svc.GetLogEvents(params)

	fmt.Println(resp)
	return resp.Events
}

func GetLogStream(session *session.Session, region string, logGroup string) *string {
	svc := cloudwatchlogs.New(session, aws.NewConfig().WithRegion(region))

	params := &cloudwatchlogs.DescribeLogStreamsInput{
		LogGroupName: aws.String(logGroup),
		Descending:   aws.Bool(true),
		OrderBy:      aws.String("LastEventTime"),
	}

	resp, _ := svc.DescribeLogStreams(params)

	stream := resp.LogStreams[0].LogStreamName

	fmt.Println(resp)
	return stream
}
