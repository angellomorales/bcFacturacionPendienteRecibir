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
            if PurchaseLine."Qty. to Receive" > 0 then
                InsertarLinea(PurchaseLine, PurchRcptLine);
    end;

    local procedure InsertarLinea(PurchaseLine: Record "Purchase Line"; PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Cuenta: Code[20];
        Contrapartida: Code[20];
        Numdoc: Code[20];
    begin
        GenJnlBatch.SetRange("Activar FPR", true);
        if GenJnlBatch.FindFirst() then begin
            if not validarCuentaActiva(PurchaseLine) then
                exit;
            EliminarDiario(GenJnlBatch);
            ObtenerCuentaYContrapartida(PurchaseLine, Cuenta, Contrapartida);
            GenJnlLine.Init();
            GenJnlLine."Posting Date" := WorkDate();
            GenJnlLine."Journal Template Name" := GenJnlBatch."Journal Template Name";
            GenJnlLine."Journal Batch Name" := GenJnlBatch.Name;
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := Cuenta;
            GenJnlLine.Validate("Debit Amount", PurchaseLine."Unit Cost" * PurchaseLine."Qty. to Receive");
            GenJnlLine."Bal. Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No." := Contrapartida;
            GenJnlLine.Comment := 'factura parcial de la orden de compra: ' + PurchaseLine."Document No." + ' y albaran: ' + PurchRcptLine."Document No.";
            GenJnlLine.Insert(true);
            Numdoc := NoSeriesMgt.DoGetNextNo(GenJnlBatch."No. Series", GenJnlLine."Posting Date", true, false);
            GenJnlLine.Validate("Document No.", Numdoc);
            GenJnlLine.Modify(true);
            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Batch", GenJnlLine);
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
    begin
        if (PurchaseLine.Type = PurchaseLine.Type::Item)
        or (PurchaseLine.Type = PurchaseLine.Type::Resource)
        then
            ValidarConfiguracionCuentas(PurchaseLine);

    end;

    local procedure ValidarConfiguracionCuentas(PurchaseLine: Record "Purchase Line"): Boolean
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        status: Boolean;
        erroMsg: Label 'verifique que en la configuracion de las cuentas de registro general tenga las cuentas debidamente asignadas';// si no debe tener, verifique la cuenta de contrapartida de la seccion de libros diario general activada';
        erroMsg1: Label 'verifique la seccion de libros diario general activa tenga No Serie';
        erroMsg2: Label 'verifique que se encuentra seleccionada la casilla Habilitar para fact. pdtes recibir en las seccion de libros diario general';
    begin
        status := false;
        GenJnlBatch.SetRange("Activar FPR", true);
        if GenJnlBatch.FindFirst() then begin
            if GenJnlBatch."No. Series" <> '' then begin
                if ValidarConfiguracionCuentasRegistroGeneral(PurchaseLine) then
                    status := true
                else
                    Error(erroMsg);
            end
            else
                Error(erroMsg1);
        end;
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
            if GenPostSetup."Activar FPR" = true then begin
                if (GenPostSetup."Purch. Account" <> '')
                and (GenPostSetup."Cta. compra pdtes recibir" <> '')
                and (GenPostSetup."Cta. facturas pdtes recibir" <> '')
                then
                    status := true;
            end
            else
                status := true;
        exit(status);
    end;

    local procedure validarCuentaActiva(PurchaseLine: Record "Purchase Line"): Boolean
    var
        GenPostSetup: Record "General Posting Setup";
        status: Boolean;
    begin
        status := false;
        GenPostSetup.SetRange("Gen. Bus. Posting Group", PurchaseLine."Gen. Bus. Posting Group");
        GenPostSetup.SetRange("Gen. Prod. Posting Group", PurchaseLine."Gen. Prod. Posting Group");
        if GenPostSetup.FindFirst() then
            if GenPostSetup."Activar FPR" = true then
                status := true;
        exit(status);
    end;

    procedure ValidarNoFacturaUnica(PurchHeader: Record "Purchase Header")
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
        erroMsg: Label 'Ya existe la compra %1 %2 para este proveedor.', Comment = '%1 = Document Type; %2 = Document No.';
    begin
        if PurchHeader."Vendor Invoice No." <> '' then
            if PurchHeader.FindPostedDocumentWithSameExternalDocNo(VendLedgEntry, PurchHeader."Vendor Invoice No.") then
                Error(erroMsg, VendLedgEntry."Document Type", VendLedgEntry."External Document No.");
    end;

    local procedure EliminarDiario(GenJnlBatch: Record "Gen. Journal Batch"): Boolean
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.SetRange("Journal Template Name", GenJnlBatch."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", GenJnlBatch.Name);
        GenJnlLine.DeleteAll();
    end;

    procedure PermitirCambiarConfiguracion(Rec: Boolean; MessageActivacion: Text[300])
    var
        PurchLine: Record "Purchase Line";
        Errortxt: label 'No se puede realizar cambios de configuración ya que el pedido %1 se encuentra recibido y pendiente de facturar';
    begin
        PurchLine.SetFilter("Quantity Received", '>0');
        if PurchLine.FindSet() then
            repeat
                if PurchLine."Quantity Received" <> PurchLine."Quantity Invoiced" then begin
                    Error(Errortxt, PurchLine."Document No.");
                    exit;
                end;
            until PurchLine.Next() = 0;
        if Rec then
            Message(MessageActivacion);
    end;
}