# AWS S3 Data Access with R  
#### Efficient Cloud Data Ingestion Using Arrow, DuckDB, Polars, and aws.s3

This repository provides a unified framework for accessing and processing **AWS S3 data directly in R**, combining both R‑native and hybrid Python integrations.  
It demonstrates multiple strategies for handling files from S3 — from small inspection tasks to large‑scale analytical workloads — using high‑performance engines such as **Apache Arrow**, **DuckDB**, and **Polars**.



## Overview

| Method | Category | Suitable For | Key Features |
|---------|-----------|---------------|---------------|
| 1 | **Pure R (via Reticulate + SageMaker)** | Small to medium CSVs | Access SageMaker‑managed S3 data using Python APIs directly in R |
| 2 | **AWS CLI + R Read (Bash)** | Quick file checks | Lightweight approach for manual or scheduled ingestion |
| 3 | **aws.s3 Package** | Medium to large datasets | Official cloudyr API with native AWS integration |
| 4 | **Apache Arrow** | Large‑scale distributed data | Zero‑copy access with in‑memory columnar structure |
| 5 | **Out‑of‑Core Engines (Polars & DuckDB)** | Analytical pipelines | Multi‑threaded processing & SQL engine integration on S3 sources |




## Pre‑Check Utilities

Before retrieving or analyzing S3 data, verify infrastructure readiness:

- **File size:** `ls -lh large_file.csv`  
- **Folder usage:** `du -sh my_data_folder/`  
- **Free disk space:** `df -h ./`  
- **Network I/O latency:** use `aws s3 ls s3://your-bucket/` to test connection  




## Method 1 — Pure R + SageMaker (via Reticulate)
Use R’s `reticulate` to call Python SageMaker APIs that directly stream data from S3.<br>

**Best for:** lightweight CSVs where SageMaker or similar environments already manage credentials.




## Method 2 — AWS CLI + R (Bash Automation)

### 2.1 Small Files — Direct Download

This approach first downloads the file locally using AWS CLI, then reads the downloaded file using R.<br>
- Using AWS CLI in Bash<br>

`aws s3 cp s3://your-bucket/data.csv ./data.csv` <br>

- Then in R:<br>
```
df <- read.csv("data.csv")
print(head(df)) 
```
          

### 2.2 Large Files — Partial Stream

Stream only a preview subset without downloading full file:<br>

- Using AWS CLI in Bash<br>

s3 will download the CSV file, but do not write it to the local file. Instead, output its content through a pipe (after|) to the standard output of the command-line process. <br>

`aws s3 cp s3://your-bucket/super_large_dataset.csv -|head -n 1000 > sample_data_1k.csv`<br>
     
- Then in R:<br>
```
df <- read.csv("sample_data_1k.csv")
print(head(df))
```

**Tip:** For further processing, use **DuckDB** to [filter, aggregate or convert file format to parquet](https://github.com/AnnieYIN080/High-Performance-R-Data-Pipeline-Framework) for the whole file `super_large_dataset.csv` and then re‑upload to S3.<br>



## Method 3 — Using `aws.s3` R Package (Recommended)

Official package from the **cloudyr suite** supporting direct S3 object I/O.

Aws.s3 is a member of the cloudyr suite officially supported by aws. Use AWS API to directly read and write S3. <br>
Ps, not all the environments can set aws credentials by yourself. Please check and confirm before use this method.<br>


## Method 4 — Apache Arrow (Parquet / CSV on S3)

`arrow` provides **native S3 data reading** for large distributed data files.  <br>
Internally relies on Apache Arrow’s zero‑copy columnar format, enabling out‑of‑core performance.<br>

```
library(arrow)
ds <- read_csv_arrow("s3://your-bucket/path/to/data.csv")
head(ds)
```

Ideal for distributed or partitioned datasets, with built-in catalog discovery.



## Method 5 — Out‑of‑Core Backends (Polars & DuckDB)

This repository’s highlight section demonstrates two modern compute engines for scalable data analysis within R.  
These engines extend beyond in‑memory limits and provide native compatibility with S3 storage.


### 5.1 Polars in R (via Reticulate)

This section demonstrates a complete **R ↔ Python Polars integration** using `reticulate`, with built‑in support for **AWS S3 cloud data access**.  


It benchmarks reading CSV and Parquet files through high‑speed Rust‑based Polars functions and shows fallback handling for non‑configured S3 sessions.




### 5.2 DuckDB for S3


**Purpose:** Enable serverless SQL querying of S3‑hosted Parquet and CSV data using DuckDB’s extension.

**Key Highlights**

- **Built‑in S3 Support:** Connects securely via AWS credentials to read remote files without downloads. 
- **High‑Speed Query Engine:** Vectorized execution directly reads compressed Parquet columns.  
- **All‑in‑R:** Execute SQL queries, aggregations, and joins from R with no external database setup.  
- **Simple Output Control:** Write results to local storage or push back to S3 as CSV/Parquet.  


