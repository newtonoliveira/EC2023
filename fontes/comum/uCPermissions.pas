unit uCPermissions;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.Permissions,
  System.Types;

type
  TPermssionsProc = reference to procedure(AGranted: boolean);

  TPermission = record
  strict private
    FName: string;
    FStatus: TPermissionStatus;
    FEnabled: boolean;
  public
    property name: string read FName write FName;
    property status: TPermissionStatus read FStatus write FStatus;
    property Enabled: boolean read FEnabled write FEnabled;
  end;

  TGrantPermissions = TList<TPermission>;

  TPermissions = class
    FGrantPermissions: TGrantPermissions;

  strict private
    FGranted: boolean;
    FPermssionsProc: TPermssionsProc;
    function getBLUETOOTH: boolean;
    function getBLUETOOTH_ADMIN: boolean;
    function getBLUETOOTH_CONNECT: boolean;
    function getBLUETOOTH_SCAN: boolean;
    function getCALL_PHONE: boolean;
    function getCamera: boolean;
    function getCAPABILITY_USES_ALLOWED_NETWORK_TYPES_BITMASK: boolean;
    function getINSTALL_SHORTCUT: boolean;
    function getINTERNET: boolean;
    function getMANAGE_EXTERNAL_STORAGE: boolean;
    function getREAD_EXTERNAL_STORAGE: boolean;
    function getREAD_PHONE_STATE: boolean;
    function getREAD_PRIVILEGED_PHONE_STATE: boolean;
    function getSET_WALLPAPER: boolean;
    function getUSE_FULL_SCREEN_INTENT: boolean;
    function getWAKE_LOCK: boolean;
    function getWRITE_EXTERNAL_STORAGE: boolean;
    function getWRITE_SETTINGS: boolean;
    function getWRITE_SYNC_SETTINGS: boolean;
    procedure setBLUETOOTH(const Value: boolean);
    procedure setBLUETOOTH_ADMIN(const Value: boolean);
    procedure setBLUETOOTH_CONNECT(const Value: boolean);
    procedure setBLUETOOTH_SCAN(const Value: boolean);
    procedure setCALL_PHONE(const Value: boolean);
    procedure setCamera(const Value: boolean);
    procedure setCAPABILITY_USES_ALLOWED_NETWORK_TYPES_BITMASK(const Value: boolean);
    procedure setINSTALL_SHORTCUT(const Value: boolean);
    procedure setINTERNET(const Value: boolean);
    procedure setMANAGE_EXTERNAL_STORAGE(const Value: boolean);
    procedure setREAD_EXTERNAL_STORAGE(const Value: boolean);
    procedure setREAD_PHONE_STATE(const Value: boolean);
    procedure setREAD_PRIVILEGED_PHONE_STATE(const Value: boolean);
    procedure setSET_WALLPAPER(const Value: boolean);
    procedure setUSE_FULL_SCREEN_INTENT(const Value: boolean);
    procedure setWAKE_LOCK(const Value: boolean);
    procedure setWRITE_EXTERNAL_STORAGE(const Value: boolean);
    procedure setWRITE_SETTINGS(const Value: boolean);
    procedure setWRITE_SYNC_SETTINGS(const Value: boolean);
    function getBLUETOOTH_ADVERTISE: boolean;
    procedure setBLUETOOTH_ADVERTISE(const Value: boolean);

    procedure GrantPermissions(APermission: TPermission; AGrant: boolean);
    procedure DisplayRationale(Sender: TObject; const APermissions: TClassicStringDynArray; const APostRationaleProc: TProc);
    procedure PermissionRequestResult(Sender: TObject; const APermissions: TClassicStringDynArray;
      const AGrantResults: TClassicPermissionStatusDynArray);

    function getWRITE_PERMISSION_BLUETOOTH: boolean;
    procedure setWRITE_PERMISSION_BLUETOOTH(const Value: boolean);
  public
    property CAMERA: boolean read getCamera write setCamera;
    property MANAGE_EXTERNAL_STORAGE: boolean read getMANAGE_EXTERNAL_STORAGE write setMANAGE_EXTERNAL_STORAGE;
    property READ_EXTERNAL_STORAGE: boolean read getREAD_EXTERNAL_STORAGE write setREAD_EXTERNAL_STORAGE;
    property WRITE_EXTERNAL_STORAGE: boolean read getWRITE_EXTERNAL_STORAGE write setWRITE_EXTERNAL_STORAGE;
    property CALL_PHONE: boolean read getCALL_PHONE write setCALL_PHONE;
    property INSTALL_SHORTCUT: boolean read getINSTALL_SHORTCUT write setINSTALL_SHORTCUT;
    property INTERNET: boolean read getINTERNET write setINTERNET;
    property READ_PHONE_STATE: boolean read getREAD_PHONE_STATE write setREAD_PHONE_STATE;
    property READ_PRIVILEGED_PHONE_STATE: boolean read getREAD_PRIVILEGED_PHONE_STATE write setREAD_PRIVILEGED_PHONE_STATE;
    property CAPABILITY_USES_ALLOWED_NETWORK_TYPES_BITMASK: boolean read getCAPABILITY_USES_ALLOWED_NETWORK_TYPES_BITMASK
      write setCAPABILITY_USES_ALLOWED_NETWORK_TYPES_BITMASK;
    property SET_WALLPAPER: boolean read getSET_WALLPAPER write setSET_WALLPAPER;
    property USE_FULL_SCREEN_INTENT: boolean read getUSE_FULL_SCREEN_INTENT write setUSE_FULL_SCREEN_INTENT;
    property WAKE_LOCK: boolean read getWAKE_LOCK write setWAKE_LOCK;
    property WRITE_SETTINGS: boolean read getWRITE_SETTINGS write setWRITE_SETTINGS;
    property WRITE_SYNC_SETTINGS: boolean read getWRITE_SYNC_SETTINGS write setWRITE_SYNC_SETTINGS;
    property BLUETOOTH: boolean read getBLUETOOTH write setBLUETOOTH;
    property BLUETOOTH_SCAN: boolean read getBLUETOOTH_SCAN write setBLUETOOTH_SCAN;
    property BLUETOOTH_ADMIN: boolean read getBLUETOOTH_ADMIN write setBLUETOOTH_ADMIN;
    property BLUETOOTH_ADVERTISE: boolean read getBLUETOOTH_ADVERTISE write setBLUETOOTH_ADVERTISE;
    property BLUETOOTH_CONNECT: boolean read getBLUETOOTH_CONNECT write setBLUETOOTH_CONNECT;
    property WRITE_PERMISSION_BLUETOOTH: boolean read getWRITE_PERMISSION_BLUETOOTH write setWRITE_PERMISSION_BLUETOOTH;
    property granted: boolean read FGranted write FGranted;
    property onFinished: TPermssionsProc read FPermssionsProc write FPermssionsProc;
    procedure GrantNow();

    constructor create();
  end;

implementation

{ TPermissions }
constructor TPermissions.create;
begin
  FGrantPermissions := TGrantPermissions.create;
  FGranted := false;
end;

procedure TPermissions.DisplayRationale(Sender: TObject; const APermissions: TClassicStringDynArray; const APostRationaleProc: TProc);
begin
  FGranted := false;
  if Assigned(FPermssionsProc) then
    FPermssionsProc(FGranted);
end;

function TPermissions.getBLUETOOTH: boolean;
begin
  if TOSVersion.Major < 12 then
    result := PermissionsService.IsPermissionGranted('android.permission.BLUETOOTH')
  else
    result := true;
end;

function TPermissions.getBLUETOOTH_ADMIN: boolean;
begin
  if TOSVersion.Major < 12 then
    result := PermissionsService.IsPermissionGranted('android.permission.BLUETOOTH_ADMIN')
  else
    result := true;
end;

function TPermissions.getBLUETOOTH_ADVERTISE: boolean;
begin
  result := PermissionsService.IsPermissionGranted('android.permission.BLUETOOTH_ADVERTISE');
end;

function TPermissions.getBLUETOOTH_CONNECT: boolean;
begin
  result := PermissionsService.IsPermissionGranted('android.permission.BLUETOOTH_CONNECT');
end;

function TPermissions.getBLUETOOTH_SCAN: boolean;
begin
  result := PermissionsService.IsPermissionGranted('android.permission.BLUETOOTH_SCAN');
end;

function TPermissions.getCALL_PHONE: boolean;
begin
  result := PermissionsService.IsPermissionGranted('android.permission.CALL_PHONE');
end;

function TPermissions.getCamera: boolean;
begin
  result := PermissionsService.IsPermissionGranted('android.permission.CAMERA');
end;

function TPermissions.getCAPABILITY_USES_ALLOWED_NETWORK_TYPES_BITMASK: boolean;
begin
  result := PermissionsService.IsPermissionGranted('android.permission.CAPABILITY_USES_ALLOWED_NETWORK_TYPES_BITMASK');
end;

function TPermissions.getINSTALL_SHORTCUT: boolean;
begin
  result := PermissionsService.IsPermissionGranted('android.permission.INSTALL_SHORTCUT');
end;

function TPermissions.getINTERNET: boolean;
begin
  result := PermissionsService.IsPermissionGranted('android.permission.INTERNET');
end;

function TPermissions.getMANAGE_EXTERNAL_STORAGE: boolean;
begin
  result := PermissionsService.IsPermissionGranted('android.permission.MANAGE_EXTERNAL_STORAGE');
end;

function TPermissions.getREAD_EXTERNAL_STORAGE: boolean;
begin
  result := PermissionsService.IsPermissionGranted('android.permission.READ_EXTERNAL_STORAGE');
end;

function TPermissions.getREAD_PHONE_STATE: boolean;
begin
  result := PermissionsService.IsPermissionGranted('android.permission.READ_PHONE_STATE');
end;

function TPermissions.getREAD_PRIVILEGED_PHONE_STATE: boolean;
begin
  result := PermissionsService.IsPermissionGranted('android.permission.READ_PRIVILEGED_PHONE_STATE');
end;

function TPermissions.getSET_WALLPAPER: boolean;
begin
  result := PermissionsService.IsPermissionGranted('android.permission.SET_WALLPAPER');
end;

function TPermissions.getUSE_FULL_SCREEN_INTENT: boolean;
begin
  result := PermissionsService.IsPermissionGranted('android.permission.USE_FULL_SCREEN_INTENT');
end;

function TPermissions.getWAKE_LOCK: boolean;
begin
  result := PermissionsService.IsPermissionGranted('android.permission.WAKE_LOCK');
end;

function TPermissions.getWRITE_EXTERNAL_STORAGE: boolean;
begin
  result := PermissionsService.IsPermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE');
end;

function TPermissions.getWRITE_PERMISSION_BLUETOOTH: boolean;
begin
  result := PermissionsService.IsPermissionGranted('android.permission.WRITE_PERMISSION_BLUETOOTH');
end;

function TPermissions.getWRITE_SETTINGS: boolean;
begin
  result := PermissionsService.IsPermissionGranted('android.permission.WRITE_SETTINGS');
end;

function TPermissions.getWRITE_SYNC_SETTINGS: boolean;
begin
  result := PermissionsService.IsPermissionGranted('android.permission.WRITE_SYNC_SETTINGS');
end;

procedure TPermissions.GrantNow;
var
  lPermissions: TArray<string>;
  lPermission: TPermission;
  lPermissionsCount: integer;
begin
  lPermissionsCount := 0;
  for lPermission in FGrantPermissions do
  begin
    if lPermission.Enabled then
    begin
      SetLength(lPermissions, lPermissionsCount + 1);
      lPermissions[lPermissionsCount] := lPermission.name;
      inc(lPermissionsCount);
    end;
  end;
  PermissionsService.RequestPermissions(lPermissions, PermissionRequestResult, DisplayRationale);
end;

procedure TPermissions.GrantPermissions(APermission: TPermission; AGrant: boolean);
begin
  if AGrant then
  begin
    if FGrantPermissions.IndexOf(APermission) = -1 then
      FGrantPermissions.Add(APermission);
  end
  else if FGrantPermissions.IndexOf(APermission) <> -1 then
    FGrantPermissions.Delete(FGrantPermissions.IndexOf(APermission));
end;

procedure TPermissions.PermissionRequestResult(Sender: TObject; const APermissions: TClassicStringDynArray;
  const AGrantResults: TClassicPermissionStatusDynArray);
var
  lPermission: TPermission;
begin
  FGranted := true;
  for lPermission in FGrantPermissions do
  begin
    if lPermission.Enabled and (not PermissionsService.IsPermissionGranted(lPermission.name)) then
    begin
      FGranted := false;
      break;
    end;

  end;

  if Assigned(FPermssionsProc) then
    FPermssionsProc(FGranted);

end;

procedure TPermissions.setBLUETOOTH(const Value: boolean);
var
  lPermission: TPermission;
begin
  lPermission.name := 'android.permission.BLUETOOTH';
  lPermission.status := TPermissionStatus.granted;
  lPermission.Enabled := (TOSVersion.Major < 12);
  GrantPermissions(lPermission, Value);
end;

procedure TPermissions.setBLUETOOTH_ADMIN(const Value: boolean);
var
  lPermission: TPermission;
begin
  lPermission.name := 'android.permission.BLUETOOTH_ADMIN';
  lPermission.status := TPermissionStatus.granted;
  lPermission.Enabled := (TOSVersion.Major < 12);
  GrantPermissions(lPermission, Value);
end;

procedure TPermissions.setBLUETOOTH_ADVERTISE(const Value: boolean);
var
  lPermission: TPermission;
begin
  lPermission.name := 'android.permission.BLUETOOTH_ADVERTISE';
  lPermission.status := TPermissionStatus.granted;
  lPermission.Enabled := (TOSVersion.Major > 11);
  GrantPermissions(lPermission, Value);
end;

procedure TPermissions.setBLUETOOTH_CONNECT(const Value: boolean);
var
  lPermission: TPermission;
begin
  lPermission.name := 'android.permission.BLUETOOTH_CONNECT';
  lPermission.status := TPermissionStatus.granted;
  lPermission.Enabled := (TOSVersion.Major > 11);
  GrantPermissions(lPermission, Value);
end;

procedure TPermissions.setBLUETOOTH_SCAN(const Value: boolean);
var
  lPermission: TPermission;
begin
  lPermission.name := 'android.permission.BLUETOOTH_SCAN';
  lPermission.status := TPermissionStatus.granted;
  lPermission.Enabled := (TOSVersion.Major > 11);
  GrantPermissions(lPermission, Value);
end;

procedure TPermissions.setCALL_PHONE(const Value: boolean);
var
  lPermission: TPermission;
begin
  lPermission.name := 'android.permission.CALL_PHONE';
  lPermission.status := TPermissionStatus.granted;
  lPermission.Enabled := true;
  GrantPermissions(lPermission, Value);
end;

procedure TPermissions.setCamera(const Value: boolean);
var
  lPermission: TPermission;
begin
  lPermission.name := 'android.permission.CAMERA';
  lPermission.status := TPermissionStatus.granted;
  lPermission.Enabled := true;
  GrantPermissions(lPermission, Value);
end;

procedure TPermissions.setCAPABILITY_USES_ALLOWED_NETWORK_TYPES_BITMASK(const Value: boolean);
var
  lPermission: TPermission;
begin
  lPermission.name := 'android.permission.CAPABILITY_USES_ALLOWED_NETWORK_TYPES_BITMASK';
  lPermission.status := TPermissionStatus.granted;
  lPermission.Enabled := true;
  GrantPermissions(lPermission, Value);
end;

procedure TPermissions.setINSTALL_SHORTCUT(const Value: boolean);
var
  lPermission: TPermission;
begin
  lPermission.name := 'android.permission.INSTALL_SHORTCUT';
  lPermission.status := TPermissionStatus.granted;
  lPermission.Enabled := true;
  GrantPermissions(lPermission, Value);
end;

procedure TPermissions.setINTERNET(const Value: boolean);
var
  lPermission: TPermission;
begin
  lPermission.name := 'android.permission.INTERNET';
  lPermission.status := TPermissionStatus.granted;
  lPermission.Enabled := true;
  GrantPermissions(lPermission, Value);
end;

procedure TPermissions.setMANAGE_EXTERNAL_STORAGE(const Value: boolean);
var
  lPermission: TPermission;
begin
  lPermission.name := 'android.permission.MANAGE_EXTERNAL_STORAGE';
  lPermission.status := TPermissionStatus.granted;
  lPermission.Enabled := false;
  GrantPermissions(lPermission, Value);
end;

procedure TPermissions.setREAD_EXTERNAL_STORAGE(const Value: boolean);
var
  lPermission: TPermission;
begin
  lPermission.name := 'android.permission.READ_EXTERNAL_STORAGE';
  lPermission.status := TPermissionStatus.granted;
  lPermission.Enabled := false;
  GrantPermissions(lPermission, Value);
end;

procedure TPermissions.setREAD_PHONE_STATE(const Value: boolean);
var
  lPermission: TPermission;
begin
  lPermission.name := 'android.permission.READ_PHONE_STATE';
  lPermission.status := TPermissionStatus.granted;
  lPermission.Enabled := false;
  GrantPermissions(lPermission, Value);
end;

procedure TPermissions.setREAD_PRIVILEGED_PHONE_STATE(const Value: boolean);
var
  lPermission: TPermission;
begin
  lPermission.name := 'android.permission.READ_PRIVILEGED_PHONE_STATE';
  lPermission.status := TPermissionStatus.granted;
  lPermission.Enabled := false;
  GrantPermissions(lPermission, Value);
end;

procedure TPermissions.setSET_WALLPAPER(const Value: boolean);
var
  lPermission: TPermission;
begin
  lPermission.name := 'android.permission.SET_WALLPAPER';
  lPermission.status := TPermissionStatus.granted;
  lPermission.Enabled := false;
  GrantPermissions(lPermission, Value);
end;

procedure TPermissions.setUSE_FULL_SCREEN_INTENT(const Value: boolean);
var
  lPermission: TPermission;
begin
  lPermission.name := 'android.permission.USE_FULL_SCREEN_INTENT';
  lPermission.status := TPermissionStatus.granted;
  lPermission.Enabled := false;
  GrantPermissions(lPermission, Value);
end;

procedure TPermissions.setWAKE_LOCK(const Value: boolean);
var
  lPermission: TPermission;
begin
  lPermission.name := 'android.permission.WAKE_LOCK';
  lPermission.status := TPermissionStatus.granted;
  lPermission.Enabled := false;
  GrantPermissions(lPermission, Value);
end;

procedure TPermissions.setWRITE_EXTERNAL_STORAGE(const Value: boolean);
var
  lPermission: TPermission;
begin
  lPermission.name := 'android.permission.WRITE_EXTERNAL_STORAGE';
  lPermission.status := TPermissionStatus.granted;
  lPermission.Enabled := false;
  GrantPermissions(lPermission, Value);
end;

procedure TPermissions.setWRITE_PERMISSION_BLUETOOTH(const Value: boolean);
var
  lPermission: TPermission;
begin
  lPermission.name := 'android.permission.WRITE_PERMISSION_BLUETOOTH';
  lPermission.status := TPermissionStatus.granted;
  lPermission.Enabled := (TOSVersion.Major < 12);
  GrantPermissions(lPermission, Value);
end;

procedure TPermissions.setWRITE_SETTINGS(const Value: boolean);
var
  lPermission: TPermission;
begin
  lPermission.name := 'android.permission.WRITE_SETTINGS';
  lPermission.status := TPermissionStatus.granted;
  lPermission.Enabled := true;
  GrantPermissions(lPermission, Value);
end;

procedure TPermissions.setWRITE_SYNC_SETTINGS(const Value: boolean);
var
  lPermission: TPermission;
begin
  lPermission.name := 'android.permission.WRITE_SYNC_SETTINGS';
  lPermission.status := TPermissionStatus.granted;
  lPermission.Enabled := false;
  GrantPermissions(lPermission, Value);
end;

end.
