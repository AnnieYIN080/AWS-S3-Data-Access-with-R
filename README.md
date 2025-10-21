# AWS S3 Data Access with R
This repository demonstrates how to read data from AWS S3 using R, showcasing multiple methods including **_direct programmatic access_** and **_Bash-based download_** scripts.<br>

**Key point:** <br>
Check file size in bash：`ls -lh large_file.csv` <br>
Check folder "disk usage" size: `du -sh my_data_folder/`<br>
Check system "disk free" space `df -h ./`<br>

1. Method 1: (small file)<br>
**Pure R (Using Python’s SageMaker via reticulate)** <br>
This approach leverages the `reticulate` package to call Python’s sagemaker utilities from R and stream S3 files directly into R objects.<br>


2. Using Bash <br>
**2.1 Method 2.1: (small file)<br>**
**Bash Download + R Read** <br>
This approach first downloads the file locally using AWS CLI, then reads the downloaded file using R.<br>

     - Using AWS CLI in Bash<br>
   `aws s3 cp s3://your-bucket/data.csv ./data.csv` <br>
     - Then in R:<br>
          ```
          df <- read.csv("data.csv")
          print(head(df)) 
          ```
          
     <t>**2.2 Method 2.2: (large file)<br>**
     <t>**Bash Download + R Read** <br>
     This approach first downloads the head and rows of file locally using AWS CLI, then reads the downloaded chunked file using R to review the contents.<br>

     - Using AWS CLI in Bash<br>
          s3 will download the CSV file, but do not write it to the local file. Instead, output its content through a pipe (after|) to the standard output of the command-line process. <br>
        `aws s3 cp s3://your-bucket/super_large_dataset.csv -|head -n 1000 > sample_data_1k.csv`<br>
     
     - Then in R:<br>
       ```
       df <- read.csv("sample_data_1k.csv")
       print(head(df))
       ```
               
     <br> after reviewing the file, duckdb is recommended to filter columns you need and then save the filtered file into s3 bucket.<br>


3. Method 3: (RAM limit) <br>
**Use the aws.s3 package (recommended)** <br>

Aws.s3 is a member of the cloudyr suite officially supported by aws. Use AWS API to directly read and write S3. <br>
Ps, not all the environments can set aws credentials by yourself. Please check and confirm before use this method.<br>


4. Method 4: (RAM limit) <br>
**Use the arrow package (Efficient reading and writing of Parquet and CSV)<br>**
Arrow supports native S3 protocol reading and is suitable for large-scale distributed data.<br>
```
library(arrow)
ds <- read_csv_arrow("s3://your-bucket/path/to/data.csv")
head(ds)
```

5. Exploration for Out-of-Core tools <br>
**5.1 For polars in R `rpolars`(Efficient reading and writing of Parquet and CSV) <br>**
**5.2 For duckdb in R `duckdb`(Efficient reading and writing of Parquet and CSV)<br>**
