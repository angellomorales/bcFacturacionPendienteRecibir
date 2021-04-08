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
                    Caption = 'Función recibos pdtes. facturar activada';
                    ToolTip = 'Especifica si se encuentra activada la función de realizar acientos contables para facturas pendientes de recibir de pedidos ya recibidos. Para activarla dirijase a la opción Libro-Secciones en el apartado Relacionado';
                    ApplicationArea = All;
                    Editable = false;
                }

            }
        }
        addafter("Copy to Posted Jnl. Lines")
        {
            field("Habilitado fact. pdtes recibir"; Rec."Habilitado fact. pdtes recibir")
            {
                ApplicationArea = All;
                ToolTip = 'Especifica si tiene una sección habilitada para realizar acientos contables para facturas pendientes de recibir de pedidos ya recibidos.';
                Editable = false;
            }
        }
    }
    trigger OnOpenPage()
    begin
        validarFuncionActiva();
    end;

    // trigger OnClosePage()
    // begin
    //     if MensajeConfirmacion() then

    // end;

    var
        funcionFactPendRecibirActiva: Boolean;

    procedure validarFuncionActiva()
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        GenJnlTemplate.SetRange("Habilitado fact. pdtes recibir", true);
        CurrPage.Update();
        if GenJnlTemplate.Findfirst() then
            funcionFactPendRecibirActiva := true
        else
            funcionFactPendRecibirActiva := false;
    end;

    local procedure MensajeConfirmacion(): Boolean
    var
        MessageConf: Label 'Tiene la Función recibos pdtes. facturar activada \\ Desea configurar las cuentas contables?';
        Confirmacion: Boolean;
    begin
        Confirmacion := Confirm(MessageConf, true);
        exit(Confirmacion);
    end;
}