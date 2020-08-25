# PowerBI Code Snippets (Public)
Code snippets and other useful resources for PowerBI.

## DAX Measures
  ### [Latest Known Values Measure](https://github.com/SC-TPP/PowerBI-Public/blob/master/Dax%20Measures/Latest%20Known%20Values%20DAX%20Measure.dax)
  This measure will allow charting of the last known values over time as opposed to only charting values that match the date.

## Calculated Columns
  ### [SharePoint Daylight Savings Date Column Fix](https://github.com/SC-TPP/PowerBI-Public/blob/master/Calculated%20Columns/SharePoint%20Daylight%20Savings%20Fix.m)
  Sharepoint Data sources have an issue where they do not account for daylight savings. Dates before clock change will be correct but after will be the previous date but 23:00. This code provides a fix for this in M code.
  ### [Indicator Status Index](https://github.com/SC-TPP/PowerBI-Public/blob/master/Calculated%20Columns/Indicator%20Status%20Index.dax)
  This provides an example of how to make an status index column in dax for use with KPI visuals etc.
  ### [Convert Arc Epoch DateTime](https://github.com/SC-TPP/PowerBI-Public/blob/master/Calculated%20Columns/Convert%20Arc%20DateTime.m)
  Arc Data sources will provide dates in Epoch format. This m code will convert this to a datetime format the PowerBI can use correctly.
  ### [Convert HTML Rich Text](https://github.com/SC-TPP/PowerBI-Public/blob/master/Calculated%20Columns/Convert%20HTML.m)
  Code that can be pasted into the add column dialogue to convert HTML rich text and special characters to plain text.

## Custom Functions
Function varients of code found in other sections. To use these code snippets create a blank query and paste the full code in. Retitle the query and use the new title of the query to call the function from other queries.

  ### [Convert Arc Epoch Dateformat](https://github.com/SC-TPP/PowerBI-Public/blob/master/Helper%20Functions/Convert%20Arc%20Epoch%20DateFormat%20Function.m)
  Function that will convert the epoch date format from Arc datasources when called with the correct parameters.
  ### [Convert HTML Text Column](https://github.com/SC-TPP/PowerBI-Public/blob/master/Helper%20Functions/Convert%20HTML%20Text%20Column.m)
  Function that converts html rich text in a column to plain text. Converts special characters as well as removing HTML tags.
  ### [Dynamically Expand Records](https://github.com/SC-TPP/PowerBI-Public/blob/master/Helper%20Functions/Dynamically%20Expand%20Records%20-%20Function.m)
  Function that expands all columns for all records in a column of records. Protects against column changes in records.
  ### [Fix SharePoint Date Column](https://github.com/SC-TPP/PowerBI-Public/blob/master/Helper%20Functions/Fix%20SP%20DateColumn%20Function.m)
  Function that corrects errors caused by sharepoint date only columns and daylight savings.
  ### [Get SharePoint Version History](https://github.com/SC-TPP/PowerBI-Public/blob/master/Helper%20Functions/Get%20SP%20Version%20History%20Function.m)
  Function that retrieves version history from SharePoint for a column of item ids.
  ### [Validate Email Addresses](https://github.com/SC-TPP/PowerBI-Public/blob/master/Helper%20Functions/Validate%20Emails.m)
  Function that returns email validation data fo a column of emails using the api at https://github.com/CodeKJ/DISIFY. This API does not have a 100% success rate. It attempts to validate the format of the email address only. Some bizarre email addresses may return false results.
