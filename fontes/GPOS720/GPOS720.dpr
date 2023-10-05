program GPOS720;

uses
  System.StartUpCopy,
  FMX.Forms,
  clisitef in '..\comum\clisitef.pas',
  constants in '..\comum\constants.pas',
  uCliSitef in '..\comum\uCliSitef.pas',
  uCliSiTefI in '..\comum\uCliSiTefI.pas',
  uCPermissions in '..\comum\uCPermissions.pas',
  uFrmTransacao in '..\comum\uFrmTransacao.pas' {frmTransacao},
  uLog in '..\comum\uLog.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTransacao, frmTransacao);
  Application.Run;
end.
