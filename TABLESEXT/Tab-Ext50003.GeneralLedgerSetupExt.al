tableextension 50003 "General Ledger Setup ext" extends "General Ledger Setup"
{
    fields
    {
        field(50000; "Activar FPR"; Boolean)
        {
            Caption = 'Habilitar Funcion FPR';
            DataClassification = ToBeClassified;
        }
    }

}