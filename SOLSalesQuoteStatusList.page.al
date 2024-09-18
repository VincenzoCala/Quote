page 50111 "SOL Sales Quote Status List"
{
    PageType = ListPart;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = const(Quote)); // filtra i dati della tabella di origine per mostrare solo i record con document type uguali a "quote"
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Rep) // definisce un gruppo di campi che verranno ripetuti per ogni record nella tabellla di origine
            {
                field("No."; rec."No.") // numero documento
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the no. of this quote.';

                    trigger OnDrillDown()  // questo trigger viene eseguito quando l'utente fa clic su un campo
                    begin
                        Page.Run(Page::"Sales Quote", Rec); // apre la pagina sales quote passando il record rec
                    end;
                }
                field("Sell-to Customer Name"; rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer name linked to this quote.';
                }
                field(Amount; rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total amount of the quote.';
                }
                field("SOL Won/Lost Date"; rec."Won/Lost Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date this quote was closed.';
                }
                field("SOL Won/Lost Reason"; rec."Won/Lost Reason Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reason closing the quote.';
                }
            }
        }
    }





    trigger OnOpenPage()
    begin
        GetQuotesForCurrentUser();
    end;

    local procedure GetQuotesForCurrentUser() // definisce una procedura per filtrare le quotazioni dell'utente
    var
        QuoteStatusMgmt: Codeunit "SOL Quote Status Mgmt";
        SalespersonCode: Code[20];
    begin
        SalespersonCode := QuoteStatusMgmt.GetSalespersonForLoggedInUser(); // assegna il codice del venditore per l'utente corrente 
        rec.FilterGroup(2); // imposta il gruppo di filtro a 2 per applicare filtri contemporaneii
        Rec.SetRange("Salesperson Code", SalespersonCode); // applica un filtro
        Rec.FilterGroup(0); // reimposta il gruppo di filtro a 0
    end;


}
