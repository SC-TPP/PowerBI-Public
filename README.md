# PowerBI Reusable Code (Public)
Resources for use with PowerBI. This repo contains :
  * Dax measures
  * M query functions
  * Generic m query code snippets
  * Custom connectors to unsupported data sources

Some of the code in this repo is altered or copied from articles online. Where possible sources have been included.

## DAX Measures
  ### [Latest Known Values Measure](https://github.com/SC-TPP/PowerBI-Public/blob/master/Dax%20Measures/Latest%20Known%20Values%20DAX%20Measure.dax)
  >This measure will allow charting of the last known values over time as opposed to only charting values that match the date.

  >Source : Reddit user u/Aklur created this code and his explanation of how it works can be found at https://www.reddit.com/r/PowerBI/comments/gixdk9/need_urgent_help_with_a_dax_measure/

## Calculated Columns
  ### [SharePoint Daylight Savings Date Column Fix](https://github.com/SC-TPP/PowerBI-Public/blob/master/Calculated%20Columns/SharePoint%20Daylight%20Savings%20Fix.m)
  >Sharepoint Data sources have an issue where they do not account for daylight savings. Dates before clock change will be correct but after will be the previous date but 23:00. This code provides a fix for this in M code.
  ### [Indicator Status Index](https://github.com/SC-TPP/PowerBI-Public/blob/master/Calculated%20Columns/Indicator%20Status%20Index.dax)
  >This provides an example of how to make an status index column in dax for use with KPI visuals etc.
  ### [Convert Arc Epoch DateTime](https://github.com/SC-TPP/PowerBI-Public/blob/master/Calculated%20Columns/Convert%20Arc%20DateTime.m)
  >Arc Data sources will provide dates in Epoch format. This m code will convert this to a datetime format the PowerBI can use correctly.
  ### [Convert HTML Rich Text](https://github.com/SC-TPP/PowerBI-Public/blob/master/Calculated%20Columns/Convert%20HTML.m)
  >Code that can be pasted into the add column dialogue to convert HTML rich text and special characters to plain text.

  >Source : based around the content of Dhruvin Shah's youtube video found at https://www.youtube.com/watch?v=4UDynnPQpG4

## Custom Functions
Function varients of code found in other sections. To use these code snippets create a blank query and paste the full code in. Retitle the query and use the new title of the query to call the function from other queries.

  ### [Convert Arc Epoch Dateformat](https://github.com/SC-TPP/PowerBI-Public/blob/master/Helper%20Functions/Convert%20Arc%20Epoch%20DateFormat%20Function.m)
  >Function that will convert the epoch date format from Arc datasources when called with the correct parameters.
  ### [Convert HTML Text Column](https://github.com/SC-TPP/PowerBI-Public/blob/master/Helper%20Functions/Convert%20HTML%20Text%20Column.m)
  >Function that converts html rich text in a column to plain text. Converts special characters as well as removing HTML tags.

  >Source : based around the content of Dhruvin Shah's youtube video found at https://www.youtube.com/watch?v=4UDynnPQpG4
  ### [Dynamically Expand Records](https://github.com/SC-TPP/PowerBI-Public/blob/master/Helper%20Functions/Dynamically%20Expand%20Records%20-%20Function.m)
  >Function that expands all columns for all records in a column of records. Protects against column changes in records.

  >Source : adapted from Parker Steven's blog at https://bielite.com/blog/dynamically-expand-all-columns/ into a function
  ### [Fix SharePoint Date Column](https://github.com/SC-TPP/PowerBI-Public/blob/master/Helper%20Functions/Fix%20SP%20DateColumn%20Function.m)
  >Function that corrects errors caused by sharepoint date only columns and daylight savings.
  ### [Get SharePoint Version History](https://github.com/SC-TPP/PowerBI-Public/blob/master/Helper%20Functions/Get%20SP%20Version%20History%20Function.m)
  >Function that retrieves version history from SharePoint for a column of item ids.
  ### [Validate Email Addresses](https://github.com/SC-TPP/PowerBI-Public/blob/master/Helper%20Functions/Validate%20Emails.m)
  >Function that returns email validation data fo a column of emails using the api at https://github.com/CodeKJ/DISIFY. This API does not have a 100% success rate. It attempts to validate the format of the email address only. Some bizarre email addresses may return false results.
  ### [Convert Pentana Mixed Period Text Date to Date](https://github.com/SC-TPP/PowerBI-Public/blob/master/Helper%20Functions/Convert%20Pentana%20Mixed%20Period%20Text%20Date%20to%20Date.m)
  > This function will work on columns with dates in the following formats (the formats output in the summary part of the timeperiod record returned in the get request for PI data from the Pentana API)
  >MONTH YEAR e.g November 2020
  >STARTYEAR/ABREVIATEDENDYEAR e.g 2019/20
  >QUARTERNUMBER STARTYEAR/ABREVIATEDENDYEAR e.g Q1 2019/20
  >The split year start is designated as the 1st of April

## Custom Connectors
Custom Connectors for unsupported data sources. To use these data connectors follow the steps below for each connector.

    1. Download .mez file
    4. Move to My Documents\Microsoft Power BI Desktop\Custom Connectors - If this directory doesnt exist please create it.
    5. The data can now be accessed using the Get Data menu in PowerBI

**!!! Some of these connectors potentially expose client secret information if traffic is monitored using fiddler !!!**

  ### [Pentana - Performance Indicator Data](https://github.com/SC-TPP/PowerBI-Public/blob/master/Custom%20Connectors/Pentana%20-%20Indicators)
  >Retrieves a table of performance data for each indicator selected. Notes are not currently available from the Pentana API neither are variances for each period.

  >Within the .m file contained in the .mez the url variables below will need to be adjusted to reference your particular organisation's url
  > 1. token_uri = "https://YOURORGANISATION.pentanarpm.uk/cpmweb/oauth/token";
  > 2. pis_list_uri = "https://YOURORGANISATION.pentanarpm.uk/cpmweb/api/pis";