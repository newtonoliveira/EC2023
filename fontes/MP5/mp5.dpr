program mp5;

uses
  System.StartUpCopy,
  FMX.Forms,
  clisitef in '..\comum\clisitef.pas',
  constants in '..\comum\constants.pas',
  uCliSitef in '..\comum\uCliSitef.pas',
  uCliSiTefI in '..\comum\uCliSiTefI.pas',
  uFrmTransacao in '..\comum\uFrmTransacao.pas' {frmTransacao},
  uLog in '..\comum\uLog.pas',
  uPermissoes in '..\comum\uPermissoes.pas',
  uCPermissions in '..\comum\uCPermissions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTransacao, frmTransacao);
  Application.Run;
end.
