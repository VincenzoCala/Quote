pageextension 50120 SalesQuotesEx extends "Sales Quotes"
{
    layout
    {
        addafter("Due Date")
        {
            field("Quote Status"; rec."Won/Lost Quote Status")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the status of the quote';
            }
            field("Won/Lost Date"; rec."Won/Lost Date")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the date when the quote was won or lost';
            }
            field("Won/Lost Reason Code"; rec."Won/Lost Reason Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the reason why the quote was won or lost';
            }
            field("Won/Lost Reason Desc."; rec."Won/Lost Reason Desc.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the description of the reason why the quote was won or lost';
            }
            field("Won/Lost Remarks"; rec."Won/Lost Remarks")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the remarks for the quote';
            }
        }

    }
}





