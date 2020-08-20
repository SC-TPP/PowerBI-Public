//Sharepoint Data sources have an issue where they do not account for daylight savings. Dates before clock change will be correct but after will be the previous date but 23:00
//Before creating the calculated column split the datetime column into date and time. Then rename the date column to "Date (wrong)" and the time column to "Time"
//The code below fixes this when placed in a calculated column
if 
    Time.ToText([Time]) = "23:00" 
then 
    Date.AddDays(
        [#"Date (wrong)"],
        1
    ) 
    else 
        [#"Date (wrong)"]
//To create the column directly in the advanced query editor add the code below replacing #previous step with the last step title and "Date" (except in the #Added Correct Date step) with your date column title
    //Duplicate original Date column and set the original to date only and the duplicate to time only
    #"Duplicated DateTime" = 
        Table.DuplicateColumn(
            #previous step, 
            "Date", 
            "Date - Copy"
        ),
    #"Changed Types to Date and Time" = 
        Table.TransformColumnTypes(
            #"Duplicated DateTime",
            {
                {"Date - Copy", type time},
                {"Date", type date}
            }
        ),
    //Rename Columns appropriately
    #"Renamed Date & Time" = 
        Table.RenameColumns(
            #"Changed Types to Date and Time",
            {
                {"Date", "Date (wrong)"},
                {"Date - Copy", "Time"}
            }
        ),
    //Add calculated column that determines correct date based on the time in the time column (SP will show 23:00 hours on the previous day when daylight savings change)
    #"Added Correct Date" = 
        Table.AddColumn(
            #"Renamed Date & Time",
            "Date",
            each 
            //If the time is equal to 23:00 then add one date to the date column. Otherwise use the original date
                if Time.ToText([Time]) = "23:00"
                    then Date.AddDays([#"Date (wrong)"],1)
                    else [#"Date (wrong)"]
        ),
    //Date (Wrong) and Time Columns can be removed (to leave only the correct date) by also including the following
    #"Removed Columns" = 
        Table.RemoveColumns(
            #"Added Correct Date",
            {
                "Date (wrong)",
                "Time"
            }
        )