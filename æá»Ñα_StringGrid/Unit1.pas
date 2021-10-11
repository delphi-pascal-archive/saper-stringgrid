unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, Grids, StdCtrls;

type
  TField = record
    Count : Integer;
    Flag  : Boolean;
    Open  : Boolean;
    Mine  : Boolean;
  end;
  TForm3 = class(TForm)
    Pole: TDrawGrid;
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    procedure New(MineCount : Integer);
    procedure FormCreate(Sender: TObject);
    procedure PoleDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure PoleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    function CheckWin : Boolean;
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3 : TForm3;
  SPole : array [0..9, 0..9] of Tfield;
  Status: Integer = 0;
implementation

{$R *.dfm}


{ TForm3 }

procedure TForm3.Button1Click(Sender: TObject);
begin
  New(StrToInt(Edit1.Text));
  Pole.Enabled := true;
  Status := 2;
  Pole.Repaint;
end;

function TForm3.CheckWin: Boolean;
var x, y : Integer;
begin
  Result := true;
  for x := 0 to 9 do
    for y := 0 to 9 do
      if SPole[x,y].Flag xor SPole[x,y].Mine then
        Result := false;
end;

procedure TForm3.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9']) then
    Key := #0;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  Randomize;
  New(10);
  Pole.Repaint;
end;

procedure TForm3.New(MineCount: Integer);
var x, y, k : Integer;
begin
  for x := 0 to 9 do
    for y := 0 to 9 do begin
      SPole[x,y].Count := 0;
      SPole[x,y].Open := false;
      SPole[x,y].Flag := false;
      SPole[x,y].Mine := false;
    end;

  k := 0;
  repeat
    x := Random(10);
    y := Random(10);
    if SPole[x, y].Mine = false then begin
      SPole[x,y].Mine := true;
      inc(k);
    end;
  until (k = MineCount);

  for x := 0 to 9 do
    for y := 0 to 9 do begin
      if SPole[x,y].Mine then
        continue;
      k := 0;
      if (x > 0) and SPole[x-1,y].Mine then Inc(k);
      if (x < 9) and SPole[x+1,y].Mine then Inc(k);
      if (y > 0) and SPole[x,y-1].Mine then Inc(k);
      if (y < 9) and SPole[x,y+1].Mine then Inc(k);

      if (x > 0) and (y > 0) and SPole[x-1,y-1].Mine then Inc(k);
      if (x < 9) and (y < 9) and SPole[x+1,y+1].Mine then Inc(k);
      if (y > 0) and (x < 9) and SPole[x+1,y-1].Mine then Inc(k);
      if (y < 9) and (x > 0) and SPole[x-1,y+1].Mine then Inc(k);

      SPole[x, y].Count := k;
    end;
  Status := 2;
end;

procedure TForm3.PoleDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
  State: TGridDrawState);
var C : TColor;
begin
  Rect := Pole.CellRect(ACol, ARow);
  if not SPole[ACol, ARow].Open then begin
    Pole.Canvas.Pen.Color := clBlack;
    Pole.Canvas.Pen.Width := 1;
    Pole.Canvas.Brush.Color := clGray;
    Pole.Canvas.Brush.Style := bsSolid;
    Pole.Canvas.Rectangle(Rect);
    if SPole[ACol, ARow].Flag then begin
      Pole.Canvas.Pen.Color := clBlack;
      Pole.Canvas.MoveTo(Rect.Left + 2, Rect.Bottom - 3);
      Pole.Canvas.LineTo(Rect.Left + 2, Rect.Top + 2);
      Pole.Canvas.LineTo(Rect.Right - 4, Rect.Top + 5);
      Pole.Canvas.LineTo(Rect.Left + 2, Rect.Top + 10);
      Pole.Canvas.Brush.Color := clRed;
      Pole.Canvas.FloodFill(Rect.Left + 3, Rect.Top + 3, clGray, fsSurface);
      if (not SPole[ACol, ARow].Mine) and SPole[ACol, ARow].Flag and (Status = 3) then
      begin
        Pole.Canvas.MoveTo(Rect.Left, Rect.Top);
        Pole.Canvas.LineTo(Rect.Right, Rect.Bottom);
      end;
    end;
    if Status <> 3 then Exit;
  end;


  if (SPole[ACol, ARow].Mine) and (Status = 3) then begin

    Pole.Canvas.Pen.Color := clBlack;
    if SPole[ACol, ARow].Count = -1 then begin
      Pole.Canvas.Brush.Color := clRed;
      Pole.Canvas.FillRect(Rect);
    end;
    Pole.Canvas.Brush.Color := clGreen;
    Pole.Canvas.Pen.Width := 1;
    Pole.Canvas.Ellipse(Rect.Left + 3, Rect.Top + 3, Rect.Right - 3, Rect.Bottom - 3);


    Exit;
  end;



  if not SPole[ACol, ARow].Open then Exit;

  Pole.Canvas.Brush.Color := clSilver;
  Pole.Canvas.FillRect(Rect);

  if SPole[ACol, ARow].Count > 0 then begin
    case SPole[ACol, ARow].Count of
      1 : c := clBlue;
      2 : c := clGreen;
      3 : c := clRed;
      4 : c := clNavy;
      5 : c := clMaroon;
      6 : c := clTeal;
      7 : c := clBlack;
      8 : c := clGray;
    end;

    Pole.Canvas.Font.Color := c;
    Pole.Canvas.Font.Style := [fsBold];
    Pole.Canvas.TextOut(Rect.Left + 4, Rect.Top +1, IntToStr(SPole[ACol, ARow].Count));
  end;
end;

procedure Open(X, Y : Integer);
begin
  if SPole[X, Y].Mine or SPole[X, Y].Open then Exit;
  SPole[X, Y].Open := true;
  if SPole[X, Y].Count <> 0 then
    Exit;
  if (x > 0) and not(SPole[x-1,y].Mine ) then Open(X-1,Y);
  if (x < 9) and not(SPole[x+1,y].Mine ) then Open(X+1,Y);
  if (y > 0) and not(SPole[x,y-1].Mine ) then Open(X,Y-1);
  if (y < 9) and not(SPole[x,y+1].Mine ) then Open(X,Y+1);

  if (x > 0) and (y > 0) and not(SPole[x-1,y-1].Mine ) then Open(X-1,Y-1);
  if (x < 9) and (y < 9) and not(SPole[x+1,y+1].Mine ) then Open(X+1,Y+1);
  if (y > 0) and (x < 9) and not(SPole[x+1,y-1].Mine ) then Open(X+1,Y-1);
  if (y < 9) and (x > 0) and not(SPole[x-1,y+1].Mine ) then Open(X-1,Y+1);
end;

procedure TForm3.PoleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  X := X div 16;
  Y := Y div 16;
  if Button = mbLeft then begin
    if SPole[X, Y].Flag then
        Exit;
    if SPole[X, Y].Mine then begin
      Pole.Enabled := false;
      SPole[X, Y].Count := -1;
      Status := 3;
      Pole.Repaint;
    end else begin
      if SPole[X, Y].Count <> 0 then
      SPole[X, Y].Open := true else Open(X, Y);
    end;
  end else begin
      SPole[X, Y].Flag := not SPole[X, Y].Flag;
  end;
  if CheckWin and (Status = 2) then begin
    MessageDlg('You win!', mtInformation, [mbOK], 0);
    Status := 1;
  end;
  Pole.Repaint;
end;

end.
