program oreka;

uses
  Forms,
  main in 'main.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Or�ka Tracker';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
