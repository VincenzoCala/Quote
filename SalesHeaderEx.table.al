tableextension 50102 SalesHeaderEX extends "Sales Header"
{
    fields
    {
        field(50103; "Won/Lost Quote Status"; Enum EnumWonLost)
        {
            Caption = 'Won/Lost Quote Status';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                // Quando viene cambiato lo status, aggiorna la data
                if ("Won/Lost Quote Status" in ["enumWonLost"::Won, "EnumWonLost"::Lost]) then begin
                    "Won/Lost Date" := CurrentDateTime;
                    Validate("Won/Lost Reason Code");
                end;
            end; // questo campo rappresenta lo stato della quotazione, il valore di questo campo viene modificato sul trigger on validate, se è won o lost

        }
        field(50104; "Won/Lost Date"; DateTime)
        {
            Caption = 'Won/Lost Date';
            DataClassification = ToBeClassified;
            Editable = false; // Questo campo memorizza la data in cui la quotazione è stata vinta o persa. Non è modificabile dall'utente.
        }
        field(50105; "Won/Lost Reason Code"; Code[10])
        {
            Caption = 'Won/Lost Reason Code';
            DataClassification = CustomerContent;
            TableRelation = if ("Won/Lost Quote Status" = const(Won)) "Close Opportunity Code" where(type = const(Won))
            else
            if ("Won/Lost Quote Status" = const(Lost)) "Close Opportunity Code" where(type = const(Lost));
            // Questo campo memorizza il codice del motivo per cui la quotazione è stata vinta o persa. La relazione della tabella dipende dal valore del campo "Won/Lost Quote Status". Se lo stato è Won, la relazione è con i record di tipo Won nella tabella "Close Opportunity Code". Se lo stato è Lost, la relazione è con i record di tipo Lost.
            trigger OnValidate()
            begin
                CalcFields("Won/Lost Reason Desc.");
            end; // Il trigger OnValidate calcola il campo "Won/Lost Reason Desc." quando il valore di questo campo viene modificato.
        }

        field(50106; "Won/Lost Reason Desc."; Text[100])
        {
            Caption = 'Won/Lost Reason Description';
            DataClassification = ToBeClassified;
            Editable = false; // Non modificabile dall'utente
            // Questo campo memorizza la descrizione del motivo per cui la quotazione è stata vinta o persa. Non è modificabile dall'utente.
        }
        field(50107; "Won/Lost Remarks"; Text[2048])
        {
            Caption = 'Won/Lost Remarks';
            DataClassification = ToBeClassified;
            // Questo campo memorizza eventuali commenti o osservazioni dell'utente riguardo alla quotazione.
        }
    }



}