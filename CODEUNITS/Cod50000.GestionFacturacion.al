codeunit 50000 "Gestion Orden de Compra"
{
    trigger OnRun()
    var
    begin
    end;

    procedure RealizaAsientoContableFactura(PurchaseLine: Record "Purchase Line"; PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        Alerta: Label 'suscrito al evento con numero de compra %1 y numero de recepcion %2';
        NumDocOrdenCompra: Code[20];
        NumDocOrdenRecepecionCompra: Code[20];
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlTemp: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";

    begin
        NumDocOrdenCompra := PurchaseLine."Document No.";
        NumDocOrdenRecepecionCompra := PurchRcptLine."Document No.";
        if (PurchaseLine.Type = PurchaseLine.Type::Item)
            or (PurchaseLine.Type = PurchaseLine.Type::Resource)
            then
            Message('estoy en validacion');
    end;

    procedure ValidarConfiguracion(PurchaseLine: Record "Purchase Line")
    var
        erroMsg: Label 'verifique la configuracion de las cuentas de registro general si no debe tener, verifique la cuenta de contrapartida de la seccion de libros diario general activada';
    begin
        if (PurchaseLine.Type = PurchaseLine.Type::Item)
            or (PurchaseLine.Type = PurchaseLine.Type::Resource)
            then
            if not ValidarConfiguracionCuentas(PurchaseLine) then
                Error(erroMsg);
    end;

    local procedure ValidarConfiguracionCuentas(PurchaseLine: Record "Purchase Line"): Boolean
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        status: Boolean;
        erroMsg: Label 'verifique que se encuentra seleccionada la casilla Habilitar para fact. pdtes recibir en las seccion de libros diario general';
    begin
        status := false;
        GenJnlBatch.SetRange("Habilitar fact. pdtes recibir", true);
        if GenJnlBatch.FindFirst() then begin
            if ValidarConfiguracionCuentasRegistroGeneral(PurchaseLine) then
                status := true
            else
                if GenJnlBatch."Bal. Account No." <> '' then
                    status := true;
        end
        else
            Error(erroMsg);
        exit(status);
    end;

    local procedure ValidarConfiguracionCuentasRegistroGeneral(PurchaseLine: Record "Purchase Line"): Boolean
    var
        GenPostSetup: Record "General Posting Setup";
        status: Boolean;
    begin
        status := false;
        GenPostSetup.SetRange("Gen. Bus. Posting Group", PurchaseLine."Gen. Bus. Posting Group");
        GenPostSetup.SetRange("Gen. Prod. Posting Group", PurchaseLine."Gen. Prod. Posting Group");
        if GenPostSetup.FindFirst() then
            if (GenPostSetup."Purch. Account" <> '')
            and (GenPostSetup."Cta. compra pdtes recibir" <> '')
            and (GenPostSetup."Cta. facturas pdtes recibir" <> '')
            then
                status := true;
        exit(status);
    end;
}