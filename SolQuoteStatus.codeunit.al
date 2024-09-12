codeunit 50125 "SOL Quote Status Mgmt"
{
    procedure CloseQuote(var SalesHeader: Record "Sales Header") // accetta il parametro di tipo sales header passato per riferimento var
    begin 
        ArchiveSalesQuote(SalesHeader); // la procedura chiama un'altra procedura chiamata archivesalesquote passando per il record SalesHeader
    end;
local procedure ArchiveSalesQuote(var SalesHeader: Record "Sales Header") // procedura locale  che accetta un parametro di tipo Sales Header
var 
SalesSetup : Record "Sales & Receivables Setup"; // record dalla tabella Sales & Receivables Setup
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






}

