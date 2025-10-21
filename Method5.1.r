# 1. Install rpolars
# install.packages("rpolars")

library(rpolars)
library(tictoc) # For timing operations

# --- 1. Polars Data Processing ---

# Create a Polars DataFrame
tic("Polars DataFrame Creation")
df_pl = pl$DataFrame(
  A = 1:1000000,
  B = rnorm(1000000),
  C = sample(c("X", "Y", "Z"), 1000000, replace = TRUE)
)
toc()

print("Polars DataFrame Head:")
print(df_pl |> head())

# Execute expression query
tic("Polars Expression Query")
result_pl = df_pl |>
  # Polars uses expression syntax
  pl$group_by("C") |> 
  pl$agg(
    count = pl$n(),
    mean_B = pl$col("B") |> pl$mean(),
    sum_A = pl$col("A") |> pl$sum()
  ) |>
  # Sort and collect the result
  pl$sort("C") |>
  pl$collect() 
toc()

print("Polars Query Result:")
print(result_pl)

# Polars read Parquet - Zero-copy read is extremely fast
# df_pl_parquet = pl$read_parquet("data.parquet")
