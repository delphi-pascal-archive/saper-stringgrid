program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
