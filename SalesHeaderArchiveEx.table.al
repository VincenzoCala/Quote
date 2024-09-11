tableextension 50111 " Sales Header Archive Ex" extends "Sales Header Archive"
{
    fields
    {
        field(50110; "SOL Quote Status"; Enum "EnumWonLost")
        {
            Caption = 'Quote Status';
            DataClassification = CustomerContent;
        } // Questo campo rappresenta lo stato della quotazione (vinta o persa) utilizzando un enum chiamato "EnumWonLost".

        field(50111; "SOL Won/Lost Date"; DateTime)
        {
            Caption = 'Won/Lost Date';
            DataClassification = CustomerContent;
            // Questo campo memorizza la data in cui la quotazione è stata vinta o persa.
        }

        field(50112; "SOL Won/Lost Reason Code"; Code[10])
        {
            Caption = 'Won/Lost Reason Code';
            DataClassification = CustomerContent;
            TableRelation = if ("SOL Quote Status" = const(Won)) "Close Opportunity Code" where(type = const(Won))
            else
            if ("SOL Quote Status" = const(Lost)) "Close Opportunity Code" where(type = const(Lost));
            ValidateTableRelation = false;
        } // Questo campo memorizza il codice del motivo per cui la quotazione è stata vinta o persa. La relazione della tabella dipende dal valore del campo "SOL Quote Status". Se lo stato è "Won", la relazione è con i record di tipo "Won" nella tabella "Close Opportunity Code". Se lo stato è "Lost", la relazione è con i record di tipo "Lost" nella tabella "Close Opportunity Code". La proprietà ValidateTableRelation è impostata su false per disabilitare la validazione della relazione della tabella.

        field(50113; "SOL Won/Lost Reason Desc."; Text[100])
        {
            Caption = 'Won/Lost Reason Description';
            FieldClass = FlowField;
            CalcFormula = lookup("Close Opportunity Code".Description where(Code = field("SOL Won/Lost Reason Code")));
            Editable = false;
            // Questo campo memorizza la descrizione del motivo per cui la quotazione è stata vinta o persa. È un campo di tipo FlowField, il che significa che il suo valore viene calcolato dinamicamente utilizzando la formula di calcolo specificata. La formula di calcolo cerca la descrizione nella tabella "Close Opportunity Code" dove il codice corrisponde al campo "SOL Won/Lost Reason Code". Il campo non è modificabile dall'utente.
        }

        field(50114; "SOL Won/Lost Remarks"; Text[2048])
        {
            Caption = 'Won/Lost Remarks';
            DataClassification = CustomerContent;
        } // Questo campo memorizza eventuali commenti o osservazioni dell'utente riguardo alla quotazione.


    }
}
