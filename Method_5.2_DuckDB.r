# The `duckdb` package enables you to directly execute high-performance SQL queries in R sessions, especially for large Parquet or CSV files.

# 1. Install duckdb

# install.packages("duckdb")
# install.packages("DBI") # DBI interface is required

library(duckdb)
library(DBI)
library(tictoc)

# --- 2. DuckDB SQL Processing ---
# Connect to DuckDB database - in-memory is default
con = dbConnect(duckdb())
dbExecute(con, "INSTALL httpfs;")
dbExecute(con, "LOAD httpfs;")
dbExecute(con, "SET s3_region='ap-southeast-1';")
dbExecute(con, "SET s3_access_key_id='YOUR_ACCESS_KEY';")
dbExecute(con, "SET s3_secret_access_key='YOUR_SECRET_KEY';")
```
con = duckdb.connect() 
con.execute("call load_aws_credentials()")
```

# DuckDB natively supports reading Parquet, CSV, etc.
# Execute SQL query

tic("DuckDB SQL Query")

query <- "
  SELECT *
  FROM read_parquet('s3://your-bucket/path/to/data.parquet')
  LIMIT 10;
"

result <- dbGetQuery(con, query)
toc()

print(result)


'''
# The same with the codes below
result = dbGetQuery(con, "
  SELECT 
    C, 
    COUNT(*) AS count, 
    AVG(B) AS mean_B, 
    SUM(A) AS sum_A 
  FROM read_parquet('s3://your-bucket/path/to/data.parquet')
  GROUP BY C
  ORDER BY C;
")
'''

#  DuckDB querying Parquet files directly
# result_parquet_db = dbGetQuery(con, "SELECT COUNT(*) FROM read_parquet('data.parquet');")

# Disconnect
dbDisconnect(con, shutdown = TRUE)
# con.close
