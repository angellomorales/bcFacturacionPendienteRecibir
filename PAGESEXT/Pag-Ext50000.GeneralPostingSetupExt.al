pageextension 50000 "General Posting Setup ext" extends "General Posting Setup"
{
    layout
    {
        addafter("Purch. FA Disc. Account")
        {
            field("Cta. facturas pdtes recibir"; Rec."Cta. facturas pdtes recibir")
            {
                ApplicationArea = All;
                ToolTip = 'Especifica el número de la cuenta contable para poder controlar las facturas que están pendientes de recibir de pedidos ya recibidos con esta combinación específica de grupo contable de negocio y grupo contable de producto.';
            }
            field("Cta. compra pdtes recibir"; Rec."Cta. compra pdtes recibir")
            {
                ApplicationArea = All;
                ToolTip = 'Especifica el número de la cuenta contable para registrar transacciones de compra que están pendientes de recibir de pedidos ya recibidos con esta combinación específica de grupo contable de negocio y grupo contable de producto.';
            }
            field("Activar recibos pdte. fact."; Rec."Activar recibos pdte. fact.")
            {
                ApplicationArea = All;
                Caption = ' Activar funcion de registra recibos pendientes por facturar';
                ToolTip = 'Activar funcion registrar facturas pendientes en cuenta contable para la combinación específica de grupo contable de negocio y grupo contable de producto. ';
                trigger OnValidate()
                begin
                    if (Rec."Activar recibos pdte. fact.") then
                        Message(MensajeInicio());
                end;
            }
        }
        addafter(ShowAllAccounts)
        {
            field(funcionFactPendRecibirActiva; funcionFactPendRecibirActiva)
            {
                Caption = 'Función recibos pdtes. facturar activada en sección de libros';
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    trigger OnOpenPage()
    Var
        Header: label 'Active las combinaciones de grupo contable de negocio y grupo contable de producto con las que desea utilizar la función de recibos pdtes. \\';
    begin
        validarFuncionActiva();
        if funcionFactPendRecibirActiva then
            Message(Header + MensajeInicio());
    end;

    trigger OnClosePage()
    var
        AlertaConfSeccionesLibro: Label 'Recuerde que debe seleccionar la plantilla y la sección que se utilizará para realizar el asiento contable, esta debe tener configurado el número de serie';
        ErrorConf: Label 'Verifique la configuracion de las cuentas con la funcion activada \\1. Activar la casilla de la combinación deseada \\ 2. Cambiar Cta. compras \\ 3. Cta. facturas pdtes recibir \\ 4. Cta. compra pdtes recibir \\ Desea continuar con la verificación?';
        Confirmacion: Boolean;
        GenPostSetup: Record "General Posting Setup";
    begin
        if not ConfiguracionFuncionActivaEsOk() then begin
            Confirmacion := Confirm(ErrorConf, true);
            if Confirmacion then
                Page.Run(Page::"General Posting Setup")
        end;
    end;

    local procedure ConfiguracionFuncionActivaEsOk(): Boolean
    var
        Ok: Boolean;
        GenPostSetup: Record "General Posting Setup";
    begin
        Ok := true;
        if funcionFactPendRecibirActiva then
            Ok := false;
        GenPostSetup.Reset();
        GenPostSetup.SetRange("Activar recibos pdte. fact.", true);
        if GenPostSetup.FindSet() then
            repeat
                if (GenPostSetup."Purch. Account" = '')
                or (GenPostSetup."Cta. compra pdtes recibir" = '')
                or (GenPostSetup."Cta. facturas pdtes recibir" = '')
                then begin
                    Ok := false;
                    exit(Ok);
                end
                else
                    Ok := true;
            until GenPostSetup.Next() = 0;
        exit(Ok);
    end;

    local procedure validarFuncionActiva()
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        GenJnlTemplate.Reset();
        GenJnlTemplate.SetRange("Habilitado fact. pdtes recibir", true);
        CurrPage.Update();
        if GenJnlTemplate.FindFirst() then
            funcionFactPendRecibirActiva := true
        else
            funcionFactPendRecibirActiva := false;

    end;

    local procedure MensajeInicio(): Text[400]
    var
        AlertaConfCtaCompras: Label 'Debe Cambiar la Cta. compras como la cuenta que va a acentar los recibos pendientes por facturar \\';
        AlertaConfCtaFactPendRecibir: Label 'Debe configurar Cta. facturas pdtes recibir como la cuenta que va a acentar los recibos pendientes por facturar \\';
        AlertaConfCtaComprasPendRecibir: Label 'Debe configurar Cta. compra pdtes recibir como la cuenta que va a acentar la contrapartida de los recibos pendientes por facturar \';
    begin
        exit(AlertaConfCtaCompras + AlertaConfCtaFactPendRecibir + AlertaConfCtaComprasPendRecibir);
    end;

    var
        funcionFactPendRecibirActiva: Boolean;
}