codeunit 50001 Suscriptores
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchRcptLineInsert', '', false, false)]
    local procedure OnAfterPurchRcptLineInsert(PurchaseLine: Record "Purchase Line"; PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        GestionOrdeCompra: Codeunit "Gestion Orden de Compra";
    begin
        GestionOrdeCompra.RealizaAsientoContableFactura(PurchaseLine, PurchRcptLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeInsertReceiptLine', '', false, false)]
    local procedure OnBeforeInsertReceiptLine(PurchLine: Record "Purchase Line")
    var
        GestionOrdeCompra: Codeunit "Gestion Orden de Compra";
    begin
        GestionOrdeCompra.ValidarConfiguracion(PurchLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeCalcInvoice', '', false, false)]
    local procedure OnBeforeCalcInvoice(PurchHeader: Record "Purchase Header")
    var
        GestionOrdeCompra: Codeunit "Gestion Orden de Compra";
    begin
        GestionOrdeCompra.ValidarNoFacturaUnica(PurchHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeStartOrContinuePosting', '', false, false)]
    local procedure OnBeforeStartOrContinuePosting(var NextEntryNo: Integer)
    begin
        Clear(NextEntryNo);
        NextEntryNo := 0;
    end;
}