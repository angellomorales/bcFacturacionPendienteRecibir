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
            }
        }
    }

}