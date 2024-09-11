pageextension 50121 SalesQuoteArchiveEX extends "Sales Quote Archive"
{
    layout
    {
        addlast(General)
        {
        field("Quote Status";rec."SOL Quote Status")
         { 
            ApplicationArea = All;
            Editable = false;
            ToolTip = 'Specifies the status of the quote';
         }// stato della quotazione, non modificabile dall'utente
          
          field("Won/Lost Date";rec."SOL Won/Lost Date")
          {
            ApplicationArea = All;
            Editable = false;
            ToolTip = 'Specifies the date when the quote was won or lost';
          }
          field("Won/Lost Reason Code";rec."SOL Won/Lost Reason Code")
          {
            ApplicationArea = All;
            ToolTip = 'Specifies the reason why the quote was won or lost';
          }
          field("Won/Lost Reason Desc."; rec."SOL Won/Lost Reason Desc.")
          {
            ApplicationArea = All;
            Editable = false;
            ToolTip = 'Specifies the description of the reason why the quote was won or lost';
          }
          field("Won/Lost Remarks";rec."SOL Won/Lost Remarks")
          {
            ApplicationArea = All;
            ToolTip = 'Specifies the remarks for the quote';
          }
        }
    }
}