codeunit 50000 "Gestion Orden de Compra"
{
    trigger OnRun()
    var
        MyMessage: Label 'App published: Hello world mine';
    begin
        Message(MyMessage);
    end;
}