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
                    GenJnlTemplate: Record "Gen. Journal Template";
                begin
                    //validacion para que solo sea un campo chequeado
                    GenJnlBatch.Reset();
                    GenJnlBatch.SetFilter("Journal Template Name", '<>%1', Rec."Journal Template Name");
                    GenJnlBatch.SetRange("Habilitar fact. pdtes recibir", true);
                    if GenJnlBatch.FindFirst() then
                        Error(Errortxt)
                    else begin
                        GenJnlBatch.Reset();
                        GenJnlBatch.SetFilter(Name, '<>%1', Rec.Name);
                        GenJnlBatch.SetRange("Habilitar fact. pdtes recibir", true);
                        if GenJnlBatch.FindFirst() then
                            Error(Errortxt);
                    end;
                    if Rec."Habilitar fact. pdtes recibir" = true then
                        if rec."No. Series" = '' then begin
                            MensajeConfirmacion();
                            Rec."Habilitar fact. pdtes recibir" := false;
                        end;
                    GenJnlTemplate.Reset();
                    GenJnlTemplate.Get(Rec."Journal Template Name");
                    GenJnlTemplate."Habilitado fact. pdtes recibir" := Rec."Habilitar fact. pdtes recibir";
                    GenJnlTemplate.Modify();
                end;
            }
        }
    }

    local procedure MensajeConfirmacion(): Boolean
    var
        ErrorConf: Label 'Recuerde la sección seleccionada debe tener configurado el número de serie \\ Desea continuar con la verificación?';
        Confirmacion: Boolean;
    begin
        Confirmacion := Confirm(ErrorConf, true);
        exit(Confirmacion);
    end;

}