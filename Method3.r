library(aws.s3)

# Set Credentials (make sure you can set your own environment)
Sys.setenv("AWS_ACCESS_KEY_ID" = "your-key",
           "AWS_SECRET_ACCESS_KEY" = "your-secret",
           "AWS_DEFAULT_REGION" = "ap-southeast-1")

# Read files directly from S3 (no need to land)
obj <- get_object('your-file.csv', bucket = 'your-bucket')
df <- read.csv(text = rawToChar(obj))
head(df)
