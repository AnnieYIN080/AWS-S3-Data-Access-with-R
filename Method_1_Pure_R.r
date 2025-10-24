# Install required packages
install.packages(c('readr', 'reticulate'))

library(readr)
library(reticulate)

# Install sagemaker Python package if not already present
py_install('sagemaker')

# Import sagemaker and create a session
sagemaker <- import('sagemaker')
session <- sagemaker$Session()

# Specify your S3 path
path <- "s3://your-bucket/data.csv"

# Read CSV directly from S3 using the S3Downloader
df <- read_csv(file = sagemaker$s3$S3Downloader$read_file(path, sagemaker_session = session),
               show_col_types = FALSE, na = '')
print(head(df))
