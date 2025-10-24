# install.packages("aws.s3")

library(aws.s3)

# Set Credentials (make sure you can set your own environment)
Sys.setenv("AWS_ACCESS_KEY_ID" = "your-key",
           "AWS_SECRET_ACCESS_KEY" = "your-secret",
           "AWS_DEFAULT_REGION" = "ap-southeast-1")

# Read files directly from S3 (no need to land)
obj <- get_object('your-file.csv', bucket = 'your-bucket')

# Convert the original binary content to characters
obj_text <- rawToChar(obj)
df <- read.csv(text = obj_text)

# View the first few lines of the data
head(df)

# Directly use s3read_using to read files to the specified function (read.csv or readr::read_csv, etc.)
df2 <- s3read_using(FUN = read.csv,
                   object = "path/to/file.csv",
                   bucket = "your-bucket")

head(df2)


# Write the data frame to S3 (in CSV format)
s3write_using(df2,
              FUN = write.csv,
              object = "path/to/uploaded_data.csv",
              bucket = "your-bucket",
              row.names = FALSE)

