pageextension 50003 "General Ledger Setup ext" extends "General Ledger Setup"
{
    layout
    {
        addafter("Payment Discount Grace Period")
        {
            field("Activar FPR"; Rec."Activar FPR")
            {
                ApplicationArea = All;
                ToolTip = 'Especifica si desea activar la función para realizar acientos contables para facturas pendientes de recibir de pedidos ya recibidos.';
                trigger OnValidate()
                var
                    GestionOrdenCompra: Codeunit "Gestion Orden de Compra";
                    MessageActivacion: label 'Recuerde activar la sección del libro que va a utilizar para realizar los registros';
                begin
                    GestionOrdenCompra.PermitirCambiarConfiguracion(rec."Activar FPR", MessageActivacion);
                end;
            }
        }
    }

}