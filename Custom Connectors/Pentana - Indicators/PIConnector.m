﻿// This file contains your Data Connector logic
section PIConnector;

[DataSource.Kind="PIConnector", Publish="PIConnector.Publish"]
shared PIConnector.Contents = () =>
    let
        return = PI_NavTable()
    in
        return;


// Data Source Kind description
PIConnector = [
    Authentication = [
        Anonymous = []
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
PIConnector.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = PIConnector.Icons,
    SourceTypeImage = PIConnector.Icons
];

PIConnector.Icons = [
    Icon16 = { Extension.Contents("PIConnector16.png"), Extension.Contents("PIConnector20.png"), Extension.Contents("PIConnector24.png"), Extension.Contents("PIConnector32.png") },
    Icon32 = { Extension.Contents("PIConnector32.png"), Extension.Contents("PIConnector40.png"), Extension.Contents("PIConnector48.png"), Extension.Contents("PIConnector64.png") }
];

//Authorization Details
client_password = "";
client_username = "";
//Encoded client secret as text
client_secret = "";
//uris
token_uri = "";
pis_list_uri = "";
//Authorization Token
auth_body = "{ ""grant_type"":""password"",""username"":"""&client_username&""",""password"":"""&client_password&"""}";
auth_parsedbody = Json.Document(auth_body);
auth_content = Uri.BuildQueryString(auth_parsedbody);
Authentication_Request_Headers = [
    #"Content-Type" = "application/x-www-form-urlencoded",
    #"Authorization" = "Basic "&client_secret,
    #"Accept"  = "application/json"
];
//Request Token
Token = 
        "Bearer "&
                    Json.Document(
                        Web.Contents(
                            token_uri,
                                [
                                    Headers = Authentication_Request_Headers,
                                    Content = Text.ToBinary(auth_content),
                                    //IsRetry stops unwanted caching of tokens
                                    IsRetry = true
                                ]
                        )
                    )[access_token];
//Create main navigation table
PI_NavTable = () =>
    let
    //Request all indicators from the Pentana API. Convert to table to make it workable.
        Indicators_Raw = 
            Json.Document(
                Web.Contents(
                    pis_list_uri,
                        [
                            Headers =[Authorization = Token],
                            //IsRetry stops unwanted caching of tokens
                            IsRetry = true
                        ]
                )
            ),
        #"Converted to Table" = 
            Table.FromList(
                Indicators_Raw, 
                    Splitter.SplitByNothing(),
                    null,
                    null,
                    ExtraValues.Error
            ),
    //Expand relevant columns from JSON return
        #"Expanded Column1" = 
            Table.ExpandRecordColumn(
                #"Converted to Table", 
                "Column1", 
                {"id", "code", "title", "active"}, 
                {"id", "code", "title", "active"}),
    //Filter out deactivated Indicators then remove "active" column
        #"Filtered Rows" = 
            Table.SelectRows(
                #"Expanded Column1", 
                each ([active] = true)
            ),
        #"Removed Columns" = 
            Table.RemoveColumns(
                #"Filtered Rows",
                {"active"}
            ),
    //Call PI_GetData function for each indicator and add the results in a calculated column
        GetData = 
            Table.AddColumn(
                #"Removed Columns",
                "data",
                each PI_GetData(Number.ToText([id]))
            ),
    //Add columns relevant to create a navigation table
        Add_itemKind = 
            Table.AddColumn(
                GetData,
                "itemKind",
                each "table"
            ),
        Add_itemName = 
            Table.AddColumn(
                Add_itemKind,
                "itemName",
                each "table"
            ),
        Add_isLeaf = 
            Table.AddColumn(
                Add_itemName,
                "isLeaf",
                each "table"
            ),
    //Create navigation table using Table.ToNavigation table function
        navtable = 
            Table.ToNavigationTable(
                Add_isLeaf,
                {"code"},
                "code",
                "data",
                "itemKind",
                "itemName",
                "isLeaf"
            )
      in 
          navtable
    ;
PI_GetData = (id as text) =>
    let
    //Get indicator data for the passed id. If there is no data return a blank list
        IndicatorData = 
           try Json.Document(
                Web.Contents(
                    pis_list_uri&"/"&id&"/data",
                        [
                            Headers =[Authorization = Token],
                            //IsRetry stops unwanted caching of tokens
                            IsRetry = true
                        ]
                )
            )
        otherwise
            {}
    in
        IndicatorData
    ;
//Navigation table function from Microsofts helper functions documentation
Table.ToNavigationTable = (
    table as table,
    keyColumns as list,
    nameColumn as text,
    dataColumn as text,
    itemKindColumn as text,
    itemNameColumn as text,
    isLeafColumn as text
) as table =>
    let
        tableType = Value.Type(table),
        newTableType = Type.AddTableKey(tableType, keyColumns, true) meta 
        [
            NavigationTable.NameColumn = nameColumn, 
            NavigationTable.DataColumn = dataColumn,
            NavigationTable.ItemKindColumn = itemKindColumn, 
            Preview.DelayColumn = itemNameColumn, 
            NavigationTable.IsLeafColumn = isLeafColumn
        ],
        navigationTable = Value.ReplaceType(table, newTableType)
    in
        navigationTable;