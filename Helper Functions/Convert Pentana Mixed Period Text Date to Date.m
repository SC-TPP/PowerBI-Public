//This function will work on columns with dates in the following formats (the formats output in the summary part of the timeperiod record returned in the get request for PI data from the Pentana API)
// MONTH YEAR e.g November 2020
// STARTYEAR/ABREVIATEDENDYEAR e.g 2019/20
// QUARTER NUMBER (Q1,Q2,Q3 OR Q4) STARTYEAR/ABREVIATEDENDYEAR e.g Q1 2019/20
// The split year start is designated as the 1st of April
let
    convertmixedtextdate = (previousstep as table, mixedtextdatecolumn as text, startorend as text) =>
        let
            //Rename the original epoch column to allow it to be easily referenced in the next step
            renameoriginalcolumn = 
                Table.RenameColumns(
                    previousstep,
                        {mixedtextdatecolumn, "MixedTextDate"}
                ),
            //Add calculated column that will deal with the specified text date formats as output by the Pentana Get PI Data API endpoint
            AddDateColumn = 
                Table.AddColumn(
                    renameoriginalcolumn,
                        mixedtextdatecolumn,
                            each 
                                //formats dates as the end of the Quarter,Month or Split Year if the startorend function parameter equals "end"
                                if startorend = "end"
                                    then
                                        //Test if the first two characters of the value in the column specified in the MixedTextDate parameter of the function is "Q1" and format date appropriately
                                        if Text.Start([MixedTextDate],2) = "Q1"
                                            then
                                                //Combine the start of the last month of Q1 and the first 4 characters of the last substring then turn this into the end of month date
                                                //e.g 01/06 and 2018/19 => 2018 so the output would be 30/06/2018
                                                Date.EndOfMonth(
                                                    Date.FromText(
                                                        Text.Combine(
                                                            {
                                                                "01/06",
                                                                Text.Start(
                                                                    Text.End([MixedTextDate],7),
                                                                    4
                                                                )
                                                            },
                                                            "/"
                                                        )
                                                    )
                                                )
                                        //Test if the first two characters of the value in the column specified in the MixedTextDate parameter of the function is "Q2" and format date appropriately
                                        else if Text.Start([MixedTextDate],2) = "Q2"
                                            then
                                                //Combine the start of the last month of Q2 and the first 4 characters of the last substring then turn this into the end of month date
                                                //e.g 01/09 and 2018/19 => 2018 so the output would be 30/09/2018
                                                Date.EndOfMonth(
                                                    Date.FromText(
                                                        Text.Combine(
                                                            {
                                                                "01/09",
                                                                Text.Start(
                                                                    Text.End([MixedTextDate],7),
                                                                    4
                                                                )
                                                            },
                                                            "/"
                                                        )
                                                    )
                                                )
                                        //Test if the first two characters of the value in the column specified in the MixedTextDate parameter of the function is "Q3" and format date appropriately
                                        else if Text.Start([MixedTextDate],2) = "Q3"
                                            then
                                                //Combine the start of the last month of Q3 and the first 4 characters of the last substring then turn this into the end of month date
                                                //e.g 01/12 and 2018/19 => 2018 so the output would be 31/12/2018
                                                Date.EndOfMonth(
                                                    Date.FromText(
                                                        Text.Combine(
                                                            {
                                                                "01/12",
                                                                Text.Start(
                                                                    Text.End([MixedTextDate],7),
                                                                    4
                                                                )
                                                            },
                                                            "/"
                                                        )
                                                    )
                                                )
                                        //Test if the first two characters of the value in the column specified in the MixedTextDate parameter of the function is "Q4" and format date appropriately
                                        else if Text.Start([MixedTextDate],2) = "Q4"
                                            then
                                                //Combine the start of the last month of Q4 and the first 2 characters of the last substring and the last 2 characters of the last substring then turn this into the end of month date
                                                //e.g 01/03 and 2018/19 => 20 combined with 19 so the output would be 31/03/2019
                                                Date.EndOfMonth(
                                                    Date.FromText(
                                                        Text.Combine(
                                                            {
                                                                "01/03",
                                                                Text.Combine(
                                                                    {
                                                                        Text.Start(
                                                                            Text.End([MixedTextDate],7),
                                                                            2
                                                                        ),
                                                                        Text.End(
                                                                            Text.End([MixedTextDate],7),
                                                                            2
                                                                        )
                                                                    }
                                                                )
                                                            },
                                                            "/"
                                                        )
                                                    )
                                                )
                                        //Test if the first word of the value in the column specified in the MixedTextDate parameter of the function is a month name and format date appropriately
                                        else if
                                            List.Contains(
                                                {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"},
                                                Text.BeforeDelimiter([MixedTextDate]," ")
                                            )
                                                then
                                                    //The format MONTHNAME YEAR natively converts so here we can just apply Date.FromText to get a 1st of month date then Date.EndOfMonth to get the end of month date
                                                    Date.EndOfMonth(
                                                        Date.FromText([MixedTextDate])
                                                    )
                                        //Assume if the other two if tests fail that the value is a split year in the format YEAR/ABBREVIATEDYEAR e.g 2018/19 and format date appropriately
                                        else
                                            //Combine the start of the last month of the split year and the first 2 characters of the last substring and the last 2 characters of the last substring then turn this into the end of month date
                                            //e.g 01/03 and 2018/19 => 20 combined with 19 so the output would be 31/03/2019
                                            Date.EndOfMonth(
                                                            Date.FromText(
                                                                Text.Combine(
                                                                    {
                                                                        "01/03",
                                                                        Text.Combine(
                                                                            {
                                                                                Text.Start(
                                                                                    Text.End([MixedTextDate],7),
                                                                                    2
                                                                                ),
                                                                                Text.End(
                                                                                    Text.End([MixedTextDate],7),
                                                                                    2
                                                                                )
                                                                            }
                                                                        )
                                                                    },
                                                                    "/"
                                                                )
                                                            )
                                                        )
                                //formats dates as the end of the Quarter,Month or Split Year if the startorend function parameter equals "start"
                                else if startorend = "start"
                                    then
                                        //Test if the first two characters of the value in the column specified in the MixedTextDate parameter of the function is "Q1" and format date appropriately
                                        if Text.Start([MixedTextDate],2) = "Q1"
                                            then
                                                //Combine the start of the first month of Q1 and the first 4 characters of the last substring
                                                //e.g 01/04 and 2018/19 => 2018 so the output would be 01/04/2018
                                                Date.FromText(
                                                    Text.Combine(
                                                        {
                                                            "01/04",
                                                            Text.Start(
                                                                Text.End([MixedTextDate],7),
                                                                4
                                                            )
                                                        },
                                                        "/"
                                                    )
                                                )
                                        //Test if the first two characters of the value in the column specified in the MixedTextDate parameter of the function is "Q2" and format date appropriately
                                        else if Text.Start([MixedTextDate],2) = "Q2"
                                            then
                                                //Combine the start of the first month of Q2 and the first 4 characters of the last substring
                                                //e.g 01/07 and 2018/19 => 2018 so the output would be 01/07/2018
                                                Date.FromText(
                                                    Text.Combine(
                                                        {
                                                            "01/07",
                                                            Text.Start(
                                                                Text.End([MixedTextDate],7),
                                                                4
                                                            )
                                                        },
                                                        "/"
                                                    )
                                                )
                                        //Test if the first two characters of the value in the column specified in the MixedTextDate parameter of the function is "Q3" and format date appropriately
                                        else if Text.Start([MixedTextDate],2) = "Q3"
                                            then
                                                //Combine the start of the first month of Q3 and the first 4 characters of the last substring
                                                //e.g 01/10 and 2018/19 => 2018 so the output would be 01/10/2018
                                                Date.FromText(
                                                    Text.Combine(
                                                        {
                                                            "01/10",
                                                            Text.Start(
                                                                Text.End([MixedTextDate],7),
                                                                4
                                                            )
                                                        },
                                                        "/"
                                                    )
                                                )
                                        //Test if the first two characters of the value in the column specified in the MixedTextDate parameter of the function is "Q4" and format date appropriately
                                        else if Text.Start([MixedTextDate],2) = "Q4"
                                            then
                                                //Combine the start of the first month of Q4 and the first 2 characters of the last substring and the last 2 characters of the last substring
                                                //e.g 01/01 and 2018/19 => 20 combined with 19 so the output would be 01/01/2019
                                                Date.FromText(
                                                    Text.Combine(
                                                        {
                                                            "01/01",
                                                            Text.Combine(
                                                                {
                                                                    Text.Start(
                                                                        Text.End([MixedTextDate],7),
                                                                        2
                                                                    ),
                                                                    Text.End(
                                                                        Text.End([MixedTextDate],7),
                                                                        2
                                                                    )
                                                                }
                                                            )
                                                        },
                                                        "/"
                                                    )
                                                )
                                        //Test if the first word of the value in the column specified in the MixedTextDate parameter of the function is a month name and format date appropriately
                                        else if
                                            List.Contains(
                                                {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"},
                                                Text.BeforeDelimiter([MixedTextDate]," ")
                                            )
                                                then 
                                                    Date.FromText([MixedTextDate])
                                        //Assume if the other two if tests fail that the value is a split year in the format YEAR/ABBREVIATEDYEAR e.g 2018/19 and format date appropriately
                                        else
                                            //Combine the start of the first month of the split year and the first 4 characters of the last substring
                                            //e.g 01/04 and 2018/19 => 2018 so the output would be 01/04/2018
                                            Date.FromText(
                                                Text.Combine(
                                                    {
                                                        "01/04",
                                                        Text.Start(
                                                            Text.End([MixedTextDate],7),
                                                            4
                                                        )
                                                    },
                                                    "/"
                                                )
                                            )
                                else "Formatting Error"
                            ),

            //Remove the original column so that only the corrected one is returned
            RemoveOriginalColumn = 
                Table.RemoveColumns(
                    AddDateColumn,
                            {"MixedTextDate"}
                ),
            //Reorder columns to the order passed in the original table
            #"Set Column Order to Original" = 
                Table.ReorderColumns(
                    RemoveOriginalColumn,
                        //The new column has the same name as the old column so we can use Table.ColumnNames to avoid hardcoding column names here
                        Table.ColumnNames(previousstep)
            )
        in
            #"Set Column Order to Original"
in
    convertmixedtextdate