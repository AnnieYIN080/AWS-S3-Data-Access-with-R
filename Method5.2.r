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

# DuckDB natively supports reading Parquet, CSV, etc.

# Create a DuckDB table from R data frame
# Create an R data frame for transfer
data_r = data.frame(
  A = 1:1000000,
  B = rnorm(1000000),
  C = sample(c("X", "Y", "Z"), 1000000, replace = TRUE)
)

tic("DuckDB Data Frame Load")
dbWriteTable(con, "my_table", data_r)
toc()

# Execute SQL query
tic("DuckDB SQL Query")
result_db = dbGetQuery(con, "
  SELECT 
    C, 
    COUNT(*) AS count, 
    AVG(B) AS mean_B, 
    SUM(A) AS sum_A 
  FROM my_table
  GROUP BY C
  ORDER BY C;
")
toc()

print("DuckDB Query Result:")
print(result_db)

#  DuckDB querying Parquet files directly
# result_parquet_db = dbGetQuery(con, "SELECT COUNT(*) FROM read_parquet('data.parquet');")

# Disconnect
dbDisconnect(con, shutdown = TRUE)

