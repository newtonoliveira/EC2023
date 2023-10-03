unit uCliSitef;

interface

uses
  uCliSItefI,
  FMX.Platform.Android,
  System.SysUtils,
  System.Types,
  System.Classes,
  System.Rtti,
  Web.HTTPApp,
  System.NetEncoding,
  System.Actions,
  FMX.ActnList,
  System.IOUtils,
  uLog,
  constants;

type
  TClisitefRespostaTransacao = record
  strict private
    FNumeroSeriePinpad: string;
    FNsuSitef: string;
    FNsuHost: string;
    FCodigoAutorizacao: string;
    FNumeroBinCartao: string;
    FNumeroEmbosoCartao: string;
    FCodigoAdquirente: string;
    FCodigoBandeira: string;
    FTipoCartao: string;
    FDataFiscal: String;
    FNumeroCupom: string;
    FDataHoraSITEF: string;
    FCodigoResposta: string;
    FNomeDaInstituicao: string;
    FNome_Titular: string;
    FMensagem: string;
  public
    property NumeroSeriePinpad: string read FNumeroSeriePinpad write FNumeroSeriePinpad;
    property NsuSitef: string read FNsuSitef write FNsuSitef;
    property NsuHost: string read FNsuHost write FNsuHost;
    property CodigoAutorizacao: string read FCodigoAutorizacao write FCodigoAutorizacao;
    property NumeroBinCartao: string read FNumeroBinCartao write FNumeroBinCartao;
    property NumeroEmbosoCartao: string read FNumeroEmbosoCartao write FNumeroEmbosoCartao;
    property CodigoAdquirente: string read FCodigoAdquirente write FCodigoAdquirente;
    property CodigoBandeira: string read FCodigoBandeira write FCodigoBandeira;
    property TipoCartao: string read FTipoCartao write FTipoCartao;
    property DataFiscal: String read FDataFiscal write FDataFiscal;
    property NumeroCupom: string read FNumeroCupom write FNumeroCupom;
    property DataHoraSITEF: string read FDataHoraSITEF write FDataHoraSITEF;
    property CodigoResposta: string read FCodigoResposta write FCodigoResposta;
    property NomeDaInstituicao: string read FNomeDaInstituicao write FNomeDaInstituicao;
    property Nome_Titular: string read FNome_Titular write FNome_Titular;
    property Mensagem: string read FMensagem write FMensagem;

  end;

  TNotifyRotinaColeta = reference to procedure(AComando: integer; ABuffer: string);
  TNotifyRotinaResultado = reference to procedure(ACampo: integer; ABuffer: string);

  TNotifyResultadoTEF = reference to procedure(AClisitefRespostaTransacao: TClisitefRespostaTransacao);

  TCliSItef = class
  strict private
    FCliSItef: TCLiSitefI;
    FSTS: integer;
    FRodando: boolean;
    FRotinaColeta: TNotifyRotinaColeta;
    FRotinaResultado: TNotifyRotinaResultado;
    FValorTransacao: Extended;
    FQtdParcelas: integer;
    FSitefConectado: boolean;
    FSelecionaFormaPagamento: boolean;
    FClisitefRespostaTransacao: TClisitefRespostaTransacao;
    FResultadoTEF: TNotifyResultadoTEF;
    FCodigoLoja: string;
    FNumeroTerminal: string;
    FParametrosAdicionais: string;
    FEnderecoIPSitef: string;
    FPortaSITEF: integer;

    procedure HandleMessage(Value: integer);
    procedure RotinaColeta(comando: integer);
    procedure RotinaResultado(campo: integer);

    function MensagemCodigoResposta(Value: string): string;
    function GetMensagemResposta: string;
    function GetValorTransacao(): string;
  private
    function GetCodigoLoja: string;
    function GetEnderecoIPSitef: string;
    function GetNumeroTerminal: string;
    function GetParametrosAdicionais: string;
  public
    property sts: integer read FSTS;
    property MensagemResposta: string read GetMensagemResposta;

    property onRotinaColeta: TNotifyRotinaColeta read FRotinaColeta write FRotinaColeta;
    property onRotinaResultado: TNotifyRotinaResultado read FRotinaResultado write FRotinaResultado;

    property OnResultadoTEF: TNotifyResultadoTEF read FResultadoTEF write FResultadoTEF;

    property ValorTransacao: Extended read FValorTransacao write FValorTransacao;

    property QtdParcelas: integer read FQtdParcelas write FQtdParcelas;

    property Conectado: boolean read FSitefConectado;

    property RespostaTransacao: TClisitefRespostaTransacao read FClisitefRespostaTransacao;
    property CodigoLoja: string read GetCodigoLoja write FCodigoLoja;
    property NumeroTerminal: string read GetNumeroTerminal write FNumeroTerminal;
    property ParametrosAdicionais: string read GetParametrosAdicionais write FParametrosAdicionais;
    property EnderecoIPSitef: string read GetEnderecoIPSitef write FEnderecoIPSitef;
    property PortaSitef: integer read FPortaSITEF write FPortaSITEF;

    procedure transaciona(AFuncao: integer; ANumeroCupomFiscal: string; ANumeroTerminal: string = ''; ARestricoes: string = '');

    function BluetoothPareado(): boolean;

  end;

implementation

{ TCliSItef }

function TCliSItef.BluetoothPareado: boolean;
var
  lInformacoesPinpad: TInformacoesPinpad;
begin
  lInformacoesPinpad := TInformacoesPinpad.Create();
  result := lInformacoesPinpad.localizado;
end;

function TCliSItef.GetCodigoLoja: string;
begin
  Result := FCodigoLoja;
end;

function TCliSItef.GetEnderecoIPSitef: string;
begin
  Result := FEnderecoIPSitef;
end;

function TCliSItef.GetMensagemResposta: string;
begin
  Result := MensagemCodigoResposta(FSTS.ToString);
end;

function TCliSItef.GetNumeroTerminal: string;
begin
  Result := FNumeroTerminal;
end;

function TCliSItef.GetParametrosAdicionais: string;
begin
  Result := FParametrosAdicionais;
end;

function TCliSItef.GetValorTransacao: string;
begin
  Result := FValorTransacao.ToString;
  Result := StringReplace(Result, '.', '', [rfReplaceAll]);
  Result := StringReplace(Result, ',', '', [rfReplaceAll]);
end;

procedure TCliSItef.HandleMessage(Value: integer);
begin
  if (Value = CMD_RETORNO_VALOR) then
    RotinaResultado(getTipoCampo)
  else
    RotinaColeta(Value);
end;

function TCliSItef.MensagemCodigoResposta(Value: string): string;
begin
  if Value = '00' then
    Result := 'Transa��o autorizada'
  else if Value = '-1' then
    Result := 'M�dulo n�o inicializado.'
  else if Value = '-2' then
    Result := 'Opera��o cancelada pelo operador.'
  else if Value = '-3' then
    Result := 'O par�metro fun��o / modalidade � inexistente/inv�lido.'
  else if Value = '-4' then
    Result := 'Falta de mem�ria no PDV.'
  else if Value = '-5' then
    Result := 'Sem comunica��o com o SiTef.'
  else if Value = '-6' then
    Result := 'Opera��o cancelada pelo usu�rio no pinpad.'
  else if Value = '-7' then
    Result := 'Reservado'
  else if Value = '-8' then
    Result := 'A CliSiTef n�o possui a implementa��o da fun��o necess�ria, provavelmente est� desatualizada (a CliSiTefI � mais recente).'
  else if Value = '-9' then
    Result := 'A automa��o chamou a rotina ContinuaFuncaoSiTefInterativo sem antes iniciar uma fun��o iterativa.'
  else if Value = '-10' then
    Result := 'Algum par�metro obrigat�rio n�o foi passado pela automa��o comercial.'
  else if Value = '-12' then
    Result := 'Erro na execu��o da rotina iterativa. Provavelmente o processo iterativo anterior n�o foi executado at� o final (enquanto o retorno for igual a 10000).'
  else if Value = '-13' then
    Result := 'Documento fiscal n�o encontrado nos registros da CliSiTef. Retornado em fun��es de consulta tais como ObtemQuantidadeTransa��esPendentes.'
  else if Value = '-15' then
    Result := 'Opera��o cancelada pela automa��o comercial.'
  else if Value = '-20' then
    Result := 'Par�metro inv�lido passado para a fun��o.'
  else if Value = '-21' then
    Result := 'Utilizada uma palavra proibida, por exemplo SENHA, para coletar dados em aberto no pinpad. Por exemplo na fun��o ObtemDadoPinpadDiretoEx.'
  else if Value = '-25' then
    Result := 'Erro no Correspondente Banc�rio: Deve realizar sangria.'
  else if Value = '-28' then
    Result := 'Excede o n�mero de parcelas'
  else if Value = '-30' then
    Result := 'Erro de acesso ao arquivo. Certifique-se que o usu�rio que roda a aplica��o tem direitos de leitura/escrita.'
  else if Value = '-40' then
    Result := 'Transa��o negada pelo servidor SiTef.'
  else if Value = '-41' then
    Result := 'Dados inv�lidos.'
  else if Value = '-42' then
    Result := 'Reservado'
  else if Value = '-43' then
    Result := 'Erro pinpad.'
  else if Value = '-50' then
    Result := 'Transa��o n�o segura.'
  else if Value = '-100' then
    Result := 'Erro interno do m�dulo.'
  else
    Result := 'Transa��o n�o autorizada'
end;

procedure TCliSItef.RotinaColeta(comando: integer);
var
  lBuffer: string;
begin
  lBuffer := getBuffer;

  case comando of
    CMD_NUMERIO_PARCELAS:
      begin
        setBuffer(FQtdParcelas.ToString);
      end;
    CMD_GET_MENU_OPTION:
      begin
        if FSelecionaFormaPagamento then
        begin
          if FQtdParcelas > 1 then
            setBuffer('2')
          else
            setBuffer('1');
        end;
      end;

    CMD_OBTEM_VALOR:
      begin
        setBuffer(GetValorTransacao());
      end;
    CMD_MENSAGEM_OPERADOR, CMD_MENSAGEM_CLIENTE, CMD_MENSAGEM:
      begin
        if (getBuffer = TXT_SITEF_CONECTADO) then
          FSitefConectado := true;
      end;

    CMD_TITULO_MENU, CMD_EXIBE_CABECALHO:
      begin
        FSelecionaFormaPagamento := (lBuffer = 'Selecione a forma de pagamento');
      end;

    19, CMD_CONFIRMA_CANCELA:
      setBuffer('0');
  end;

  if Assigned(FRotinaColeta) then
    FRotinaColeta(comando, lBuffer);
end;

procedure TCliSItef.RotinaResultado(campo: integer);
var
  lBuffer: string;
begin
  lBuffer := getBuffer;
  case campo of
    CAMPO_COMPROVANTE_CLIENTE:
      begin
      end;
    CAMPO_COMPROVANTE_ESTAB:
      begin
      end;
    CAMPO_SERIE_PINPAD:
      begin
        FClisitefRespostaTransacao.NumeroSeriePinpad := lBuffer;
      end;
    CAMPO_NSU_SITEF:
      FClisitefRespostaTransacao.NsuSitef := lBuffer;
    CAMPO_NSU_HOST:
      FClisitefRespostaTransacao.NsuHost := lBuffer;
    CAMPO_CODIGO_AUTORIZACAO:
      FClisitefRespostaTransacao.CodigoAutorizacao := lBuffer;
    CAMPO_BIN:
      FClisitefRespostaTransacao.NumeroBinCartao := lBuffer;
    CAMPO_EMBOSO:
      FClisitefRespostaTransacao.NumeroEmbosoCartao := lBuffer;
    CAMPO_CODIGO_REDE:
      FClisitefRespostaTransacao.CodigoAdquirente := lBuffer;
    CAMPO_CODIGO_BANDEIRA:
      FClisitefRespostaTransacao.CodigoBandeira := lBuffer;
    CAMPO_TIPO_CARTAO_LIDO:
      FClisitefRespostaTransacao.TipoCartao := lBuffer;
    CAMPO_DATA_FISCAL:
      FClisitefRespostaTransacao.DataFiscal := lBuffer;
    CAMPO_NUMERO_CUPOM:
      FClisitefRespostaTransacao.NumeroCupom := lBuffer;
    CAMPO_DATA_HORA_SITEF:
      FClisitefRespostaTransacao.DataHoraSITEF := lBuffer;
    CAMPO_CODIGO_RESPOSTA_AUTORIZADOR:
      begin
        FClisitefRespostaTransacao.CodigoResposta := lBuffer;
        FClisitefRespostaTransacao.Mensagem := MensagemCodigoResposta(FClisitefRespostaTransacao.CodigoResposta);
      end;
    CAMPO_NOME_DA_INSTITUICAO:
      FClisitefRespostaTransacao.NomeDaInstituicao := lBuffer;
    CAMPO_NOME_TITULAR:
      FClisitefRespostaTransacao.Nome_Titular := lBuffer;
  end;

  if Assigned(FRotinaResultado) then
    FRotinaResultado(campo, lBuffer);
end;

procedure TCliSItef.transaciona(AFuncao: integer; ANumeroCupomFiscal, ANumeroTerminal, ARestricoes: string);
var
  lHora: string;
  lData: string;
  lDtm: tdatetime;
  lFuncao: integer;
  lCupomFiscal: integer;
  lProximoComando: integer;
begin
  lDtm := now;
  lHora := FormatDateTime('hhmmss', lDtm);
  lData := FormatDateTime('yyyyMMdd', lDtm);

  tthread.CreateAnonymousThread(
    procedure
    begin
      try
        try

          TLog.I('Inicializando');

          setDebug(true);
          setActivity(MainActivity);

          TLog.I('Configurando');

          if EnderecoIPSitef.Trim = EmptyStr then
             raise Exception.Create('Endereco do sitef deve ser informado');

          FSTS := configuraIntSiTefInterativoEx(EnderecoIPSitef, CodigoLoja, NumeroTerminal, ParametrosAdicionais);

          TLog.I('configuraIntSiTefInterativoEx STS=' + FSTS.ToString);

          FRodando := true;

          FSTS := iniciaFuncaoSiTefInterativo(lFuncao, GetValorTransacao(), lCupomFiscal.ToString, lData, lHora, ANumeroTerminal, ARestricoes);

          TLog.I('iniciaFuncaoSiTefInterativo STS=' + FSTS.ToString);

          FClisitefRespostaTransacao.CodigoResposta := FSTS.ToString;
          FClisitefRespostaTransacao.Mensagem := MensagemCodigoResposta(FClisitefRespostaTransacao.CodigoResposta);

          while FSTS = CONTINUA_SITEF do
          begin
            FSTS := continuaFuncaoSiTefInterativo;

            TLog.I('continuaFuncaoSiTefInterativo inicia STS=' + FSTS.ToString);

            if (FSTS <> CONTINUA_SITEF) then
              break;

            lProximoComando := getProximoComando;
            HandleMessage(lProximoComando);
          end;

          if FSTS = 0 then
          begin
            FSTS := finalizaTransacaoSiTefInterativoEx(1, lCupomFiscal.ToString, lData, lHora, '');

            TLog.I('finalizaTransacaoSiTefInterativoEx STS=' + FSTS.ToString);

            while FSTS = CONTINUA_SITEF do
            begin
              FSTS := continuaFuncaoSiTefInterativo;
              TLog.I('continuaFuncaoSiTefInterativo Finaliza STS=' + FSTS.ToString);

              if (FSTS <> CONTINUA_SITEF) then
                break;

              lProximoComando := getProximoComando;
              HandleMessage(lProximoComando);
            end;
          end
          else
            FClisitefRespostaTransacao.CodigoResposta := FSTS.ToString;

          TLog.I('Finaliza Transacao STS=' + FSTS.ToString);

          FRodando := false;
          FSitefConectado := false;

        except
          on E: Exception do
          begin
            TLog.E(E.Message);
            FClisitefRespostaTransacao.Mensagem := E.Message;
          end;
        end;
      finally
        if Assigned(FResultadoTEF) then
          FResultadoTEF(FClisitefRespostaTransacao);

        tthread.Current.Terminate;
      end;
    end).Start;
end;

end.
