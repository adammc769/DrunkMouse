unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormCel = class(TForm)
    LabelCel: TLabel; // Upewnij siê, ¿e Twój TLabel nazywa siê LabelCel lub zmieñ nazwê w kodzie
    procedure FormMouseEnter(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCel: TFormCel;

implementation

// £¹czymy z g³ówn¹ form¹, ¿eby mieæ dostêp do jej funkcji
uses Unit1;

{$R *.dfm}

procedure TFormCel.FormMouseEnter(Sender: TObject);
begin
  // Gdy kursor wjedzie w okienko, przekazujemy informacjê do Unit1
  if Form1.TimerMyszka.Enabled then
  begin
    Form1.ZarejestrujTrafienie;
  end;
end;

end.
