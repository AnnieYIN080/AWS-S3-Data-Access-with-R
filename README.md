# AWS S3 Data Access with R
This repository demonstrates how to read data from AWS S3 using R, showcasing multiple methods including **_direct programmatic access_** and **_Bash-based download_** scripts.<br>

**Key point:** <br>
Check file size in bash:
`ls -lh large_file.csv` 
or chech folder size:
`du -sh my_data_folder/`<br>

1. Method 1: Pure R (Using Python’s SageMaker via reticulate)
This approach leverages the `reticulate` package to call Python’s sagemaker utilities from R and stream S3 files directly into R objects.<br>


2. Method 2: Bash Download + R Read
This approach first downloads the file locally using AWS CLI or aws.s3 package, then reads the downloaded file using R.<br>

     - Using AWS CLI in Bash<br>
   `aws s3 cp s3://your-bucket/data.csv ./data.csv`
     - Then in R:<br>
          ```
          df <- read.csv("data.csv")
          print(head(df)) 
          ```


For the open resource, the methods below can also be helpful<br>

3. Method 3: Use the aws.s3 package (recommended)

Aws.s3 is a member of the cloudyr suite officially supported by aws. Use AWS API to directly read and write S3. <br>
Ps, not all the environments can set aws credentials by yourself. Please check and confirm before use this method.<br>


4. Method 4: Use the arrow package (Efficient reading and writing of Parquet and CSV)<br>
Arrow supports native S3 protocol reading and is suitable for large-scale distributed data.<br>
```
library(arrow)
ds <- read_csv_arrow("s3://your-bucket/path/to/data.csv")
head(ds)
```

