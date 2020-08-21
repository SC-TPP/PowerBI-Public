//Add the code below to the calculated column dialogue box to convert HTML to plaintext (converting special characters such as &amp and removing html tags like <br>)
//Replace [HTML Column] with the Correct column reference for your scenario
if [HTML Column] = null
    then null
    else 
        let
            GetPlainTextAsTable = 
                Html.Table(
                    [HTML Column],
                        {
                            {"Plaintext",":root"}
                        }
                ),
            //Expand the table created above down to only select the "Plaintext" column and then only the first row value (there are no other values returned due to ":root")
            GetPlaintext = GetPlainTextAsTable[Plaintext]{0}
        in 
            GetPlaintext