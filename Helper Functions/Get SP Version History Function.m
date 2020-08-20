let
    //Define function parameters as requiring the previous step as a table, the column name that contains item ids as text,
    //the site url (down to subsite name only) as text and the name of the list as text
    GetVersionHistory = (PreviousStep as table, ItemIdColumn as text, SiteUrl as text, ListTitle as text) =>
        let 
            //Construct url for first part of web,contents using provided parameters
            url = SiteUrl&"/_api/web/lists/getbytitle('"&ListTitle&"')",
            //Rename id column to ensure correct referencing in next step
            #"Set ID Column Title" = 
                            Table.RenameColumns (
                                PreviousStep,
                                    {ItemIdColumn, "id"}
                            ),
            //Add calculated column that calls the SharePoint REST service to retrieve the version history for each item
            #"Get Version History" =
                            Table.AddColumn(
                                #"Set ID Column Title",
                                "SP Version History",
                                each Json.Document(
                                        Web.Contents(
                                            url,
                                            [
                                                //RelativePath stops this step from failing refresh in the PowerBI service
                                                //The service gets a valid response from the url above and so is happy to process the rest
                                                RelativePath = "/items("&Number.ToText([id])&")/versions",
                                                Headers = [#"accept" = "application/json; odata=nometadata"]
                                            ]
                                        )
                                    )
                                ),
            //Expand the column of records provided by the REST service into a column of lists (this is included to reduce steps needed after calling this function)
            #"Expand Json Return" = 
                            Table.ExpandRecordColumn (
                                #"Get Version History",
                                    "SP Version History",
                                    {"value"},
                                    {"SP Version History"}
                            ),
            //Reset the id column name to the original column title
            #"Reset ID Column Title" = 
                            Table.RenameColumns(
                                #"Expand Json Return",
                                    {"id", ItemIdColumn}
                            )
        in
            #"Reset ID Column Title"
in
    GetVersionHistory