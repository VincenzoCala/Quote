pageextension 50127 BusinessManagerRoleCenterEx extends "business Manager Role Center"

{
    layout
    {
        addbefore("Favorite Accounts") // aggiunge nuovi elementi prima della parte esistente chiamata "favorite Accounts"
        {
            part(SalesQuotesWon;"SOL Sales Quote Status List") // definisce una nuova parte che utilizza la pagina sol sales quote status list
            {
                ApplicationArea = All;
                SubPageView = where("Won/Lost Quote Status" = const("Won")); // filtra i dati nella sottopagina per mostrare solo le quotazioni con lo stato won
                Caption = 'Won Quotes';
            }

            part(SalesQuotesLost; "SOL Sales Quote Status List")
            {
                ApplicationArea = All;
                SubPageView =where( "Won/Lost Quote Status" = const("Lost"));
                Caption = 'Lost Quotes';
            }
        }
    }
}