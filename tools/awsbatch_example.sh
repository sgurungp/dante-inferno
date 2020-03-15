#!/bin/bash
#=====
# Example to show use of AWS Translate from the CLI
# Not runnable as-is, so review and edit for your own use appropriately

JOBNAME="test02" # Name of batch job
LOCALSRC="txt" # Name of local folder holding source files prior to uploading to input bucket.

# You need a bucket to hold source and output text, and a role that Translate can use to get to them.
# The role needs GetObject/PutObject and ListBucket
BUCKET="s3://net.alwaysbelearning"
ROLEARN="arn:aws:iam::123456789012:role/service-role/AmazonTranslateServiceRole-ForBatchTranslation"

# Make the bucket
echo "Creating bucket ${BUCKET}"
aws s3 mb ${BUCKET}

INPATH="${BUCKET}/input"
OUTPATH="${BUCKET}/output"

# Load up the input bucket.  Files can either be UTF-8 (text/plain) or HTML (text/html).
# Assume text files with .txt extension here.
echo "Uploading files from ${LOCALSRC} folder to ${INPATH}"
aws s3 cp ${LOCALSRC} ${INPATH} --recursive --include "canto*.txt" --exclude "*.md"

# Kick off the job
echo "Submitting batch request ${JOBNAME}"
aws translate start-text-translation-job --job-name ${JOBNAME} \
    --source-language-code en \
    --target-language-codes it  \
    --input-data-config S3Uri=${INPATH}/,ContentType=text/plain \
    --output-data-config S3Uri=${OUTPATH}/ \
    --data-access-role-arn ${ROLEARN}
