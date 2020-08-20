//The following code will convert Arc epoch dateformats into a format that PowerBI recognises as a datetime
//Replace PreviousStep and [DateColumn] as appropriate
#"Added Custom" = 
    Table.AddColumn(
        PreviousStep, 
        "ChangeDate", 
            each
                //Epoch Datetime is the number of milliseconds since the 1st of January 1970. 
                //The below converts the number of milliseconds into a duration in seconds and adds this into the datetime 1st of January 1970
                #datetime(1970,1,1,0,0,0)+
                #duration(0,0,0,[DateColumn]/1000)
    )