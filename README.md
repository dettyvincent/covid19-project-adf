Hello,

Welcome to the Covid 19 Reporting Project.
In this project, I am creating an end to end data pipeline for Covid 19 reporting based on the data available from ECDC website.

We have mainly two data sources. ECDC Website and Eurostat Website. Below are the data ingested from each source.

ECDC Website:

Confirmed cases
Mortality
Hospitalization/ ICU Cases
Testing Numbers

Eurostat Website:

Population by age

Data Lake and Data Warehouse to be built with the following data to aid Data Scientists to predict the spread of the virus and mortality.

Confirmed cases
Mortality
Hospitalization/ ICU Cases
Testing Numbers
Country’s population by age group

This is the solution architecture of this project

Resources used:

Azure Subscription
Blob Storage Account
Data Lake Storage Gen2
Azure Data Factory
Azure SQL Database
Azure Databricks Cluster
HD Insight Cluster

Created resource names in the Australia East region:
Data Factory: dv-de-project-adf
Blob storage account for ingestion of raw files: dvcovidreportingsa
Storage account for data lake: dvcovidreportingdl
HD insight cluster: covid-reporting-hdi
Databricks cluster: covid-reporting-databricks-cluster
Azure SQL Database name: covid-db
Azure SQL server name: dvcovid-srv

Added all resources created to the resource group: covid-reporting

Datasets:

raw files: 
ds_population_raw_tsv
ds_population_raw_gz
ds_ecdc_raw_csv_http
ds_ecdc_raw_csv_dl
ds_raw_cases_and_deaths
ds_raw_hospital_admissions
ds_raw_testing

Transformed files:
ds_processed_population
ds_processed_cases_and_deaths
ds_processed_hospital_admissions_daily
ds_processed_hospital_admissions_weekly
ds_processed_testing

Lookup files:
ds_country_lookup
ds_dim_date_lookup
ds_ecdc_file_list

SQL databse:
ds_sql_cases_and_deaths
ds_sql_hospital_admissions_daily
ds_sql_hospital_admissions_weekly
ds_sql_population
ds_sql_testing


linked services:
ls_ablob_covidreportingsa
ls_adls_covidreportingdl
ls_http_opendata_ecdc_europa_eu
ls_hdi_covid_cluster
ls_db_covid_cluster
ls_sql_covid_db

Data flows:

df_transform_cases_deaths
df_transform_hospital_admissions
df_transform_population
df_transform_testing

pipelines:

pl_ingest_ecdc_data
pl_ingest_population_data
pl_process_cases_and_deaths
pl_process_hospital_admissions
pl_process_population
pl_process_testing
pl_sql_cases_and_deaths
pl_sql_hospital_admissions_daily
pl_sql_hospital_admissions_weekly
pl_sql_population
pl_sql_testing
pl_execute_population_pipeline


triggers:
tr_population_data_arrived (event)
tr_ingest_ecdc_data
tr_process_cases_and_deaths
tr_process_hospital_admissions
tr_process_testing
tr_sql_cases_and_deaths
tr_sql_hospital_admissions_daily
tr_sql_hospital_admissions_weekly
tr_sql_testing


Data Ingestion of population data:

In order to copy population data from source to target as the file available, added a validation activity in the pipeline to timeout after 2 minutes and sleep time to 10s. Then added a metadata activity to ensure the file has a column count of 13. The copy activity is done inside the true condition of the if condition activity. Added a delete activity after the copy activity to delete the file from source location after the successful copying to the target. Added a web activity inside the false condition of the if condition activity to send a mail to specified mail in case of failure. This is the population ingestion in ADF.

Data Ingestion of ECDC data:

In this case we are ingesting files from a URL. The source data is stored in this location. As we have a list of files to be loaded, a file list is placed in the storage account with the path for each files/. A look up activity together with for each activity is used to transfer all the files in the single pipeline. These files are ingested in to the raw container in the blob storage account created for data lake.

Data Transformation - Cases and Deaths file:

Below are the components in the transformation of Cases and Deaths file.

Filter out only the data for the continent Europe.
Pivot the data based on the column Indicator and get the count for confirmed cases and deaths.
Do a look up in the dim country table to get the 2 digit and 3 digit country code.
Output the transformed single file in to the processed container.

Data Transformation - Hospital Admissions file:

Do a look up in the dim country table to get the 2 digit, 3 digit country code and population.
Split the data in to daily and weekly based on the value in the column indicator.
The daily data is pivoted to get the count of daily hospital occupancy and ICU occupancy. It is then sorted based on reported date and country. The transformed file is loaded into processed container.
A look up is done on weekly data with din Date table to find the week start and week end date. It is now pivoted based on the indicator to get the weekly count of hospital admissions and ICU admissions.
The output data is loaded to a single file in to the storage container.

Data Transformation - Testing file:

The requirement here is to get the 2 digit and 3 digit country code by looking up in the country table. Also get the week start and week end date by looking up in the dim date table.
The transformation is done using Hive script in the HD insight. This is the script for the transformation of testing data.

Data Transformation - Population file:

Create Azure Service Principal and grant the access. Mount data lake storage in the databricks using the Python script. 
Split the first column to get the age group and the country code in separate columns. Do a lookup in the country table to get 2 digit and 3 digit country code and population. keep the data only for the year 2019 and drop all other columns. Pivot the data to get all the age group as the columns for each country.



