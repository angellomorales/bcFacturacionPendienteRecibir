pageextension 50002 "General Journal Templates ext" extends "General Journal Templates"
{

    trigger OnClosePage()
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        GenPostSetup: Record "General Posting Setup";
    begin
        GenJnlBatch.Reset();
        GenPostSetup.Reset();
        GenPostSetup.SetRange("Activar recibos pdte. fact.", true);
        if GenPostSetup.FindFirst() then begin
            GenJnlBatch.SetRange("Habilitar fact. pdtes recibir", true);
            if GenJnlBatch.FindFirst() then begin
                if GenJnlBatch."No. Series" = '' then
                    if MensajeConfirmacion(ErrorConfNoSerie) then
                        Page.Run(Page::"General Journal Templates");
            end
            else
                if MensajeConfirmacion(ErrorConfSeccionHabilitada) then
                    Page.Run(Page::"General Journal Templates");
        end;
    end;

    local procedure MensajeConfirmacion(ErrorConf: Text[200]): Boolean
    var
        Confirmacion: Boolean;
    begin
        Confirmacion := Confirm(ErrorConf, true);
        exit(Confirmacion);
    end;

    var
        ErrorConfNoSerie: Label 'Recuerde la sección seleccionada debe tener configurado el número de serie \\ Desea continuar con la verificación?';
        ErrorConfSeccionHabilitada: Label 'Recuerde que debe seleccionar una sección y esta debe tener configurado el número de serie \\ Desea continuar con la verificación?';
}