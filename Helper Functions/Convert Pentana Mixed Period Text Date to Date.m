//This function will work on columns with dates in the following formats
// MONTH YEAR e.g November 2020
// STARTYEAR/ABREVIATEDENDYEAR e.g 2019/20
// QUARTER NUMBER (Q1,Q2,Q3 OR Q4) STARTYEAR/ABREVIATEDENDYEAR e.g Q1 2019/20
// The split year start is designated as the 1st of April
let
    convertmixedtextdate = (previousstep as table, mixedtextdatecolumn as text, startorend as text) =>
        let
            renameoriginalcolumn = 
                Table.RenameColumns(
                    previousstep,
                        {mixedtextdatecolumn, "MixedTextDate"}
                ),
            AddDateColumn = 
                Table.AddColumn(
                    renameoriginalcolumn,
                        mixedtextdatecolumn,
                            each 
                                if startorend = "end"
                                    then
                                        if Text.Start([MixedTextDate],2) = "Q1"
                                            then
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
                                        else if Text.Start([MixedTextDate],2) = "Q2"
                                            then
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
                                        else if Text.Start([MixedTextDate],2) = "Q3"
                                            then
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
                                        else if Text.Start([MixedTextDate],2) = "Q4"
                                            then
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
                                        else if
                                            List.Contains(
                                                {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"},
                                                Text.BeforeDelimiter([MixedTextDate]," ")
                                            )
                                                then 
                                                    Date.EndOfMonth(
                                                        Date.FromText([MixedTextDate])
                                                    )
                                        else
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
                                else if startorend = "start"
                                    then
                                        if Text.Start([MixedTextDate],2) = "Q1"
                                            then
                                                Date.StartOfMonth(
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
                                                )
                                        else if Text.Start([MixedTextDate],2) = "Q2"
                                            then
                                                Date.StartOfMonth(
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
                                                )
                                        else if Text.Start([MixedTextDate],2) = "Q3"
                                            then
                                                Date.StartOfMonth(
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
                                                )
                                        else if Text.Start([MixedTextDate],2) = "Q4"
                                            then
                                                Date.StartOfMonth(
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
                                                )
                                        else if
                                            List.Contains(
                                                {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"},
                                                Text.BeforeDelimiter([MixedTextDate]," ")
                                            )
                                                then 
                                                    Date.FromText([MixedTextDate])
                                        else
                                            Date.StartOfMonth(
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