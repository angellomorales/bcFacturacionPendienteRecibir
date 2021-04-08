pageextension 50002 "General Journal Templates ext" extends "General Journal Templates"
{
    layout
    {
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

}