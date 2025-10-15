# AWS S3 Data Access with R
This repository demonstrates how to read data from AWS S3 using R, showcasing multiple methods including **_direct programmatic access_** and **_Bash-based download_** scripts.<br>

- Method 1: Pure R (Using Python’s SageMaker via reticulate)
This approach leverages the reticulate package to call Python’s sagemaker utilities from R and stream S3 files directly into R objects.<br>


- Method 2: Bash Download + R Read
This approach first downloads the file locally using AWS CLI or aws.s3 package, then reads the downloaded file using R.<br>

1. Using AWS CLI in Bash
     aws s3 cp s3://your-bucket/data.csv .
2. Then in R:
    df <- read.csv("data.csv")
    print(head(df)) 
