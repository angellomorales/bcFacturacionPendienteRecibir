tableextension 50001 "Gen. Journal Batch ext" extends "Gen. Journal Batch"
{
    fields
    {
        field(50000; "Activar FPR"; Boolean)
        {
            Caption = 'Habilitar para fact. pdtes recibir';
            DataClassification = ToBeClassified;
        }
    }


}