unit uPermissoes;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  Androidapi.Helpers,
  Androidapi.JNI.Os,
  System.Variants,
  System.Permissions;

type
  TPermissoes = class
    procedure DisplayRationale(Sender: TObject; const APermissions: TClassicStringDynArray; const APostRationaleProc: TProc);
    procedure PermissionRequestResult(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);

  public
    procedure configura(Bluetooh: boolean = false);
  end;

const
  FPermissionCamera = 'android.permission.CAMERA';
  FPermissionMANAGE_EXTERNAL_STORAGE = 'android.permission.MANAGE_EXTERNAL_STORAGE';
  FPermissionReadExternalStorage = 'android.permission.READ_EXTERNAL_STORAGE';
  FPermissionWriteExternalStorage = 'android.permission.WRITE_EXTERNAL_STORAGE';
  FPermissionCALL_PHONE = 'android.permission.CALL_PHONE';
  FPermissionINSTALL_SHORTCUT = 'android.permission.INSTALL_SHORTCUT';
  FPermissionINTERNET = 'android.permission.INTERNET';
  FPermissionREAD_PHONE_STATE = 'android.permission.READ_PHONE_STATE';
  FPermissionREAD_PRIVILEGED_PHONE_STATE = 'READ_PRIVILEGED_PHONE_STATE';
  FPermissionCAPABILITY_USES_ALLOWED_NETWORK_TYPES_BITMASK = 'CAPABILITY_USES_ALLOWED_NETWORK_TYPES_BITMASK';
  FPermissionSET_WALLPAPER = 'android.permission.SET_WALLPAPER';
  FPermissionUSE_FULL_SCREEN_INTENT = 'android.permission.USE_FULL_SCREEN_INTENT';
  FPermissionWAKE_LOCK = 'android.permission.WAKE_LOCK';
  FPermissionWRITE_SETTINGS = 'android.permission.WRITE_SETTINGS';
  FPermissionWRITE_SYNC_SETTINGS = 'android.permission.WRITE_SYNC_SETTINGS';
  FPermissionBLUETOOTH = 'android.permission.BLUETOOTH';
  FPermissionBLUETOOTH_ADMIN = 'android.permission.BLUETOOTH_ADMIN';
  FPermissionBLUETOOTH_ADVERTISE = 'android.permission.BLUETOOTH_ADVERTISE';
  FPermissionBLUETOOTH_CONNECT = 'android.permission.BLUETOOTH_CONNECT';

implementation

{ TPermissoes }

procedure TPermissoes.configura(Bluetooh: boolean);
begin
  if Bluetooh then
    PermissionsService.RequestPermissions([FPermissionCamera, FPermissionMANAGE_EXTERNAL_STORAGE, FPermissionReadExternalStorage,
      FPermissionWriteExternalStorage, FPermissionCALL_PHONE, FPermissionINSTALL_SHORTCUT, FPermissionREAD_PHONE_STATE, FPermissionSET_WALLPAPER,
      FPermissionWRITE_SETTINGS, FPermissionREAD_PRIVILEGED_PHONE_STATE, FPermissionCAPABILITY_USES_ALLOWED_NETWORK_TYPES_BITMASK, FPermissionBLUETOOTH,
      FPermissionBLUETOOTH_ADMIN, FPermissionBLUETOOTH_ADVERTISE, FPermissionBLUETOOTH_CONNECT], PermissionRequestResult, DisplayRationale)
  else
    PermissionsService.RequestPermissions([FPermissionCamera, FPermissionMANAGE_EXTERNAL_STORAGE, FPermissionReadExternalStorage,
      FPermissionWriteExternalStorage, FPermissionCALL_PHONE, FPermissionINSTALL_SHORTCUT, FPermissionREAD_PHONE_STATE, FPermissionSET_WALLPAPER,
      FPermissionWRITE_SETTINGS, FPermissionREAD_PRIVILEGED_PHONE_STATE, FPermissionCAPABILITY_USES_ALLOWED_NETWORK_TYPES_BITMASK], PermissionRequestResult,
      DisplayRationale);
end;

procedure TPermissoes.DisplayRationale(Sender: TObject; const APermissions: TClassicStringDynArray; const APostRationaleProc: TProc);
begin

end;

procedure TPermissoes.PermissionRequestResult(Sender: TObject; const APermissions: TClassicStringDynArray;
  const AGrantResults: TClassicPermissionStatusDynArray);
begin

end;

end.
