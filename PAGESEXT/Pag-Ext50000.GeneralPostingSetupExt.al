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
        }
    }

}