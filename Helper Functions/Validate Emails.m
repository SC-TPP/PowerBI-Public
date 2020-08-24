let
    //Define function parameters as requiring the previous step as a table, the column name that contains email addresses as text,
    ValidateEmail = (PreviousStep as table, EmailColumnName as text) =>
        let
            //Rename Email column to ensure correct referencing in next step
            RenameEmailColumn = 
                Table.RenameColumns(
                    PreviousStep,
                        {EmailColumnName,"EmailsToValidate"}
                ),
            //Add calculated column that calls the API service at https://github.com/CodeKJ/DISIFY to retrieve validation data regarding the passed email address
            GetValidationReturn = 
                Table.AddColumn(
                    RenameEmailColumn,
                        "EmailValidationReturn",
                        each 
                            Json.Document(
                                Web.Contents(
                                    "https://disify.com/api/email",
                                    [
                                        //RelativePath stops this step from failing refresh in the PowerBI service
                                        //The service gets a valid response from the url above and so is happy to process the rest
                                        RelativePath = "/"&[EmailsToValidate]
                                    ]
                                )
                            )
                ),
            //Return Email column to original title
            RenameEmailColumnToOriginal = 
                Table.RenameColumns(
                    GetValidationReturn,
                     {"EmailsToValidate",EmailColumnName}
                )
        in
            RenameEmailColumnToOriginal

in
    ValidateEmail