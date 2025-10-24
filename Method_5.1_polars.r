# "Boto3" is an AWS SDK for Python that provides an API for interacting with the Amazon "SageMaker" service.

library(reticulate)

# fsspec is a file system specification that provides a unified Python interface for various storage systems.
# httpfs is a backend implemented in the "fsspec" library, used to handle operations related to the HTTP/HTTPS protocol.
# s3fs is one of its implementations, specifically designed for accessing Amazon S3 buckets.

reticulate::py_install(c("polars", "s3fs", "httpfs", "sagemaker"), pip = TRUE)

pl <- import("polars")
sagemaker <- import("sagemaker")
session <- sagamaker$Session()

# S3 file path
s3_parquet_path <- "s3://your-bucket/path/to/data.parquet"

# ========================= For normal file size ========================= 
# Reading Parquet files (Supporting distributed and partitioned data)
df_s3 <- pl$read_parquet(s3_parquet_path)

# Check the first few lines
print(df_s3$head())


# ========================= For large file size ========================= 
# Using scan_parquet can also be called for lazy loading to improve efficiency
df_lazy <- pl$scan_parquet(s3_parquet_path, storage_options = storage_options)

summary_df <- df_lazy$select(list(pl$col("some_numeric_column")$mean()$alias("avg_col"))) $collect()
print(summary_df)
