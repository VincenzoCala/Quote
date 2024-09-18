codeunit 50125 "SOL Quote Status Mgmt"
{
    procedure CloseQuote(var SalesHeader: Record "Sales Header") // accetta il parametro di tipo sales header passato per riferimento var
    begin
        ArchiveSalesQuote(SalesHeader); // la procedura chiama un'altra procedura chiamata archivesalesquote passando per il record SalesHeader
    end;

    local procedure ArchiveSalesQuote(var SalesHeader: Record "Sales Header") // procedura locale  che accetta un parametro di tipo Sales Header
    var
        SalesSetup: Record "Sales & Receivables Setup"; // record dalla tabella Sales & Receivables Setup
        ArchiveManagement: Codeunit "ArchiveManagement"; // codeunit dalla tabella ArchiveManagement
    begin
        SalesSetup.Get(); // recupera il record delle impostazioni di vendita e ricezione
        case
            SalesSetup."Archive Quotes" of // archive quotes è un campo del record sales & receivables setup che determina come devono essere archiviate le quotazioni in vendita, questo campo può avere diversi valori tra cui always e question
            salesSetup."Archive Quotes"::Always: // viene sempre eseguita se il caso è always
                ArchiveManagement.ArchSalesDocumentNoConfirm(SalesHeader); // questo chiama il metodo archsalesdocumentnoconfirm della codeunit archivemanagement passando il record salesheader, questo metodo archivia la quotazione di vendita senza richiedere conferma all'utente.
            SalesSetup."Archive Quotes"::question: // se il caso è question viene eseguito il seguente metodo
                ArchiveManagement.ArchiveSalesDocument(SalesHeader); // questo chiama il metodo archivesalesdocument della codeunit archivemanagement passando il record salesheader, questo metodo archivia la quotazione di vendita richiedendo conferma all'utente.
        end;
    end;




    [EventSubscriber(ObjectType::Page, Page::"Sales Quote", 'OnBeforeActionEvent', 'Archive Document', true, true)] // questo subscriber intercetta l'evento onbeforeactionevent della pagina sales quote quando viene cliccato il pulsante archive document
    local procedure OnBeforeActionArchiveDocumentQuote(var Rec: Record "Sales Header") // procedura locale che accetta un parametro di tipo sales header
    var
        ArchiveCanNotBeCompletedErr: Label 'Document archive can not be completed.'; // dichiarazione di una variabile di tipo label per il messaggio di errore
    begin
        RunCloseQuotePage(Rec, ArchiveCanNotBeCompletedErr); // chiama la procedura runclosequotepage passando il record salesheader e il messaggio di errore
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Quote", 'OnBeforeActionEvent', 'MakeOrder', true, true)]
    local procedure OnBeforeActionMakeOrderQuote(var Rec: Record "Sales Header")
    var
        OrderCreationCanNotBeCompletedErr: Label 'Order creation can not be completed.';
    begin
        RunCloseQuotePage(Rec, OrderCreationCanNotBeCompletedErr);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Quotes", 'OnBeforeActionEvent', 'MakeOrder', true, true)] // questo subscriber intercetta l'evento onbeforeactionevent della pagina sales quotes quando viene cliccato il pulsante make order
    local procedure OnBeforeActionMakeOrderQuotes(var Rec: Record "Sales Header") // procedura locale che accetta un parametro di tipo sales header
    var
        OrderCreationCanNotBeCompletedErr: Label 'Order creation can not be completed.'; // dichiarazione di una variabile di tipo label per il messaggio di errore
    begin
        RunCloseQuotePage(Rec, OrderCreationCanNotBeCompletedErr); // chiama la procedura runclosequotepage passando il record salesheader e il messaggio di errore
    end;

    local procedure RunCloseQuotePage(var SalesHeader: Record "Sales Header"; NotCompletedErr: Text) // procedura locale che accetta due parametri, un record salesheader e un testo
    begin
        if SalesHeader."Won/Lost Quote Status" <> SalesHeader."Won/Lost Quote Status"::"In Progress" then // controlla lo stato della quotazione salesheader se è diverso da in progress
            exit; // se lo stato non è in progress esce dalla procedura

        if Page.RunModal(Page::"SOL Close Quote", SalesHeader) <> Action::LookupOK then //dopo che la pagina modale viene chiusa, il comando verifica il risultato dell'azione eseguita dall'utente, <> è l'operatore di disuguagianza , quindi se la condizione verifica se l'azione viene eseguita dall'utente non è stata quella di conferma (ok)
            Error(NotCompletedErr); // se l'utente non conferma (ok) viene visualizzato un messaggio di errore
    end; // le pagine modali sono utili quando è necessario assicurarsi che un utente esegua un'azione prima di continuare con l'esecuzione del codice.


    [EventSubscriber(ObjectType::Codeunit, Codeunit::ArchiveManagement, 'OnBeforeSalesHeaderArchiveInsert', '', true, true)] // questo attributo dichiara che la procedura onbeforesalesheaderarchiveinsert è un subscriber per l'evento onbeforesalesheaderarchiveinsert della codeunit archivemanagement e (true, true significa che è in modalità solo lettura)
    local procedure OnBeforeSalesHeaderArchiveInsert(var SalesHeaderArchive: Record "Sales Header Archive"; SalesHeader: Record "Sales Header") //la procedura prende due parametri: salesHeaderArchive che è un record della tabella Sales Header Archive passato per riferimento, e salesHeader che è un record della tabella Sales Header
    begin
        if (SalesHeader."Document Type" <> SalesHeader."Document Type"::Quote) then // controlla se il tipo di documento della quotazione è diverso da quote
            exit; // se il tipo di documento non è quote esce dalla procedura

        SalesHeaderArchive."SOL Quote Status" := SalesHeader."Won/Lost Quote Status";
        SalesHeaderArchive."SOL Won/Lost Date" := SalesHeader."Won/Lost Date";
        SalesHeaderArchive."SOL Won/Lost Reason Code" := SalesHeader."Won/Lost Reason Code";
        SalesHeaderArchive."SOL Won/Lost Reason Desc." := SalesHeader."Won/Lost Reason Desc.";
        SalesHeaderArchive."SOL Won/Lost Remarks" := SalesHeader."Won/Lost Remarks";
        // se il tipo di documento è quote allora i valore personalizzati nel record salesHeader vengono copiati dentro sales HeaderArchive
    end;

    procedure GetSalespersonForLoggedInUser(): Code[20] // restituisce un valore di tipo code
    var
        Salesperson: Record "Salesperson/Purchaser";
        User: Record User;
    begin
        User.Reset(); // reimposta il record user, cancellando varii filtri
        if not User.Get(UserSecurityId()) then // se non trova l'utente con l'id di sicurezza dell'utente corrente
            exit(''); // restituisce una stringa vuota e termina la procedura

        if User."Contact Email".Trim() = '' then // verifica se l'email di contatto dell'utente è vuota se è vuota restituisce una stringa vuota
            exit('');

        Salesperson.Reset(); // reimposta il record salesperson, cancellando varii filtri
        Salesperson.SetRange("E-Mail", User."Contact Email"); // imposta il filtro per trovare il record salesperson con l'email uguale all'email di contatto dell'utente
        if Salesperson.FindFirst() then // se trova il record salesperson che soddisfa il filtro restituisce il codice del record salesperson
            exit(Salesperson.Code); // restituisce il codice del record salesperson


        exit('');
    end;






}

