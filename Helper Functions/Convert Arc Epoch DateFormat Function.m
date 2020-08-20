let
    //Define function parameters as requiring the previous step as a table and the name of the column with the epoch datenumber in it as text
    ConvertArcEpoch = (PreviousStep as table, EpochColumnName as text) =>
        let
            //Rename the original epoch column to allow it to be easily referenced in the next step
            #"Rename Original Column" = 
                Table.RenameColumns(
                    PreviousStep,
                        {EpochColumnName, "EpochDate"}
                ),
            //Add a calculated column that does the maths necessary to convert epoch into a date format PowerBI understands
            #"Create Date From Epoch" = 
                Table.AddColumn(
                    #"Rename Original Column",
                        //Set the title of this column as the original column name passed to the function
                        EpochColumnName, 
                            each
                                //Epoch Datetime is the number of milliseconds since the 1st of January 1970. 
                                //The below converts the number of milliseconds into a duration in seconds and adds this into the datetime 1st of January 1970
                                #datetime(1970,1,1,0,0,0)+
                                #duration(0,0,0,[EpochDate]/1000)
                ),
            //Remove the original column
            #"Remove Original Epoch Date Column" = 
                Table.RemoveColumns(
                    #"Create Date From Epoch"
                        {"EpochDate"}
                ),
            //Reorder columns to the order passed in the original table
            #"Set Column Order to Original" = 
                Table.ReorderColumns(
                    #"Remove Original Epoch Date Column",
                        //The new column has the same name as the old column so we can use Table.ColumnNames to avoid hardcoding column names here
                        Table.ColumnNames(PreviousStep)
                )
        in
            #"Set Column Order to Original"

in
    ConvertArcEpoch