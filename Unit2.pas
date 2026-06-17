unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormCel = class(TForm)
    LabelCel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseEnter(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCel: TFormCel;

implementation

uses
  Unit1;

{$R *.dfm}

procedure TFormCel.FormCreate(Sender: TObject);
begin
  OnMouseEnter := FormMouseEnter;
  OnClick := FormMouseEnter;
  LabelCel.OnMouseEnter := FormMouseEnter;
  LabelCel.OnClick := FormMouseEnter;
end;

procedure TFormCel.FormMouseEnter(Sender: TObject);
begin
  if Assigned(Form1) and Form1.TimerMyszka.Enabled then
    Form1.ZarejestrujTrafienie;
end;

end.
