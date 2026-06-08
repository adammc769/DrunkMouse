program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {FormCel},
  Vcl.Themes,
  Vcl.Styles,
  Unit3 in 'Unit3.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Glow');
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormCel, FormCel);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
