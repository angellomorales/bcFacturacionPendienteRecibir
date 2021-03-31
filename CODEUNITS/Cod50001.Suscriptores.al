codeunit 50001 Suscriptores
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchRcptLineInsert', '', false, false)]
    local procedure OnAfterPurchRcptLineInsert(PurchaseLine: Record "Purchase Line"; PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        GestionOrdeCompra: Codeunit "Gestion Orden de Compra";
    begin
        GestionOrdeCompra.RealizaAsientoContableFactura(PurchaseLine, PurchRcptLine);
    end;
}