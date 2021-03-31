tableextension 50000 "General Posting Setup ext" extends "General Posting Setup"
{
    fields
    {
        field(50000; "Cta. facturas pdtes recibir"; code[20])
        {
            Caption = 'Cta. facturas pdtes recibir';
            DataClassification = AccountData;
            TableRelation = "G/L Account";
            Editable = true;
        }
        field(50001; "Cta. compra pdtes recibir"; code[20])
        {
            Caption = 'Cta. compra pdtes recibir';
            DataClassification = AccountData;
            TableRelation = "G/L Account";
            Editable = true;
        }
    }


}