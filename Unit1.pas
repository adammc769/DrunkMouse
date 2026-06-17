unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Math, System.Types, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls, Unit3;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    LblCzulosc: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    LabelPoziom: TLabel;
    LblStatus: TLabel;
    LblWynik: TLabel;
    LblTryb: TLabel;
    LblCzas: TLabel;
    LblHotkey: TLabel;
    TrackBar1: TTrackBar;
    BtnStart: TButton;
    CmbPoziom: TComboBox;
    ChkKomunikaty: TCheckBox;
    ChkZmieniajTryby: TCheckBox;
    Info: TButton;
    TimerMyszka: TTimer;
    TimerKomunikaty: TTimer;
    TimerTryby: TTimer;
    TimerCzas: TTimer;
    procedure BtnStartClick(Sender: TObject);
    procedure TimerMyszkaTimer(Sender: TObject);
    procedure TimerKomunikatyTimer(Sender: TObject);
    procedure TimerTrybyTimer(Sender: TObject);
    procedure TimerCzasTimer(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure CmbPoziomChange(Sender: TObject);
    procedure ChkKomunikatyClick(Sender: TObject);
    procedure ChkZmieniajTrybyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure InfoClick(Sender: TObject);
  private
    Aktywne: Boolean;
    AktualnyTryb: Integer;
    LicznikCzasu: Integer;
    LicznikTrafien: Integer;
    WymaganaLiczbaTrafien: Integer;
    SzerokoscCelu: Integer;
    WysokoscCelu: Integer;
    StartTick: Cardinal;

    function CzasGrySekundy: Cardinal;
    function NazwaTrybu: string;
    procedure AktualizujPanelStatusu;
    procedure PokazLosowyKomunikat;
    procedure ZastosujPoziomTrudnosci;
    procedure PrzygotujOknoCelu;
    procedure WMHotKey(var Msg: TWMHotKey); message WM_HOTKEY;
  public
    procedure LosujNowyCel;
    procedure ZarejestrujTrafienie;
    procedure WylaczPrank;
  end;

var
  Form1: TForm1;

implementation

uses
  Unit2;

{$R *.dfm}

const
  LICZBA_TRYBOW = 14;

procedure TForm1.FormCreate(Sender: TObject);
begin
  RegisterHotKey(Handle, 1, MOD_ALT, $4D); // Alt+M awaryjnie zatrzymuje trening.
  Randomize;

  Aktywne := False;
  AktualnyTryb := 0;
  LicznikCzasu := 0;
  LicznikTrafien := 0;
  StartTick := 0;

  if CmbPoziom.Items.Count = 0 then
  begin
    CmbPoziom.Items.Add('Rozgrzewka');
    CmbPoziom.Items.Add('Normalny');
    CmbPoziom.Items.Add('Chaos');
    CmbPoziom.Items.Add('Legenda');
  end;

  CmbPoziom.ItemIndex := 1;
  ChkKomunikaty.Checked := True;
  ChkZmieniajTryby.Checked := True;

  ZastosujPoziomTrudnosci;
  AktualizujPanelStatusu;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  UnregisterHotKey(Handle, 1);
end;

procedure TForm1.InfoClick(Sender: TObject);
begin
  Form3.Show;
  Form3.BringToFront;
end;

procedure TForm1.WMHotKey(var Msg: TWMHotKey);
begin
  if (Msg.HotKey = 1) and Aktywne then
  begin
    WylaczPrank;
    ShowMessage('Trening przerwany skrótem Alt+M.');
  end;
end;

function TForm1.CzasGrySekundy: Cardinal;
begin
  Result := 0;
  if Aktywne and (StartTick <> 0) then
    Result := (GetTickCount - StartTick) div 1000;
end;

function TForm1.NazwaTrybu: string;
begin
  case AktualnyTryb of
    0: Result := 'Lekki stres';
    1: Result := 'Fala';
    2: Result := 'Teleportacja';
    3: Result := 'Grawitacja';
    4: Result := 'Chaos';
    5: Result := 'Karuzela';
    6: Result := 'Ślizg';
    7: Result := 'Cel odpycha';
    8: Result := 'Sprężyna';
    9: Result := 'Boczny wiatr';
    10: Result := 'Schody';
    11: Result := 'Zygzak';
    12: Result := 'Turbulencje';
    13: Result := 'Leniwy magnes';
  else
    Result := 'Nieznany';
  end;
end;

procedure TForm1.AktualizujPanelStatusu;
var
  Sekundy: Cardinal;
begin
  LblCzulosc.Caption := Format('Czułość drgania: %d', [TrackBar1.Position]);

  if Aktywne then
    LblStatus.Caption := 'Status: trwa trening'
  else
    LblStatus.Caption := 'Status: gotowy';

  LblWynik.Caption := Format('Trafienia: %d / %d', [LicznikTrafien, WymaganaLiczbaTrafien]);
  LblTryb.Caption := 'Tryb: ' + NazwaTrybu;

  Sekundy := CzasGrySekundy;
  LblCzas.Caption := Format('Czas: %.2d:%.2d', [Sekundy div 60, Sekundy mod 60]);
end;

procedure TForm1.ZastosujPoziomTrudnosci;
begin
  if CmbPoziom.ItemIndex < 0 then
    CmbPoziom.ItemIndex := 1;

  case CmbPoziom.ItemIndex of
    0:
      begin
        WymaganaLiczbaTrafien := 5;
        SzerokoscCelu := 520;
        WysokoscCelu := 300;
        TrackBar1.Position := 18;
        TimerMyszka.Interval := 16;
        TimerKomunikaty.Interval := 60000;
        TimerTryby.Interval := 15000;
      end;
    1:
      begin
        WymaganaLiczbaTrafien := 10;
        SzerokoscCelu := 430;
        WysokoscCelu := 250;
        TrackBar1.Position := 35;
        TimerMyszka.Interval := 8;
        TimerKomunikaty.Interval := 45000;
        TimerTryby.Interval := 10000;
      end;
    2:
      begin
        WymaganaLiczbaTrafien := 15;
        SzerokoscCelu := 320;
        WysokoscCelu := 200;
        TrackBar1.Position := 75;
        TimerMyszka.Interval := 3;
        TimerKomunikaty.Interval := 30000;
        TimerTryby.Interval := 7000;
      end;
  else
    begin
      WymaganaLiczbaTrafien := 20;
      SzerokoscCelu := 240;
      WysokoscCelu := 160;
      TrackBar1.Position := 115;
      TimerMyszka.Interval := 1;
      TimerKomunikaty.Interval := 20000;
      TimerTryby.Interval := 5000;
    end;
  end;
end;

procedure TForm1.PrzygotujOknoCelu;
begin
  if not Assigned(FormCel) then
    Exit;

  FormCel.LabelCel.AutoSize := False;
  FormCel.LabelCel.SetBounds(0, 0, FormCel.ClientWidth, FormCel.ClientHeight);
  FormCel.LabelCel.Alignment := taCenter;
  FormCel.LabelCel.Layout := tlCenter;
  FormCel.LabelCel.WordWrap := True;
  FormCel.LabelCel.Transparent := True;
  FormCel.LabelCel.Font.Color := clWhite;
  FormCel.LabelCel.Font.Height := -18;
  FormCel.LabelCel.Font.Style := [fsBold];
end;

procedure TForm1.WylaczPrank;
begin
  TimerMyszka.Enabled := False;
  TimerKomunikaty.Enabled := False;
  TimerTryby.Enabled := False;
  TimerCzas.Enabled := False;
  Aktywne := False;

  if Assigned(FormCel) then
    FormCel.Hide;

  Show;
  BringToFront;
  BtnStart.Caption := 'Start treningu';
  CmbPoziom.Enabled := True;
  AktualizujPanelStatusu;
end;

procedure TForm1.BtnStartClick(Sender: TObject);
begin
  if Aktywne then
  begin
    WylaczPrank;
    Exit;
  end;

  Aktywne := True;
  AktualnyTryb := Random(LICZBA_TRYBOW);
  LicznikCzasu := 0;
  LicznikTrafien := 0;
  StartTick := GetTickCount;

  BtnStart.Caption := 'Stop';
  CmbPoziom.Enabled := False;
  TimerMyszka.Enabled := True;
  TimerKomunikaty.Enabled := ChkKomunikaty.Checked;
  TimerTryby.Enabled := ChkZmieniajTryby.Checked;
  TimerCzas.Enabled := True;

  AktualizujPanelStatusu;
  BringToFront;
  LosujNowyCel;

  if ChkKomunikaty.Checked then
    PokazLosowyKomunikat;
end;

procedure TForm1.ZarejestrujTrafienie;
var
  Sekundy: Cardinal;
begin
  if not Aktywne then
    Exit;

  Inc(LicznikTrafien);
  AktualizujPanelStatusu;

  if LicznikTrafien >= WymaganaLiczbaTrafien then
  begin
    Sekundy := CzasGrySekundy;
    WylaczPrank;
    ShowMessage(Format('Udało się! Trafienia: %d / %d. Czas: %.2d:%.2d.',
      [LicznikTrafien, WymaganaLiczbaTrafien, Sekundy div 60, Sekundy mod 60]));
  end
  else
    LosujNowyCel;
end;

procedure TForm1.LosujNowyCel;
var
  Desktop: TRect;
  AvailableX, AvailableY: Integer;
  NewX, NewY: Integer;
  CursorPos: TPoint;
  Attempt: Integer;
  TooClose: Boolean;
begin
  if not Assigned(FormCel) then
    Exit;

  Desktop := Screen.DesktopRect;
  FormCel.Width := Min(SzerokoscCelu, Max(160, Desktop.Right - Desktop.Left));
  FormCel.Height := Min(WysokoscCelu, Max(120, Desktop.Bottom - Desktop.Top));
  PrzygotujOknoCelu;

  AvailableX := Max(0, (Desktop.Right - Desktop.Left) - FormCel.Width);
  AvailableY := Max(0, (Desktop.Bottom - Desktop.Top) - FormCel.Height);
  GetCursorPos(CursorPos);

  NewX := Desktop.Left;
  NewY := Desktop.Top;

  for Attempt := 0 to 15 do
  begin
    NewX := Desktop.Left + Random(AvailableX + 1);
    NewY := Desktop.Top + Random(AvailableY + 1);
    TooClose :=
      (CursorPos.X >= NewX - 60) and
      (CursorPos.X <= NewX + FormCel.Width + 60) and
      (CursorPos.Y >= NewY - 60) and
      (CursorPos.Y <= NewY + FormCel.Height + 60);

    if not TooClose then
      Break;
  end;

  FormCel.Left := NewX;
  FormCel.Top := NewY;
  FormCel.Color := RGB(180 + Random(60), 25 + Random(90), 35 + Random(90));
  FormCel.LabelCel.Caption := Format('TRAFIENIA: %d / %d'#13#10'TRYB: %s'#13#10'Wejdź myszką w pole',
    [LicznikTrafien, WymaganaLiczbaTrafien, NazwaTrybu]);
  FormCel.Show;
  FormCel.BringToFront;
end;

procedure TForm1.TimerTrybyTimer(Sender: TObject);
begin
  if not Aktywne then
    Exit;

  AktualnyTryb := Random(LICZBA_TRYBOW);
  LosujNowyCel;
  AktualizujPanelStatusu;
end;

procedure TForm1.TimerMyszkaTimer(Sender: TObject);
var
  Punkt: TPoint;
  Desktop: TRect;
  Zasieg, Polowa: Integer;
  CenterX, CenterY: Integer;
  NudgeX, NudgeY: Integer;
begin
  if not Aktywne then
    Exit;

  GetCursorPos(Punkt);
  Desktop := Screen.DesktopRect;
  Zasieg := TrackBar1.Position;
  if Zasieg < 2 then
    Zasieg := 2;
  Polowa := Zasieg div 2;

  Inc(LicznikCzasu);

  case AktualnyTryb of
    0:
      begin
        Punkt.X := Punkt.X + Random(Zasieg) - Polowa;
        Punkt.Y := Punkt.Y + Random(Zasieg) - Polowa;
      end;
    1:
      begin
        Punkt.X := Punkt.X + Round(Sin(LicznikCzasu / 5) * Polowa);
        Punkt.Y := Punkt.Y + Random(3) - 1;
      end;
    2:
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
    3:
      begin
        Punkt.X := Punkt.X + Random(Zasieg) - Polowa;
        Punkt.Y := Punkt.Y + Random(Zasieg) - Polowa + 3;
      end;
    4:
      begin
        Punkt.X := Punkt.X + Random(Zasieg * 2) - Zasieg;
        Punkt.Y := Punkt.Y + Random(Zasieg * 2) - Zasieg;
      end;
    5:
      begin
        Punkt.X := Punkt.X + Round(Cos(LicznikCzasu / 7) * Polowa);
        Punkt.Y := Punkt.Y + Round(Sin(LicznikCzasu / 7) * Polowa);
      end;
    6:
      begin
        Punkt.X := Punkt.X + Round(Sin(LicznikCzasu / 12) * Zasieg);
        Punkt.Y := Punkt.Y + Round(Cos(LicznikCzasu / 9) * Polowa);
      end;
    7:
      begin
        if Assigned(FormCel) and FormCel.Visible then
        begin
          CenterX := FormCel.Left + FormCel.Width div 2;
          CenterY := FormCel.Top + FormCel.Height div 2;

          if Abs(Punkt.X - CenterX) < FormCel.Width then
          begin
            if Punkt.X < CenterX then
              Dec(Punkt.X, Polowa + 3)
            else
              Inc(Punkt.X, Polowa + 3);
          end;

          if Abs(Punkt.Y - CenterY) < FormCel.Height then
          begin
            if Punkt.Y < CenterY then
              Dec(Punkt.Y, Polowa + 3)
            else
              Inc(Punkt.Y, Polowa + 3);
          end;
        end
        else
        begin
          Punkt.X := Punkt.X + Random(8) - 4;
          Punkt.Y := Punkt.Y + Random(8) - 4;
        end;
      end;
    8:
      begin
        if Assigned(FormCel) and FormCel.Visible then
        begin
          CenterX := FormCel.Left + FormCel.Width div 2;
          CenterY := FormCel.Top + FormCel.Height div 2;
        end
        else
        begin
          CenterX := (Desktop.Left + Desktop.Right) div 2;
          CenterY := (Desktop.Top + Desktop.Bottom) div 2;
        end;

        NudgeX := EnsureRange((CenterX - Punkt.X) div 12, -Polowa, Polowa);
        NudgeY := EnsureRange((CenterY - Punkt.Y) div 12, -Polowa, Polowa);
        Punkt.X := Punkt.X + NudgeX + Random(9) - 4;
        Punkt.Y := Punkt.Y + NudgeY + Random(9) - 4;
      end;
    9:
      begin
        Punkt.X := Punkt.X + Round(Sin(LicznikCzasu / 8) * Zasieg) + 4;
        Punkt.Y := Punkt.Y + Random(Polowa + 1) - (Polowa div 2);
      end;
    10:
      begin
        if (LicznikCzasu mod 6) = 0 then
        begin
          Punkt.X := Punkt.X + Polowa + Random(12);
          Punkt.Y := Punkt.Y + Polowa + Random(12);
        end
        else
        begin
          Punkt.X := Punkt.X + Random(5) - 2;
          Punkt.Y := Punkt.Y + Random(5) - 2;
        end;
      end;
    11:
      begin
        if ((LicznikCzasu div 10) mod 2) = 0 then
          Punkt.X := Punkt.X + Polowa
        else
          Punkt.X := Punkt.X - Polowa;

        Punkt.Y := Punkt.Y + Random(Zasieg) - Polowa;
      end;
    12:
      begin
        Punkt.X := Punkt.X + Random(Zasieg) - Polowa;
        Punkt.Y := Punkt.Y + Random(Zasieg) - Polowa;

        if Random(12) = 0 then
        begin
          Punkt.X := Punkt.X + Random(180) - 90;
          Punkt.Y := Punkt.Y + Random(180) - 90;
        end;
      end;
    13:
      begin
        if Assigned(FormCel) and FormCel.Visible then
        begin
          CenterX := FormCel.Left + FormCel.Width div 2;
          CenterY := FormCel.Top + FormCel.Height div 2;
        end
        else
        begin
          CenterX := (Desktop.Left + Desktop.Right) div 2;
          CenterY := (Desktop.Top + Desktop.Bottom) div 2;
        end;

        NudgeX := EnsureRange((CenterX - Punkt.X) div 28, -Polowa, Polowa);
        NudgeY := EnsureRange((CenterY - Punkt.Y) div 28, -Polowa, Polowa);
        Punkt.X := Punkt.X + NudgeX + Round(Sin(LicznikCzasu / 11) * 6);
        Punkt.Y := Punkt.Y + NudgeY + Round(Cos(LicznikCzasu / 13) * 6);
      end;
  end;

  Punkt.X := EnsureRange(Punkt.X, Desktop.Left, Desktop.Right - 1);
  Punkt.Y := EnsureRange(Punkt.Y, Desktop.Top, Desktop.Bottom - 1);
  SetCursorPos(Punkt.X, Punkt.Y);
end;

procedure TForm1.PokazLosowyKomunikat;
var
  Los: Integer;
  Komunikat: string;
begin
  Los := Random(16);
  case Los of
    0: Komunikat := 'Twoja myszka jest za zimna. Zalecane jest włożenie jej do gorącej wody na 10 minut.';
    1: Komunikat := 'Wykryto zbyt szybkie machanie myszką. Zwolnij, kursor musi odpocząć.';
    2: Komunikat := 'Kursor zgubił drogę. Proszę dmuchać w sensor optyczny, aby go naprowadzić.';
    3: Komunikat := 'UWAGA: Poziom płynu w podkładce pod mysz spadł poniżej krytycznego poziomu.';
    4: Komunikat := 'System wykrył, że patrzysz na monitor zbyt podejrzliwie. Zmień wyraz twarzy.';
    5: Komunikat := 'Wskaźnik myszy uciekł na inny ekran. Proszę czekać, aż wróci pieszo.';
    6: Komunikat := 'Błąd grawitacji kursora. Za chwilę myszka zacznie spadać w dół ekranu.';
    7: Komunikat := 'Kursor uruchomił tryb taneczny. Rytm może być niezgodny z muzyką.';
    8: Komunikat := 'Wykryto zmęczenie lewego przycisku myszy. Zalecana przerwa techniczna.';
    9: Komunikat := 'Myszka twierdzi, że nie podpisywała regulaminu prostego ruchu.';
    10: Komunikat := 'Kalibracja odwagi kursora nie powiodła się. Spróbuj podejść łagodniej.';
    11: Komunikat := 'Tryb sprężyny napięty. Kursor może wracać tam, gdzie wcale nie chciałeś.';
    12: Komunikat := 'Wykryto boczny wiatr na pulpicie. Trzymaj myszkę obiema rękami.';
    13: Komunikat := 'Kursor wybrał schody zamiast windy. Ruch może być kanciasty.';
    14: Komunikat := 'Turbulencje myszy przekroczyły normę biurową.';
  else
    Komunikat := 'Tryb DrunkMouse aktywny. Awaryjne zatrzymanie: Alt+M.';
  end;

  Winapi.Windows.MessageBox(0, PChar(Komunikat), 'DrunkMouse',
    MB_OK or MB_ICONWARNING or MB_TASKMODAL or MB_SETFOREGROUND);
end;

procedure TForm1.TimerKomunikatyTimer(Sender: TObject);
begin
  if ChkKomunikaty.Checked then
    PokazLosowyKomunikat;
end;

procedure TForm1.TimerCzasTimer(Sender: TObject);
begin
  AktualizujPanelStatusu;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  AktualizujPanelStatusu;
end;

procedure TForm1.CmbPoziomChange(Sender: TObject);
begin
  if Aktywne then
    Exit;

  ZastosujPoziomTrudnosci;
  AktualizujPanelStatusu;
end;

procedure TForm1.ChkKomunikatyClick(Sender: TObject);
begin
  TimerKomunikaty.Enabled := Aktywne and ChkKomunikaty.Checked;
end;

procedure TForm1.ChkZmieniajTrybyClick(Sender: TObject);
begin
  TimerTryby.Enabled := Aktywne and ChkZmieniajTryby.Checked;
end;

end.
