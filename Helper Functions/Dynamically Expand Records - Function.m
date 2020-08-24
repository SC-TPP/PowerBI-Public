let
    //Define function parameters as requiring the previous step as a table and the name of the column of records as text
    ExpandAllRecords = (PreviousStep as table, RecordsColumnName as text) =>
        let 
            ExpandAllColumnsFromRecords =
                                Table.ExpandRecordColumn(
                                    PreviousStep,
                                    RecordsColumnName,
                                    Table.ColumnNames(
                                        Table.FromRecords(
                                            List.Select(
                                                Table.Column(
                                                    PreviousStep,
                                                    RecordsColumnName
                                                ),
                                                each _ <> "" and _ <> null   
                                            )
                                        )
                                    ),
                                    Table.ColumnNames(
                                        Table.FromRecords(
                                            List.Select(
                                                Table.Column(
                                                    PreviousStep,
                                                    RecordsColumnName
                                                ),
                                                each _ <> "" and _ <> null
                                            )
                                        )
                                    )
                            )
        in
            ExpandAllColumnsFromRecords
in
    ExpandAllRecords
