pageextension 50002 "General Journal Templates ext" extends "General Journal Templates"
{
    layout
    {
        addbefore(Control1)
        {
            group("habilitar funcion")
            {
                ShowCaption = false;
                field(funcionFactPendRecibirActiva; funcionFactPendRecibirActiva)
                {
                    Caption = 'Función FPR activada';
                    ToolTip = 'Especifica si se encuentra activada la función de realizar acientos contables para facturas pendientes de recibir de pedidos ya recibidos. Para activarla dirijase a la opción Libro-Secciones en el apartado Relacionado';
                    ApplicationArea = All;
                    Editable = false;
                    visible = false;
                }

            }
        }
        addafter("Copy to Posted Jnl. Lines")
        {
            field("FPR Activado"; Rec."FPR Activado")
            {
                ApplicationArea = All;
                ToolTip = 'Especifica si función esta habilitada para realizar acientos contables para facturas pendientes de recibir de pedidos ya recibidos en la seccion señalada.';
                Editable = false;
                Visible = false;
            }
        }
    }
    trigger OnOpenPage()
    begin
        validarFuncionActiva();
    end;

    trigger OnClosePage()
    begin
        AbrirConfigCuentas();
    end;

    var
        funcionFactPendRecibirActiva: Boolean;

    procedure validarFuncionActiva()
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        GenJnlTemplate.SetRange("FPR Activado", true);
        CurrPage.Update();
        if GenJnlTemplate.Findfirst() then
            funcionFactPendRecibirActiva := true
        else
            funcionFactPendRecibirActiva := false;
    end;

    procedure AbrirConfigCuentas()
    var
        MessageConf: Label 'Tiene la Función recibos pdtes. facturar activada \\ Desea configurar las cuentas contables?';
        Confirmacion: Boolean;
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        GenJnlTemplate.Reset();
        GenJnlTemplate.SetRange("FPR Activado", true);
        if GenJnlTemplate.FindFirst() then begin
            Confirmacion := Confirm(MessageConf, true);
            if Confirmacion then
                Page.Run(Page::"General Posting Setup");
        end;
    end;
}