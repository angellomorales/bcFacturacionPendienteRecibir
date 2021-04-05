pageextension 50001 "General Journal Batches ext" extends "General Journal Batches"
{
    layout
    {
        addafter("Copy to Posted Jnl. Lines")
        {
            field("Habilitar para fact. pdtes recibir"; Rec."Habilitar fact. pdtes recibir")
            {
                ApplicationArea = All;
                ToolTip = 'Especifica si la seccion de diario seleccionada se utilizara como seccion para realizar acientos contables para facturas pendientes de recibir de pedidos ya recibidos.';
                trigger OnValidate()
                var
                    Errortxt: label 'Solo puede existir una seccion habilitada para facturas pendientes';
                    GenJnlBatch: Record "Gen. Journal Batch";
                begin
                    GenJnlBatch.Reset();
                    GenJnlBatch.SetFilter("Journal Template Name", '<>%1', Rec."Journal Template Name");
                    GenJnlBatch.SetRange("Habilitar fact. pdtes recibir");
                    if GenJnlBatch.FindFirst() then
                        Error(Errortxt)
                    else begin
                        GenJnlBatch.Reset();
                        GenJnlBatch.SetFilter(Name, '<>%1', Rec.Name);
                        GenJnlBatch.SetRange("Habilitar fact. pdtes recibir");
                        if GenJnlBatch.FindFirst() then
                            Error(Errortxt);
                    end;
                end;
            }
        }
    }

}