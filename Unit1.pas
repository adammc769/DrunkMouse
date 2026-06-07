unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls, System.Math;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    TrackBar1: TTrackBar;
    BtnStart: TButton;
    TimerMyszka: TTimer;
    TimerKomunikaty: TTimer;
    TimerTryby: TTimer;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure BtnStartClick(Sender: TObject);
    procedure TimerMyszkaTimer(Sender: TObject);
    procedure TimerKomunikatyTimer(Sender: TObject);
    procedure TimerTrybyTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    Aktywne: Boolean;
    AktualnyTryb: Integer;
    LicznikCzasu: Integer;
    LicznikTrafien: Integer; // Zmienna zliczaj¹ca punkty gracza

    procedure PokazLosowyKomunikat;
    procedure WMHotKey(var Msg: TWMHotKey); message WM_HOTKEY;
  public
    { Public declarations }
    procedure LosujNowyCel;
    procedure ZarejestrujTrafienie; // Nowa procedura obs³uguj¹ca trafienie
    procedure WylaczPrank;
  end;

var
  Form1: TForm1;

implementation

uses Unit2;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  RegisterHotKey(Handle, 1, MOD_ALT, $4D); // Alt + M dzia³a awaryjnie
  Randomize;
  Aktywne := False;
  AktualnyTryb := 0;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  UnregisterHotKey(Handle, 1);
end;

procedure TForm1.WMHotKey(var Msg: TWMHotKey);
begin
  if Msg.HotKey = 1 then
  begin
    WylaczPrank;
    ShowMessage('Trening przerwany kodem Alt+M!');
  end;
end;

procedure TForm1.WylaczPrank;
begin
  TimerMyszka.Enabled := False;
  TimerKomunikaty.Enabled := False;
  TimerTryby.Enabled := False;
  Aktywne := False;

  if Assigned(FormCel) then
    FormCel.Hide;

  Form1.Show;
  BtnStart.Caption := 'Uruchom prank';
end;

// START GRY
procedure TForm1.BtnStartClick(Sender: TObject);
begin
  Aktywne := not Aktywne;

  TimerMyszka.Enabled := Aktywne;
  TimerKomunikaty.Enabled := Aktywne;
  TimerTryby.Enabled := Aktywne;

  if Aktywne then
  begin
    BtnStart.Caption := 'Stop';
    AktualnyTryb := 0;
    LicznikCzasu := 0;
    LicznikTrafien := 0; // Resetujemy punkty przy starcie

    Form1.Hide;
    LosujNowyCel;
    PokazLosowyKomunikat;
  end
  else
  begin
    WylaczPrank;
  end;
end;

// ROZGRYWKA: REJESTRACJA TRAFIENIA
procedure TForm1.ZarejestrujTrafienie;
begin
  Inc(LicznikTrafien); // Zwiêkszamy licznik o 1

  if LicznikTrafien >= 10 then
  begin
    // Jeœli gracz uzbiera³ 10 trafieñ - WYGRYWA
    WylaczPrank;
    ShowMessage('NIESAMOWITE! Trafi³eœ 10 razy i pokona³eœ DrunkMouse!');
  end
  else
  begin
    // Jeœli ma mniej ni¿ 10, okienko natychmiast ucieka w nowe miejsce
    LosujNowyCel;
  end;
end;

// TELEPORTACJA CZERWONEGO OKIENKA
procedure TForm1.LosujNowyCel;
var
  MaxX, MaxY: Integer;
  NowyX, NowyY: Integer;
begin
  if Assigned(FormCel) then
  begin
    MaxX := Screen.Width;
    MaxY := Screen.Height;

    NowyX := Random(MaxX - FormCel.Width);
    NowyY := Random(MaxY - FormCel.Height);

    FormCel.Left := NowyX;
    FormCel.Top := NowyY;

    // Aktualizujemy tekst na czerwonym okienku, ¿eby gracz widzia³ postêp
    FormCel.LabelCel.Caption := Format('TRAFIENIA: %d / 10'#13'WejdŸ tu myszk¹!', [LicznikTrafien]);

    FormCel.Show;
  end;
end;

// ZMIANA TRYBÓW CO 10 SEKUND (I AUTOUCIECZKA JEŒLI GRACZ JEST ZA WOLNY)
procedure TForm1.TimerTrybyTimer(Sender: TObject);
begin
  AktualnyTryb := Random(5);
  LosujNowyCel; // Jeœli gracz nie trafi³ przez 10 sekund, okienko ucieka samo!
end;

// 5 TRYBÓW DRGANIA MYSZKI
procedure TForm1.TimerMyszkaTimer(Sender: TObject);
var
  Punkt: TPoint;
  Zasieg, Polowa: Integer;
begin
  GetCursorPos(Punkt);
  Zasieg := TrackBar1.Position;
  if Zasieg < 2 then Zasieg := 2;
  Polowa := Zasieg div 2;

  Inc(LicznikCzasu);

  case AktualnyTryb of
    0: // TRYB 0: Lekki stres
    begin
      Punkt.X := Punkt.X + Random(Zasieg) - Polowa;
      Punkt.Y := Punkt.Y + Random(Zasieg) - Polowa;
    end;
    1: // TRYB 1: Fala
    begin
      Punkt.X := Punkt.X + Round(Sin(LicznikCzasu / 5) * Polowa);
      Punkt.Y := Punkt.Y + Random(3) - 1;
    end;
    2: // TRYB 2: Teleportacja myszki
    begin
      if Random(20) = 5 then
      begin
        Punkt.X := Punkt.X + Random(120) - 60;
        Punkt.Y := Punkt.Y + Random(120) - 60;
      end
      else
      begin
        Punkt.X := Punkt.X + Random(6) - 3;
        Punkt.Y := Punkt.Y + Random(6) - 3;
      end;
    end;
    3: // TRYB 3: Grawitacja w dó³
    begin
      Punkt.X := Punkt.X + Random(Zasieg) - Polowa;
      Punkt.Y := Punkt.Y + Random(Zasieg) - Polowa + 3;
    end;
    4: // TRYB 4: Ca³kowity chaos
    begin
      Punkt.X := Punkt.X + Random(Zasieg * 2) - Zasieg;
      Punkt.Y := Punkt.Y + Random(Zasieg * 2) - Zasieg;
    end;
  end;

  SetCursorPos(Punkt.X, Punkt.Y);
end;

// SYSTEM KOMUNIKATÓW
procedure TForm1.PokazLosowyKomunikat;
var
  Los: Integer;
  Komunikat: string;
begin
  Los := Random(7);
  case Los of
    0: Komunikat := 'Twoja myszka jest za zimna. Zalecane jest w³o¿enie jej do gor¹cej wody na 10 minut.';
    1: Komunikat := 'Wykryto zbyt szybkie machanie myszk¹. Zwolnij, kursor musi odpocz¹æ.';
    2: Komunikat := 'Kursor zgubi³ drogê. Proszê dmuchaæ w sensor optyczny, aby go naprowadziæ.';
    3: Komunikat := 'UWAGA: Poziom p³ynu w podk³adce pod mysz spad³ poni¿ej krytycznego poziomu!';
    4: Komunikat := 'System wykry³, ¿e patrzysz na monitor zbyt podejrzliwie. Zmieñ wyraz twarzy.';
    5: Komunikat := 'WskaŸnik myszy uciek³ na inny ekran. Proszê czekaæ, a¿ wróci pieszo.';
    6: Komunikat := 'B³¹d grawitacji kursora. Za chwilê myszka zacznie spadaæ w dó³ ekranu.';
  end;
  Winapi.Windows.MessageBox(0, PChar(Komunikat), 'DrunkMouse System Warning', MB_OK or MB_ICONWARNING or MB_TASKMODAL or MB_SETFOREGROUND);
end;

procedure TForm1.TimerKomunikatyTimer(Sender: TObject);
begin
  PokazLosowyKomunikat;
end;

end.
