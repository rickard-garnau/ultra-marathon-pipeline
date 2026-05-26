# Databricks notebook source
# /// script
# [tool.databricks.environment]
# environment_version = "2"
# ///
# MAGIC %md
# MAGIC # EDA on ultra-marathon running

# COMMAND ----------

df = spark.read.csv("/Volumes/marathos/default/raw/TWO_CENTURIES_OF_UM_RACES.csv", header=True, inferSchema=True)

# COMMAND ----------

# MAGIC %md
# MAGIC #### Number of rows

# COMMAND ----------

df.count()

# COMMAND ----------

# MAGIC %md
# MAGIC #### Number of columns

# COMMAND ----------

len(df.columns)

# COMMAND ----------

# MAGIC %md
# MAGIC #### Check schema

# COMMAND ----------

df.printSchema()

# COMMAND ----------

# MAGIC %md
# MAGIC #### Descriptive summary

# COMMAND ----------

df.describe()

# COMMAND ----------

# MAGIC %md
# MAGIC #### Null count per column

# COMMAND ----------

from pyspark.sql import functions as F

df.select([
    F.sum(F.col(c).isNull().cast("int")).alias(c)
    for c in df.columns
]).display()

# COMMAND ----------

# MAGIC %md
# MAGIC #### Number of unique events

# COMMAND ----------

df.select(F.col("Event name")).distinct().count()

# COMMAND ----------

# MAGIC %md
# MAGIC #### Age distrubution of runners

# COMMAND ----------

df.groupBy(F.col("Athlete year of birth")).count().orderBy("Athlete year of birth").display()

# COMMAND ----------

# MAGIC %md
# MAGIC #### Countries with most participants

# COMMAND ----------

df.groupBy(F.col("Athlete country")).count().orderBy("count", ascending=False).show()

# COMMAND ----------

# MAGIC %md
# MAGIC #### Participants with no avg speed registred
# MAGIC

# COMMAND ----------

from pyspark.sql.functions import col
df.filter(col("Athlete average speed").try_cast("double") <= 0).display()

# COMMAND ----------

# MAGIC %md
# MAGIC #### Total duplicates in dataset

# COMMAND ----------

total = df.count()
unique = df.dropDuplicates().count()

print(f"Total: {total}")
print(f"Unique rows: {unique}")
print(f"Duplicates: {total - unique}")

# COMMAND ----------

# MAGIC %md
# MAGIC #### 

# COMMAND ----------

# MAGIC %md
# MAGIC #### Athletes with several race entries

# COMMAND ----------

df.groupBy("Athlete Id").count().filter(F.col("count") > 1).show()

# COMMAND ----------

# MAGIC %md
# MAGIC #### Nr of unique countries

# COMMAND ----------

df.select(F.col("Athlete country")).distinct().count()


# COMMAND ----------

# MAGIC %md
# MAGIC #### Nr of unique clubs

# COMMAND ----------

df.select(F.col("Athlete club")).distinct().count()
