page 50123  "Sol Close Quote"
{
    Caption = 'Close Quote';
    PageType = Card;
    DeleteAllowed = false; // impedisce la cancellazione del record dalla pagina
    InsertAllowed = false; // impedisce l'inserimento dei recrod nella pagina
    LinksAllowed  = false; // disabilita i collegamenti alla pagina
    UsageCategory = None; // categoria di utilizzo none
    SourceTable = "Sales Header";
 /* None: La pagina non appartiene a nessuna categoria specifica. (usage category)
Lists: La pagina è una lista di record.
Tasks: La pagina è utilizzata per eseguire compiti specifici.
ReportsAndAnalysis: La pagina è utilizzata per report e analisi.
Documents: La pagina è utilizzata per documenti. */
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'General';

                field(QuoteWonlost;rec."Won/Lost Quote Status")
                {
                    ApplicationArea = All;
                    Editable = AllowChangeStatus;
                    ToolTip = 'Specifies the status of the quote.';
                }
                
                field("Won/Lost Date"; rec."Won/Lost Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specified the date this quote was closed.';
                }
                field("Won/Lost Reason"; rec."Won/Lost Reason Code")
                {
                    ApplicationArea = All;
                    Editable = AllowChangeStatus;
                    ToolTip = 'Specifies the reason closing the quote.';
                }
                field("Won/Lost Reason Desc."; rec."Won/Lost Reason Desc.")
                {
                    ApplicationArea = All; // campo visibile in tutte le aree applicative
                    ToolTip = 'Specifies the reason closing the quote.';
                }
                field("Won/Lost Remarks";rec."Won/Lost Remarks") // definisce un campo chiamato won/lost remarks che visualizza il valore del campo won/lost remarks del record sales Header
                {
                    Caption = 'Remarks';
                    ApplicationArea = All;
                    MultiLine = true; // specifica che il campo può contenere più righe di testo
                    Editable = AllowChangeStatus; // una variabile booleana che determina se il campo è modificabile
                    ToolTip = 'Specified an extra remark on the quote status.';
                }
            }
        }
    }     

    var
    AllowChangeStatus: Boolean; //questa variabile verrà utilizzata per determinare se lo stato della quotazione può essere modificato

    trigger OnOpenPage()
    begin
    AllowChangeStatus := Rec."Won/Lost Quote Status" <> rec."Won/Lost Quote Status"::"Won";
    end; // imposta allowchangestatus su true se lo stato della quotazione è diverso da won, altrimenti lo imposta su false.


    trigger OnQueryClosePage(CloseAction: Action): Boolean // questo trigger viene eseguito quando si tenta di chiudere la pagina
begin
    if CloseAction = Action::LookupOK then
        FinishWizard(); // se l'azione di chiusura closeaction è lookupok allora chiama la procedura finishwizard
end;

local procedure FinishWizard() // questa procedura viene chiamata dal teigger onqueryclosepage se l'azione di chiusura è lookupok
var
    MustSelectWonOrLostErr: Label 'You must select either Won or Lost.'; // etichetta il messaggio di errore
    FieldMustBeFilledInErr: Label 'You must fill in the %1 field.', Comment = '%1 = caption of the field.'; // etichetta il messaggio di errore dove 1% è il commento che rappresenta la didascalia del campo
begin
    if not (Rec."Won/Lost Quote Status" in [Rec."Won/Lost Quote Status"::Won, Rec."Won/Lost Quote Status"::Lost]) then
        Error(MustSelectWonOrLostErr); // se lo stato della quotazione non è né won né lost allora mostra un errore

    if rec."Won/Lost Reason Code" = '' then
        Error(FieldMustBeFilledInErr) //fieldCaption(rec."Won/Lost Reason Code")); //fieldCaption mi da errore
   // se il campo è vuoto genera l'errore fieldmustbefilledinerr
    
end;

}

