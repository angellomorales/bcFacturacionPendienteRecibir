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
}