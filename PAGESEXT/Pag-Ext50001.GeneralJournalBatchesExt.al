pageextension 50001 "General Journal Batches ext" extends "General Journal Batches"
{
    layout
    {
        addafter("Copy to Posted Jnl. Lines")
        {
            field("Activar FPR"; Rec."Activar FPR")
            {
                ApplicationArea = All;
                Caption = 'Activar Función FPR para esta sección';
                ToolTip = 'Especifica si la seccion de diario seleccionada se utilizara como seccion para realizar acientos contables para facturas pendientes de recibir de pedidos ya recibidos.';
                trigger OnValidate()
                var
                    Errortxt: label 'Solo puede existir una seccion habilitada para facturas pendientes';
                    MessageActivacion: label 'Recuerde que debe activar la funcion FPR en la configuración de contabilidad';
                    GenJnlBatch: Record "Gen. Journal Batch";
                    GenJnlTemplate: Record "Gen. Journal Template";
                    GenPagTemplate: Page "General Journal Templates";
                    GestionOrdenCompra: Codeunit "Gestion Orden de Compra";
                begin
                    //validacion para que solo sea un campo chequeado
                    GenJnlBatch.Reset();
                    GenJnlBatch.SetFilter("Journal Template Name", '<>%1', Rec."Journal Template Name");
                    GenJnlBatch.SetRange("Activar FPR", true);
                    if GenJnlBatch.FindFirst() then
                        Error(Errortxt)
                    else begin
                        GenJnlBatch.Reset();
                        GenJnlBatch.SetFilter(Name, '<>%1', Rec.Name);
                        GenJnlBatch.SetRange("Activar FPR", true);
                        if GenJnlBatch.FindFirst() then
                            Error(Errortxt);
                    end;
                    if Rec."Activar FPR" = true then
                        if rec."No. Series" = '' then begin
                            MensajeConfirmacion();
                            Rec."Activar FPR" := false;
                        end;
                    GestionOrdenCompra.PermitirCambiarConfiguracion(rec."Activar FPR", MessageActivacion);
                    GenJnlTemplate.Reset();
                    GenJnlTemplate.Get(Rec."Journal Template Name");
                    GenJnlTemplate."FPR Activado" := Rec."Activar FPR";
                    GenJnlTemplate.Modify(true);
                    if Rec."Activar FPR" = true then
                        GenPagTemplate.AbrirConfigCuentas();
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