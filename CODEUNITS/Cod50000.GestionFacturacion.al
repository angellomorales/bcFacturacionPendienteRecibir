codeunit 50000 "Gestion Orden de Compra"
{
    trigger OnRun()
    var
    begin
    end;

    procedure RealizaAsientoContableFactura(PurchaseLine: Record "Purchase Line"; PurchRcptLine: Record "Purch. Rcpt. Line")
    begin
        if (PurchaseLine.Type = PurchaseLine.Type::Item)
        or (PurchaseLine.Type = PurchaseLine.Type::Resource)
        then
            InsertarLinea(PurchaseLine, PurchRcptLine);
    end;

    local procedure InsertarLinea(PurchaseLine: Record "Purchase Line"; PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
        Cuenta: Code[20];
        Contrapartida: Code[20];
    begin
        GenJnlBatch.SetRange("Habilitar fact. pdtes recibir", true);
        if GenJnlBatch.FindFirst() then begin
            ObtenerCuentaYContrapartida(PurchaseLine, Cuenta, Contrapartida);
            GenJnlLine.Init();
            GenJnlLine."Posting Date" := WorkDate();
            GenJnlLine."Journal Template Name" := GenJnlBatch."Journal Template Name";
            GenJnlLine."Journal Batch Name" := GenJnlBatch.Name;
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := Cuenta;
            // GenJnlLine."Debit Amount" := PurchaseLine."Unit Cost" * PurchaseLine."Qty. to Receive";
            GenJnlLine.Validate("Debit Amount", PurchaseLine."Unit Cost" * PurchaseLine."Qty. to Receive");
            GenJnlLine."Bal. Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No." := Contrapartida;
            GenJnlLine.Comment := 'factura parcial de la orden de compra: ' + PurchaseLine."Document No." + ' y albaran: ' + PurchRcptLine."Document No.";
            GenJnlLine.Insert(true);
            //falta generar numero de documento automatico con acciones volver a numerar y agregra validacion para numeros de serie
            //falta poner ejecucion como cuando se registra
        end;

    end;

    local procedure ObtenerCuentaYContrapartida(PurchaseLine: Record "Purchase Line"; var Cuenta: Code[20]; var Contrapartida: Code[20])
    var
        GenPostSetup: Record "General Posting Setup";
        erroMsg: Label 'verifique la configuracion de las cuentas de registro general';
    begin
        GenPostSetup.SetRange("Gen. Bus. Posting Group", PurchaseLine."Gen. Bus. Posting Group");
        GenPostSetup.SetRange("Gen. Prod. Posting Group", PurchaseLine."Gen. Prod. Posting Group");
        if GenPostSetup.FindFirst() then begin
            Cuenta := GenPostSetup."Cta. compra pdtes recibir";
            Contrapartida := GenPostSetup."Cta. facturas pdtes recibir";
        end else
            Error(erroMsg);

    end;

    procedure ValidarConfiguracion(PurchaseLine: Record "Purchase Line")
    var
        erroMsg: Label 'verifique la configuracion de las cuentas de registro general';// si no debe tener, verifique la cuenta de contrapartida de la seccion de libros diario general activada';
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
            // else
            //     if GenJnlBatch."Bal. Account No." <> '' then
            //         status := true;
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