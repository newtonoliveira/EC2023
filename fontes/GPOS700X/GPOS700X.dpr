program GPOS700X;

uses
  System.StartUpCopy,
  FMX.Forms,
  uFrmTransacao in '..\comum\uFrmTransacao.pas' {frmTransacao} ,
  uCliSitef in '..\comum\uCliSitef.pas',
  uCliSiTefI in '..\comum\uCliSiTefI.pas',
  clisitef in '..\comum\clisitef.pas',
  constants in '..\comum\constants.pas',
  uPermissoes in '..\comum\uPermissoes.pas',
  uLog in '..\comum\uLog.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTransacao, frmTransacao);
  Application.Run;

end.
