let
    //Define function parameters as requiring the previous step as a table and the name of the column with the incorrect SharePoint date in it as text
    DateCorrectforDaylightSavings = (PreviousStep as table, DateColumnName as text) =>
    let
    //Duplicate the original column
    #"Duplicated DateTime" = 
        Table.DuplicateColumn(
            PreviousStep, 
            DateColumnName, 
            "Date - Copy"
        ),
    //Set the duplicate to type time only and the original to type date only
    #"Changed Types to Date and Time" = 
        Table.TransformColumnTypes(
            #"Duplicated DateTime",
            {
                {"Date - Copy", type time},
                {DateColumnName, type date}
            }
        ),
    //Rename Columns appropriately
    #"Renamed Date & Time" = 
        Table.RenameColumns(
            #"Changed Types to Date and Time",
            {
                {DateColumnName, "Date (wrong)"},
                {"Date - Copy", "Time"}
            }
        ),
    //Add calculated column that determines correct date based on the time in the time column (SP will show 23:00 hours on the previous day when daylight savings change)
    #"Added Correct Date" = 
        Table.AddColumn(
            #"Renamed Date & Time",
            DateColumnName,
            each 
            //If the time is equal to 23:00 then add one date to the date column. Otherwise use the original date
                if Time.ToText([Time]) = "23:00"
                    then Date.AddDays([#"Date (wrong)"],1)
                    else [#"Date (wrong)"]
        ),
    //Date (Wrong) and Time Columns removed so that only the corrected column is included in the returned table
    #"Removed Columns" = 
        Table.RemoveColumns(
            #"Added Correct Date",
            {
                "Date (wrong)",
                "Time"
            }
        ),
    //Set type of the new column to date (it returns as text without this step)
    #"Set Type to Date" =
        Table.TransformColumnTypes(
            #"Removed Columns",
                {DateColumnName, type date}
        ),
    //Reorder columns to the order passed in the original table
    #"Set Column Order to Original" = 
        Table.ReorderColumns(
            #"Set Type to Date",
                //The new column has the same name as the old column so we can use Table.ColumnNames to avoid hardcoding column names here
                Table.ColumnNames(PreviousStep)
        )
    in
        #"Set Column Order to Original"
in 
    DateCorrectforDaylightSavings