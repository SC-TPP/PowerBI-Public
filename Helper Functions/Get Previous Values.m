let 
    //Before using this function please ensure that your data is sorted in an appropriate order "Previous Values" in this case are literaly previous rows
    GetPreviousValues = 
        (
            PreviousStep as table,
            DataColumnName as text,
            PeriodsBacktoReturn as number,
            optional GroupByColumnName as text
        ) =>
        let
            //Buffer table to prevent any reordering while previous values are calculated. This will mean that with VERY large data sets this function will fail due to lack of memory
            Buffer = Table.Buffer(PreviousStep),
            //Rename data column for use in next steps
            RenameDataColumn = 
                Table.RenameColumns(
                    Buffer,
                        {DataColumnName, "Data"}
                ),
            //Rename GroupBy column for use in next steps
            RenameGroupByColumn = 
                try
                    Table.RenameColumns(
                        RenameDataColumn,
                            {GroupByColumnname, "GroupBy"}
                    )
                otherwise RenameDataColumn,
            //Add index column so that we can refer to index positions later
            AddedIndex =
                Table.AddIndexColumn(
                    RenameGroupByColumn,
                        "PrimaryIndex",
                            0,
                            1,
                                Int64.Type
                ),
            //Add column with the requested previous values
            AddPreviousValues = 
                Table.AddColumn(
                    AddedIndex,
                        //Dynamically name column based on periods back requested
                        Number.ToText(PeriodsBacktoReturn) & " Periods Back Value",
                            each
                                //Test if GroupBy parameter was passed
                                if GroupBy = null
                                    then
                                        //try otherwise stops error for first item
                                        try AddedIndex{[PrimaryIndex]-PeriodsBacktoReturn}[Data]
                                        otherwise null
                                else if 
                                        //try otherwise stops error for first item in each group
                                        try AddedIndex{[PrimaryIndex]-PeriodsBacktoReturn}[GroupBy] = [GroupBy]
                                        otherwise false
                                    then
                                        AddedIndex{[PrimaryIndex]-PeriodsBacktoReturn}[Data]
                                    else null
                ),
            //Remove Index
            RemoveIndex = 
                Table.RemoveColumns(
                    AddPreviousValues,
                        "PrimaryIndex"
                ),
            //Rename Data Column
            RevertDataColumnName =
                Table.RenameColumns(
                    RemoveIndex,
                        {"Data", DataColumnName}
                ),
            RevertGroupByColumnName =
                try
                    Table.RenameColumns(
                        RevertDataColumnName,
                            {"GroupBy", GroupByColumnname}
                    )
                otherwise RevertDataColumnName
        in
            RevertGroupByColumnName
in
    GetPreviousValues