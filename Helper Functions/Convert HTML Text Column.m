let
    //Define function parameters as requiring the previous step as a table and the name of the column with html formatted text in it as text
    ConvertHTML = (PreviousStep as table, ColumnName as text) =>
    let 
        //Rename the original epoch column to allow it to be easily referenced in the next step
        RenameOriginalColumn = 
                                Table.RenameColumns(
                                    PreviousStep,
                                        {
                                            {ColumnName, "HTMLText"}
                                        }
                                ),
        //Add a calculated column to create plain text from html held in each row of the column specified
        AddCalculatedConvertHTML = 
                                Table.AddColumn(
                                    RenameOriginalColumn,
                                    ColumnName,
                                    each
                                        let
                                            GetPlainTextAsTable = 
                                                Html.Table(
                                                    [HTMLText],
                                                        {
                                                            {"Plaintext",":root"}
                                                        }
                                                ),
                                            //Expand the table created above down to only select the "Plaintext" column and then only the first row value (there are no other values returned due to ":root")
                                            GetPlaintext = GetPlainTextAsTable[Plaintext]{0}
                                        in 
                                            GetPlaintext
                                ),
        //Remove the original column so that only the corrected one is returned
        RemoveOriginalColumn = 
                                Table.RemoveColumns(
                                    AddCalculatedConvertHTML,
                                        {"HTMLText"}
                                ),
        //Reorder columns to the order passed in the original table
         #"Set Column Order to Original" = 
            Table.ReorderColumns(
                RemoveOriginalColumn,
                    //The new column has the same name as the old column so we can use Table.ColumnNames to avoid hardcoding column names here
                    Table.ColumnNames(PreviousStep)
            )
    in
        #"Set Column Order to Original"
in
    ConvertHTML