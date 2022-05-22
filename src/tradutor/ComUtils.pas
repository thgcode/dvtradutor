unit ComUtils;
////////////////////////////////////////////////////////////////////////////////
//
//   Unit        :  ComUtils
//   Author      :  rllibby
//   Date        :  06.12.2005
//   Description :  Unit containing COM related utility classes and function for
//                  Delphi.
//
////////////////////////////////////////////////////////////////////////////////
interface

////////////////////////////////////////////////////////////////////////////////
//   Include units
////////////////////////////////////////////////////////////////////////////////
uses
  Windows, SysUtils, Messages, Classes, ComObj, ActiveX, Variants;

////////////////////////////////////////////////////////////////////////////////
//   CLSID Constants
////////////////////////////////////////////////////////////////////////////////
const
  CLSID_GIT:        TGUID =  '{00000323-0000-0000-C000-000000000046}';

////////////////////////////////////////////////////////////////////////////////
//   Function prototypes
////////////////////////////////////////////////////////////////////////////////
type
  TDllRegister      =  function: HResult; stdcall;
  TDllUnregister    =  function: HResult; stdcall;

////////////////////////////////////////////////////////////////////////////////
//   Structure data types
////////////////////////////////////////////////////////////////////////////////
type
  TRegFunctions     =  packed record
     lpRegister:    TDllRegister;
     lpUnregister:  TDllRegister;
  end;

////////////////////////////////////////////////////////////////////////////////
//   Interface types
////////////////////////////////////////////////////////////////////////////////
type
  IGIT              =  interface(IUnknown)
  ['{00000146-0000-0000-C000-000000000046}']
     function       RegisterInterfaceInGlobal(pUnk : IUnknown; const riid: TIID; out dwCookie: DWORD): HResult; stdcall;
     function       RevokeInterfaceFromGlobal(dwCookie: DWORD): HResult; stdcall;
     function       GetInterfaceFromGlobal(dwCookie: DWORD; const riid: TIID; out ppv): HResult; stdcall;
  end;

  IEnumerator       =  interface
     function       ForEach(out Obj: OleVariant): Boolean;
     function       ForEachObject(const IID: TGUID; out Obj): Boolean;
     function       Reset: Boolean;
     function       Skip(Count: LongWord): Boolean;
     function       Clone: IEnumerator;
  end;

////////////////////////////////////////////////////////////////////////////////
//   Class types
////////////////////////////////////////////////////////////////////////////////
type

  // Global interface table wrapper
  TGIT              =  class(TObject)
  private
     // Private declarations
     FCookie:       DWORD;
     FInterface:    TGUID;
  protected
     // Protected declarations
     function       GetComObject: IUnknown;
  public
     // Public declarations
     constructor    Create(IID: TGUID; Unknown: IUnknown);
     destructor     Destroy; override;
     property       ComObject: IUnknown read GetComObject;
  end;

  // ActiveX library registration wrapper
  TRegActionType    =  (raRegister, raUnregister);
  TRegActionTypes   =  Set of TRegActionType;
  TComRegistration  =  class(TObject)
  private
     // Private declarations
     FLibHandle:    THandle;
     FFunctions:    TRegFunctions;
  protected
     // Protected declarations
     function       GetLoaded: Boolean;
     function       GetIsComLibrary: Boolean;
     function       GetAvailableActions: TRegActionTypes;
  public
     // Public declarations
     constructor    Create;
     destructor     Destroy; override;
     function       Load(LibraryName: String): Integer;
     function       Perform(Action: TRegActionType): HResult;
     procedure      Unload;
     property       AvailableActions: TRegActionTypes read GetAvailableActions;
     property       Handle: THandle read FLibHandle;
     property       IsLoaded: Boolean read GetLoaded;
     property       IsComLibrary: Boolean read GetIsComLibrary;
  end;

  // IEnumVariant wrapper
  TEnumerator       =  class(TInterfacedObject, IEnumerator)
  private
     // Private declarations
     FEnumVariant:  IEnumVariant;
     procedure      GetEnumVariant(Dispatch: IDispatch);
  protected
     // Protected declarations
     function       ForEach(out Obj: OleVariant): Boolean;
     function       ForEachObject(const IID: TGUID; out Obj): Boolean;
     function       Reset: Boolean;
     function       Skip(Count: LongWord): Boolean;
     function       Clone: IEnumerator;
  public
     // Public declarations
     constructor    Create(Dispatch: IDispatch);
     constructor    CreateWrapper(EnumVariant: IEnumVariant);
     destructor     Destroy; override;
  end;

  // IMessageFilter wrapper
  TMessageFilter    =  class(TObject, IUnknown, IMessageFilter)
  private
     // Private Declarations
     FOldFilter:    IMessageFilter;
     FMaxWait:      Integer;
     FDelay:        Integer;
     FRefCount:     Integer;
  protected
     // IUnknown
     function       QueryInterface(const iid: TGUID; out obj): HResult; stdcall;
     function       _AddRef: Integer; virtual; stdcall;
     function       _Release: Integer; virtual; stdcall;
     // IMessageFilter
     function       HandleInComingCall(dwCallType: Longint; htaskCaller: HTask; dwTickCount: Longint; lpInterfaceInfo: PInterfaceInfo): Longint; stdcall;
     function       RetryRejectedCall(htaskCallee: HTask; dwTickCount: Longint; dwRejectType: Longint): Longint; stdcall;
     function       MessagePending(htaskCallee: HTask; dwTickCount: Longint; dwPendingType: Longint): Longint; stdcall;
  public
     // Public Declarations
     constructor    Create;
     destructor     Destroy; override;
  end;

  // Dispatch enumerated value wrapper
  TEnumValues       =  class(TObject)
  private
     // Private declarations
     FValues:       TStringList;
     procedure      Load(Dispatch: IDispatch);
  protected
     // Protected declarations
     function       GetCount: Integer;
     function       GetNames(Index: Integer): String;
     function       GetValues(Name: String): Integer;
  public
     // Public Declarations
     constructor    Create(Dispatch: IDispatch);
     destructor     Destroy; override;
     function       Exists(Name: String): Boolean;
     property       Count: Integer read GetCount;
     property       Names[Index: Integer]: String read GetNames;
     property       Values[Name: String]: Integer read GetValues;
  end;

  // Dispatch proxy wrapper to handle catching the Invoke method of a Dispatch interface
  TBeforeInvoke     =  procedure(Sender: TObject; DispID: Integer) of object;
  TAfterInvoke      =  procedure(Sender: TObject; DispID: Integer; InvokeResult: HResult) of object;
  TProxyDispatch    =  class(TObject, IDispatch)
  private
     // Private declarations
     FBInvoke:      TBeforeInvoke;
     FAInvoke:      TAfterInvoke;
     FObject:       IDispatch;
     FRefCount:     Integer;
  protected
     // Protected declarations from IUnknown
     function       QueryInterface(const iid: TGUID; out Obj): HResult; stdcall;
     function       _AddRef: Integer; virtual; stdcall;
     function       _Release: Integer; virtual; stdcall;
     // Protected declarations from IDispatch
     function       GetIDsOfNames(const IID: TGUID; Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
     function       GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
     function       GetTypeInfoCount(out Count: Integer): HResult; stdcall;
     function       Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
     // Protected declarations
     function       GetOleProxy: OleVariant;
     function       GetOleObject: OleVariant;
  public
     // Public declarations
     constructor    Create(Dispatch: IDispatch);
     destructor     Destroy; override;
     property       OleProxy: OleVariant read GetOleProxy;
     property       OleObject: OleVariant read GetOleObject;
     property       BeforeInvoke: TBeforeInvoke read FBInvoke write FBInvoke;
     property       AfterInvoke: TAfterInvoke read FAInvoke write FAInvoke;
  end;

  // Base class for creating circular reference interfaces
  TCircularInterface=  class(TObject, IUnknown)
  private
     // Private declarations
     FParent:       TCircularInterface;
  protected
     // Protected declarations
     FRefCount:     Integer;
     function       QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
     function       _AddRef: Integer; stdcall;
     function       _Release: Integer; stdcall;
  public
     class function NewInstance: TObject; override;
     constructor    Create; overload;
     constructor    Create(Parent: TCircularInterface); overload;
     procedure      AfterConstruction; override;
     procedure      BeforeDestruction; override;
     function       GetParent(iid: TGUID; out Obj): HResult;
     property       RefCount: Integer read FRefCount;
  end;

  // Event handler class for dispatch interfaces
  TOnEvent          =  procedure(Sender: TObject; DispatchID: TDispID; Parameters: OleVariant) of object;
  TEventDispatch    =  class(TObject, IUnknown, IDispatch)
  private
     // Private declarations
     FGuid:         TGuid;
     FOnEvent:      TOnEvent;
     FActive:       Boolean;
     FCount:        Integer;
     FCookie:       Integer;
     FEvents:       TStringList;
     FConnection:   IConnectionPoint;
  protected
     // Protected declarations from IUnknown
     function       QueryInterface(const iid: TGUID; out obj): HResult; stdcall;
     function       _AddRef: Integer; virtual; stdcall;
     function       _Release: Integer; virtual; stdcall;
     // Protected declarations from IDispatch
     function       GetIDsOfNames(const IID: TGUID; Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
     function       GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
     function       GetTypeInfoCount(out Count: Integer): HResult; stdcall;
     function       Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
     // Protected declarations
     function       GetEventName(Value: TDispID): String;
     function       GetEventIID(TypeLib: ITypeLib; DefaultIID: TIID; out EventIID: TIID): HResult;
     function       GetClassTypeInfo(ProvideClassInfo: IProvideClassInfo; out TypeInfo: ITypeInfo): HResult;
     procedure      LoadTypeEvents(Container: IConnectionPointContainer; TypeInfo: ITypeInfo);
     procedure      SetActive(Value: Boolean);
  public
     // Public declarations
     constructor    Create(Dispatch: IDispatch);
     destructor     Destroy; override;
     property       Active: Boolean read FActive write SetActive;
     property       EventNames: TStringList read FEvents;
     property       EventName[DispatchID: TDispID]: String read GetEventName;
     property       OnEvent: TOnEvent read FOnEvent write FOnEvent;
  end;

////////////////////////////////////////////////////////////////////////////////
//
//   GetGit
//
//      Returns     :  IGIT
//      Description :  Used to return an instance of the global interface table
//
////////////////////////////////////////////////////////////////////////////////
function   GetGIT: IGIT;

////////////////////////////////////////////////////////////////////////////////
//
//   GetEnumerator
//
//      Params      :  Dispatch - IDispatch interface to obtain enumerator from
//      Returns     :  IEnumerator
//      Description :  Used to obtain an instance of IEnumVariant from a Dispatch
//                     interface, and return it in an easy to use internal
//                     interface.
//
////////////////////////////////////////////////////////////////////////////////
function   GetEnumerator(Dispatch: IDispatch): IEnumerator;

////////////////////////////////////////////////////////////////////////////////
//
//   GetCOMObject
//
//      Params      :  Name - String containing a progid or moniker name, such as
//                     "winmgmts:\\"+ComputerName+"\root\cimv2"
//                     IID - Interface type to obtain
//                     Obj - On success, returns an interface whose type is that
//                     defined by IID
//      Returns     :  HResult - On success S_OK is returned, else the last error
//      Description :  Used to resolve a programmatic ID or name moniker to a
//                     running interface. Similar to VB's GetObject function.
//
////////////////////////////////////////////////////////////////////////////////
function   GetCOMObject(Name: String; IID: TGUID; out Obj): HResult;

////////////////////////////////////////////////////////////////////////////////
//
//   OleServerRun
//
//      Description :  This procedure can be used for OLE servers that do not
//                     implement any Delphi forms. The default Application calls
//                     in the Project's begin..end statement can be replaced with
//                     this single call.
//
////////////////////////////////////////////////////////////////////////////////
procedure  OleServerRun;

implementation

////////////////////////////////////////////////////////////////////////////////
//   Protected variables
////////////////////////////////////////////////////////////////////////////////
var
  hmtxSync:         THandle;
  pvGIT:            IGIT;

//// TEventDispatch ////////////////////////////////////////////////////////////
function TEventDispatch.GetEventName(Value: TDispID): String;
var  dwIndex:       Integer;
begin

  // Default result
  SetLength(result, 0);

  // Walk the event list to find the matching ID
  for dwIndex:=0 to Pred(FEvents.Count) do
  begin
     // Check object (which is the id)
     if (TDispID(FEvents.Objects[dwIndex]) = Value) then
     begin
        // Found the event
        result:=FEvents[dwIndex];
        // Done processing
        break;
     end;
  end;

end;

procedure TEventDispatch.SetActive(Value: Boolean);
begin

  // Check against current state
  if (FActive <> Value) then
  begin
     // Check connection point
     if Assigned(FConnection) then
     begin
        // Check desired state
        case Value of
           // Unsink
           False :
           begin
              // Unadvise
              if (FCookie = 0) then
                 // No sink set
                 FActive:=False
              else
              begin
                 // Unadvise
                 try
                    FConnection.Unadvise(FCookie);
                 finally
                    // Clear cookie
                    FCookie:=0;
                    // Update state
                    FActive:=False;
                 end;
              end
           end;
           // Sink
           True  :
           begin
              // Set the connection sink
              FActive:=Succeeded(FConnection.Advise(Self, FCookie));
           end;
        end;
     end;
  end;

end;

function TEventDispatch.QueryInterface(const iid: TGUID; out obj): HResult;
begin

  // Attempt to get the interface
  if GetInterface(IID, obj) then
     // Success
     result:=S_OK
  // Check interface event iid
  else if (IsEqualGUID(IID, FGuid) and GetInterface(IDispatch, Obj)) then
     // Success
     result:=S_OK
  else
     // Can't find a matching interface
     result:=E_NOINTERFACE;

end;

function TEventDispatch._AddRef: Integer;
begin

  // Maintain a count of one
  result:=1;

end;

function TEventDispatch._Release: Integer;
begin

  // Maintain a count of one
  result:=1;

end;

function TEventDispatch.GetIDsOfNames(const IID: TGUID; Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin

  // We can't resolve any names
  result:=DISP_E_UNKNOWNNAME;

end;

function TEventDispatch.GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult;
begin

  // No type info interface
  Pointer(TypeInfo):=nil;

  // Return failure
  result:=DISP_E_BADINDEX;

end;

function TEventDispatch.GetTypeInfoCount(out Count: Integer): HResult;
begin

  // No type info exposed
  Count:=0;

  // Success
  result:=S_OK;

end;

function TEventDispatch.Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult;
var  pdpParams:  PDispParams;
     ovParams:   OleVariant;
     dwCount:    Integer;
     dwIndex:    Integer;
begin

  // Get the parameters
  pdpParams:=@Params;

  // Events can only be called with method dispatch, not property get/set
  if ((Flags and DISPATCH_METHOD) > 0) then
  begin
     // Default parameters
     ovParams:=Unassigned;
     // Resource protection
     try
        // Create array large enough to hold the parameters (empty array allowed)
        ovParams:=VarArrayCreate([0, Pred(pdpParams^.cArgs)], varVariant);
        // Build a variant array from the parameters that were passed in.
        if (pdpParams^.cArgs > 0) then
        begin
           // Set starting index
           dwIndex:=0;
           // Reverse the order of the params because they are backwards
           for dwCount:=Pred(pdpParams^.cArgs) downto 0 do
           begin
              // Set the variant param
              ovParams[dwIndex]:=OleVariant(pdpParams^.rgvarg^[dwCount]);
              // Increment the next index
              Inc(dwIndex);
           end;
        end;
        // Check to see if VCL event is assigned
        if Assigned(FOnEvent) then FOnEvent(Self, DispID, ovParams);
     finally
        // Clear params
        ovParams:=Unassigned;
     end;
     // Just return success
     result:=S_OK;
  end
  else
     // Called with wrong flags
     result:=DISP_E_MEMBERNOTFOUND;

end;

function TEventDispatch.GetEventIID(TypeLib: ITypeLib; DefaultIID: TIID; out EventIID: TIID): HResult;
var  pvTypeInfo:    ITypeInfo;
     pvRefTypeInfo: ITypeInfo;
     lpRefAttr:     PTypeAttr;
     lpClassAttr:   PTypeAttr;
     dwRefType:     Cardinal;
     dwType:        Cardinal;
     dwIndex:       Integer;
     dwImpl:        Integer;
     dwFlags:       Integer;
     iidEvent:      TIID;
     iidDefault:    TIID;
begin

  // Set default result
  result:=E_FAIL;

  // Get the count of type info
  for dwIndex:=0 to Pred(TypeLib.GetTypeInfoCount) do
  begin
     // Get the type kind of the type info
     if Succeeded(TypeLib.GetTypeInfoType(dwIndex, dwType)) and (dwType = TKIND_COCLASS) then
     begin
        // Get the CoClass type info
        if Succeeded(TypeLib.GetTypeInfo(dwIndex, pvTypeInfo)) then
        begin
           // Resource protection
           try
              // Get the type attr for the coclass
              if Succeeded(pvTypeInfo.GetTypeAttr(lpClassAttr)) then
              begin
                 // Clear the iids used for final check
                 iidEvent:=GUID_NULL;
                 iidDefault:=GUID_NULL;
                 // Resource protection
                 try
                    // Walk the implemented types
                    for dwImpl:=0 to Pred(lpClassAttr^.cImplTypes) do
                    begin
                       // Get impl type flags
                       if Succeeded(pvTypeInfo.GetImplTypeFlags(dwImpl, dwFlags)) and ((dwFlags and IMPLTYPEFLAG_FDEFAULT) = IMPLTYPEFLAG_FDEFAULT) then
                       begin
                          // Get ref type from impl type
                          if Succeeded(pvTypeInfo.GetRefTypeOfImplType(dwImpl, dwRefType)) then
                          begin
                             // Get the type info
                             if Succeeded(pvTypeInfo.GetRefTypeInfo(dwRefType, pvRefTypeInfo)) then
                             begin
                                // Resource protection
                                try
                                   // Get the type attr
                                   if Succeeded(pvRefTypeInfo.GetTypeAttr(lpRefAttr)) then
                                   begin
                                      // Resource protection
                                      try
                                         // Capture the interface iid
                                         if ((dwFlags and IMPLTYPEFLAG_FSOURCE) = IMPLTYPEFLAG_FSOURCE) then
                                            // Set event iid
                                            iidEvent:=lpRefAttr^.guid
                                         else
                                            // Set default iid
                                            iidDefault:=lpRefAttr^.guid;
                                      finally
                                         // Release the type attr
                                         pvTypeInfo.ReleaseTypeAttr(lpRefAttr);
                                      end;
                                   end;
                                finally
                                   // Release the interface
                                   pvRefTypeInfo:=nil;
                                end;
                             end;
                          end;
                       end;
                    end;
                    // Check for match against the original type info
                    if IsEqualGuid(DefaultIID, iidDefault) then
                    begin
                       // Success if event iid is not a null guid
                       if not(IsEqualGuid(iidEvent, GUID_NULL)) then
                       begin
                          // Set outbound iid
                          EventIID:=iidEvent;
                          // Success
                          result:=S_OK;
                       end;
                       // Done either way
                       break;
                    end;
                 finally
                    // Release the type attr
                    pvTypeInfo.ReleaseTypeAttr(lpClassAttr);
                 end;
              end;
           finally
              // Release the interface
              pvTypeInfo:=nil
           end;
        end;
     end;
  end;

end;

function TEventDispatch.GetClassTypeInfo(ProvideClassInfo: IProvideClassInfo; out TypeInfo: ITypeInfo): HResult;
var  pvTypeInfo:    ITypeInfo;
     lpTypeAttr:    PTypeAttr;
     dwRefType:     Cardinal;
     dwTypes:       Integer;
     dwFlags:       Integer;
begin

  // Get the class info
  result:=ProvideClassInfo.GetClassInfo(pvTypeInfo);
  // Check result
  if Succeeded(result) then
  begin
     // Resource protection
     try
        // Get type attributes
        result:=pvTypeInfo.GetTypeAttr(lpTypeAttr);
        // Check result
        if Succeeded(result) then
        begin
           // Set default result
           result:=E_FAIL;
           // Resource protection
           try
              // Walk the implemented types
              for dwTypes:=0 to Pred(lpTypeAttr^.cImplTypes) do
              begin
                 // Get implemented type for this interface
                 if Succeeded(pvTypeInfo.GetImplTypeFlags(dwTypes, dwFlags)) then
                 begin
                    // Check for SOURCE and DEFAULT flags
                    if ((dwFlags and IMPLTYPEFLAG_FSOURCE) = IMPLTYPEFLAG_FSOURCE) and ((dwFlags and IMPLTYPEFLAG_FDEFAULT) = IMPLTYPEFLAG_FDEFAULT) then
                    begin
                       // This is the dispatch interface we are looking for
                       result:=pvTypeInfo.GetRefTypeOfImplType(dwTypes, dwRefType);
                       // Check result
                       if Succeeded(result) then
                       begin
                          // Get the reference type info
                          result:=pvTypeInfo.GetRefTypeInfo(dwRefType, TypeInfo);
                       end;
                       // Done processing
                       break;
                    end;
                 end;
              end;
           finally
              // Release the type attr
              pvTypeInfo.ReleaseTypeAttr(lpTypeAttr);
           end;
        end;
     finally
        // Release the interface
        pvTypeInfo:=nil;
     end;
  end;

end;

procedure TEventDispatch.LoadTypeEvents(Container: IConnectionPointContainer; TypeInfo: ITypeInfo);
var  lpTypeAttr:    PTypeAttr;
     lpFuncDesc:    PFuncDesc;
     lpwszMember:   PWideChar;
     szMember:      String;
     dwCount:       Integer;
begin

  // Get the type attr
  if Succeeded(TypeInfo.GetTypeAttr(lpTypeAttr)) then
  begin
     // Resource protection
     try
        // Have to be able to get the connection point for the iid
        if Succeeded(Container.FindConnectionPoint(lpTypeAttr^.guid, FConnection)) then
        begin
           // Update the internal GUID
           FGuid:=lpTypeAttr^.guid;
           // Iterate the functions and properties
           for dwCount:=0 to Pred(lpTypeAttr^.cFuncs) do
           begin
              // Iterate the function descriptions
              if Succeeded(TypeInfo.GetFuncDesc(dwCount, lpFuncDesc)) then
              begin
                 // Resource protection
                 try
                    // Clear member name
                    lpwszMember:=nil;
                    // Get function name
                    if Succeeded(TypeInfo.GetDocumentation(lpFuncDesc^.memid, @lpwszMember, nil, nil, nil)) then
                    begin
                       // Resource protection
                       try
                          // Convert name to ansi string
                          szMember:=OleStrToString(lpwszMember);
                          // Add the method name to the string list
                          FEvents.AddObject(szMember, Pointer(lpFuncDesc^.memid));
                       finally
                          // Free sys allocated string
                          SysFreeString(lpwszMember);
                       end;
                    end;
                 finally
                    // Release the func desc
                    TypeInfo.ReleaseFuncDesc(lpFuncDesc);
                 end;
              end;
           end;
        end;
     finally
        // Release the type attr
        TypeInfo.ReleaseTypeAttr(lpTypeAttr);
     end;
  end;

end;

constructor TEventDispatch.Create(Dispatch: IDispatch);
var  pvContainer:   IConnectionPointContainer;
     pvClassInfo:   IProvideClassInfo;
     pvTypeLib:     ITypeLib;
     pvDispTypeInfo:ITypeInfo;
     pvTypeInfo:    ITypeInfo;
     lpTypeAttr:    PTypeAttr;
     dwIndex:       Integer;
     iidEvent:      TIID;
begin

  // Perform inherited
  inherited Create;

  // Set defaults
  FGuid:=GUID_NULL;
  FActive:=False;
  FCount:=0;
  FCookie:=0;
  FEvents:=TStringList.Create;
  FConnection:=nil;

  // Check interface
  if Assigned(Dispatch) then
  begin
     // Get the connection point container for the dispatch
     if Succeeded(Dispatch.QueryInterface(IConnectionPointContainer, pvContainer)) then
     begin
        // Resource protection
        try
           // Attempt to get event information through IProvideClassInfo
           if Succeeded(Dispatch.QueryInterface(IProvideClassInfo, pvClassInfo)) then
           begin
              // Resource protection
              try
                 // Get the type information from the class info
                 if Succeeded(GetClassTypeInfo(pvClassInfo, pvTypeInfo)) then
                 begin
                    // Resource protection
                    try
                       // Load the type info events
                       LoadTypeEvents(pvContainer, pvTypeInfo);
                    finally
                       // Release the interface
                       pvTypeInfo:=nil;
                    end;
                 end;
              finally
                 // Release the interface
                 pvClassInfo:=nil;
              end;
           end
           else if Succeeded(Dispatch.GetTypeInfo(0, LOCALE_SYSTEM_DEFAULT, pvDispTypeInfo)) then
           begin
              // Resource protection
              try
                 // Get containing type lib
                 if Succeeded(pvDispTypeInfo.GetContainingTypeLib(pvTypeLib, dwIndex)) then
                 begin
                    // Resource protection
                    try
                       // Get the attributes so we can pass the default iid
                       if Succeeded(pvDispTypeInfo.GetTypeAttr(lpTypeAttr)) then
                       begin
                          // Resource protection
                          try
                             // Attempt to get the event id
                             if Succeeded(GetEventIID(pvTypeLib, lpTypeAttr^.guid, iidEvent)) then
                             begin
                                // Now look the typeinfo up in the type lib
                                if Succeeded(pvTypeLib.GetTypeInfoOfGuid(iidEvent, pvTypeInfo)) then
                                begin
                                   // Resource protection
                                   try
                                      // Load the type info events
                                      LoadTypeEvents(pvContainer, pvTypeInfo);
                                   finally
                                      // Release the interface
                                      pvTypeInfo:=nil;
                                   end;
                                end;
                             end;
                          finally
                             // Release the type attr
                             pvDispTypeInfo.ReleaseTypeAttr(lpTypeAttr);
                          end;
                       end;
                    finally
                       // Release the interface
                       pvTypeLib:=nil;
                    end;
                 end;
              finally
                 // Release the interface
                 pvDispTypeInfo:=nil;
              end;
           end;
        finally
           // Release the interface
           pvContainer:=nil;
        end;
     end;
  end;

end;

destructor TEventDispatch.Destroy;
begin

  // Resource protection
  try
     // Disconnect the events
     if Assigned(FConnection) then
     begin
        // Resource protection
        try
           // Unadvise
           if FActive then FConnection.Unadvise(FCookie);
        finally
           // Release connection point
           FConnection:=nil;
        end;
     end;
     // Free the string list
     FreeAndNil(FEvents);
  finally
     // Perform inherited
     inherited Destroy;
  end;

end;

//// TCircularInterface ////////////////////////////////////////////////////////
function TCircularInterface.QueryInterface(const IID: TGUID; out Obj): HResult;
begin

  // Query for the requested interface
  if GetInterface(IID, Obj) then
     // Success
     result:=S_OK
  else
     // No such interface
     result:=E_NOINTERFACE;

end;

function TCircularInterface._AddRef: Integer;
begin

  // Increment the reference count
  result:=InterlockedIncrement(FRefCount);

  // Handle the parent's ref count
  if (FRefCount > 1) and Assigned(FParent) then FParent._AddRef;

end;

function TCircularInterface._Release: Integer;
begin

  // Check ref count
  if (FRefCount > 0) then
  begin
     // Decrement
     result:=InterlockedDecrement(FRefCount);
     // Handle the parent's ref count
     if (FRefCount > 0) and Assigned(FParent) then FParent._Release;
  end
  else
     // Already at zero
     result:=0;

  // Destroy if at zero
  if (result = 0) then Destroy;

end;

procedure TCircularInterface.AfterConstruction;
begin

  // Release the constructor's implicit refcount
  InterlockedDecrement(FRefCount);

end;

procedure TCircularInterface.BeforeDestruction;
begin

  // Check ref count
  if (FRefCount <> 0) then
  begin
     // Throw exception
     raise Exception.CreateFmt('Reference count of %d during class object destruction!', [FRefCount]);
  end;

end;

function TCircularInterface.GetParent(iid: TGUID; out Obj): HResult;
begin

  // Check parent reference
  if Assigned(FParent) then
     // Query interface parent for desired interface
     result:=IUnknown(FParent).QueryInterface(iid, Obj)
  else
     // No parent interface
     result:=E_NOINTERFACE;

end;

constructor TCircularInterface.Create;
begin

  // Perform inherited
  inherited Create;

  // No parent
  FParent:=nil;

end;

constructor TCircularInterface.Create(Parent: TCircularInterface);
begin

  // Perform inherited
  inherited Create;

  // Set weak parent reference
  FParent:=Pointer(Parent);

end;

class function TCircularInterface.NewInstance: TObject;
begin

  // Allocate memory for new instance
  result:=inherited NewInstance;

  // Set ref count so we don't die during the constructor
  TCircularInterface(result).FRefCount:=1;

end;

//// TProxyDispatch ////////////////////////////////////////////////////////////
function TProxyDispatch.QueryInterface(const iid: TGUID; out Obj): HResult;
begin

  // Make sure we have an interface
  try
     if (FObject = nil) then
        // Return no interface
        result:=E_NOINTERFACE
     else
        // Pass the call to the proxied object
        result:=FObject.QueryInterface(iid, Obj)
  except
     // Catch the exception
     result:=E_UNEXPECTED;
  end;

end;

function TProxyDispatch._AddRef: Integer;
begin

  // Increment and return ref count
  result:=InterlockedIncrement(FRefCount);

end;

function TProxyDispatch._Release: Integer;
begin

  // Decrement and return ref count
  result:=InterlockedDecrement(FRefCount);

end;

function TProxyDispatch.GetIDsOfNames(const IID: TGUID; Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin

  // Make sure we have an interface
  try
     if (FObject = nil) then
        // Return no interface
        result:=E_NOINTERFACE
     else
        // Pass the call to the proxied object
        result:=FObject.GetIDsOfNames(IID, Names, NameCount, LocaleID, DispIDs);
  except
     // Catch the exception
     result:=E_UNEXPECTED;
  end;

end;

function TProxyDispatch.GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult;
begin

  // Make sure we have an interface
  try
     if (FObject = nil) then
        // Return no interface
        result:=E_NOINTERFACE
     else
        // Pass the call to the proxied object
        result:=FObject.GetTypeInfo(Index, LocaleID, TypeInfo);
  except
     // Catch the exception
     result:=E_UNEXPECTED;
  end;

end;

function TProxyDispatch.GetTypeInfoCount(out Count: Integer): HResult;
begin

  // Make sure we have an interface
  try
     if (FObject = nil) then
        // Return no interface
        result:=E_NOINTERFACE
     else
        // Pass the call to the proxied object
        result:=FObject.GetTypeInfoCount(Count);
  except
     // Catch the exception
     result:=E_UNEXPECTED;
  end;

end;

function TProxyDispatch.Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult;
begin

  // Call the BeforeInvoke if assigned
  if Assigned(FBInvoke) then FBInvoke(Self, DispID);

  // Make sure we have an interface
  try
     // Check interface
     if (FObject = nil) then
        // Return no interface
        result:=E_NOINTERFACE
     else
        // Pass the call to the proxied object
        result:=FObject.Invoke(DispID, IID, LocaleID, Flags, Params, VarResult, ExcepInfo, ArgErr);
  except
     // Catch the exception
     result:=E_UNEXPECTED;
  end;

  // Call the AfterInvoke if assigned
  if Assigned(FAInvoke) then FAInvoke(Self, DispID, result);

end;

function TProxyDispatch.GetOleProxy: OleVariant;
begin

  // Requesting the proxy wrapper interface as a variant.
  result:=IDispatch(Self);

end;

function TProxyDispatch.GetOleObject: OleVariant;
begin

  // Return the proxied interface
  result:=FObject;

end;

constructor TProxyDispatch.Create(Dispatch: IDispatch);
begin

  // Perform inherited
  inherited Create;

  // Retain a reference to the real com object
  FObject:=Dispatch;

  // Set the proxy wrapper ref count
  FRefCount:=0;

end;

destructor TProxyDispatch.Destroy;
begin

  // Resource protection
  try
     // Release the interface
     FObject:=nil;
  finally
     // Perform inherited
     inherited Destroy;
  end;

end;

//// TEnumValues ///////////////////////////////////////////////////////////////
function TEnumValues.GetCount: Integer;
begin

  // Return count of items
  result:=FValues.Count;

end;

function TEnumValues.GetNames(Index: Integer): String;
begin

  // Return the name at the given index
  result:=FValues.Names[Index];

end;

function TEnumValues.GetValues(Name: String): Integer;
begin

  // Return the value for the given name
  result:=StrToIntDef(FValues.Values[Name], (-1));

end;

function TEnumValues.Exists(Name: String): Boolean;
begin

  // Check to see if name exists in the list
  result:=not(FValues.IndexOfName(Name) < 0);

end;

procedure TEnumValues.Load(Dispatch: IDispatch);
var  pvTypeLib:     ITypeLib;
     pvEnumTypeInfo:ITypeInfo;
     pvTypeInfo:    ITypeInfo;
     lpEnumAttr:    PTypeAttr;
     lpVarDesc:     PVarDesc;
     lpwszName:     PWideChar;
     dwType:        Cardinal;
     dwCount:       Integer;
     dwValue:       Integer;
     dwIndex:       Integer;
begin
 
  // Check dispatch interface
  if Assigned(Dispatch) and Succeeded(Dispatch.GetTypeInfoCount(dwCount)) and (dwCount > 0) then
  begin
     // Get type info from dispatch
     if Succeeded(Dispatch.GetTypeInfo(0, LOCALE_SYSTEM_DEFAULT, pvTypeInfo)) then
     begin
        // Resource protection
        try
           // Get containing type lib
           if Succeeded(pvTypeInfo.GetContainingTypeLib(pvTypeLib, dwIndex)) then
           begin
              // Resource protection
              try
                 // Get the count of type info
                 for dwIndex:=0 to Pred(pvTypeLib.GetTypeInfoCount) do
                 begin
                    // Get the type kind of the type info
                    if Succeeded(pvTypeLib.GetTypeInfoType(dwIndex, dwType)) and (dwType = TKIND_ENUM) then
                    begin
                       // Get the enumeration type info
                       if Succeeded(pvTypeLib.GetTypeInfo(dwIndex, pvEnumTypeInfo)) then
                       begin
                          // Resource protection
                          try
                             // Get the type attr for the enumeration
                             if Succeeded(pvEnumTypeInfo.GetTypeAttr(lpEnumAttr)) then
                             begin
                                // Resource protection
                                try
                                   // Walk the variable names
                                   for dwCount:=0 to Pred(lpEnumAttr^.cVars) do
                                   begin
                                      // Get var description
                                      if Succeeded(pvEnumTypeInfo.GetVarDesc(dwCount, lpVarDesc)) then
                                      begin
                                         // Resource protection
                                         try
                                            // Check var information
                                            if Assigned(lpVarDesc^.lpvarValue) and (TVariantArg(lpVarDesc^.lpvarValue^).vt = VT_I4) then
                                            begin
                                               // Clear the name
                                               lpwszName:=nil;
                                               // Get the value as integer
                                               dwValue:=TVariantArg(lpVarDesc^.lpvarValue^).iVal;
                                               // Get documentation
                                               if Succeeded(pvEnumTypeInfo.GetDocumentation(lpVarDesc^.memid, @lpwszName, nil, nil, nil)) then
                                               begin
                                                  // Resource protection
                                                  try
                                                     // Add to string list
                                                     FValues.Add(Format('%s=%d', [OleStrToString(lpwszName), dwValue]));
                                                  finally
                                                     // Free the string
                                                     SysFreeString(lpwszName);
                                                  end;
                                               end;
                                            end;
                                         finally
                                            // Release the var description
                                            pvEnumTypeInfo.ReleaseVarDesc(lpVarDesc);
                                         end;
                                      end;
                                   end;
                                finally
                                   // Release the type attr
                                   pvEnumTypeInfo.ReleaseTypeAttr(lpEnumAttr);
                                end;
                             end;
                          finally
                             // Release the interface
                             pvEnumTypeInfo:=nil;
                          end;
                       end;
                    end;
                 end;
              finally
                 // Release the interface
                 pvTypeLib:=nil
              end;
           end;
        finally
           // Release the interface
           pvTypeInfo:=nil;
        end;
     end;
  end;

end;

constructor TEnumValues.Create(Dispatch: IDispatch);
begin

  // Perform inherited
  inherited Create;

  // Create string list for values
  FValues:=TStringList.Create;

  // Load the enumerated constant values
  if Assigned(Dispatch) then Load(Dispatch);

end;

destructor TEnumValues.Destroy;
begin

  // Resource protection
  try
     // Free the string list
     FValues.Free;
  finally
     // Peform inherited
     inherited Destroy;
  end;

end;

//// TMessageFilter ////////////////////////////////////////////////////////////
function TMessageFilter.QueryInterface(const iid: TGUID; out obj): HResult;
begin

  // Make sure we support IUnknown and IMessageFilter
  if GetInterface(iid, obj) then
     // Success
     result:=S_OK
  else
  begin
     // Clear passed interface pointer
     Pointer(obj):=nil;
     // Return error
     result:=E_NOINTERFACE;
  end;

end;

function TMessageFilter._AddRef: Integer;
begin

  // Increment and return ref count
  result:=InterlockedIncrement(FRefCount);

end;

function TMessageFilter._Release: Integer;
begin

  // Decrement and return ref count
  result:=InterlockedDecrement(FRefCount);

end;

function TMessageFilter.HandleInComingCall(dwCallType: Longint; htaskCaller: HTask; dwTickCount: Longint; lpInterfaceInfo: PInterfaceInfo): Longint;
begin

  // Notify the server that we are handling the call
  result:=SERVERCALL_ISHANDLED;

end;

function TMessageFilter.RetryRejectedCall(htaskCallee: HTask; dwTickCount: Longint; dwRejectType: Longint): Longint;
begin

  // Do not retry server rejected call
  if (dwRejectType = SERVERCALL_REJECTED) or (dwTickCount > FMaxWait) then
     // Cancel the call
     result:=(-1)
  else
     // Set retry for one second
     result:=FDelay;

end;

function TMessageFilter.MessagePending(htaskCallee: HTask; dwTickCount: Longint; dwPendingType: Longint): Longint;
var  lpMsg:         TMsg;
begin

  // Set default result
  result:=PENDINGMSG_WAITNOPROCESS;

  // Process message loop for process
  while PeekMessage(lpMsg, 0, 0, 0, PM_REMOVE) do
  begin
     // Check for BREAK key down message
     if (lpMsg.message = WM_KEYDOWN) and (lpMsg.wParam = VK_CANCEL) then
     begin
        // Cancel the current call
        result:=PENDINGMSG_CANCELCALL;
        // Done processing the message loop
        break;
     end;
     // Translate the message
     TranslateMessage(lpMsg);
     // Dispatch the message
     DispatchMessage(lpMsg);
  end;

end;

constructor TMessageFilter.Create;
begin

  // Perform inherited
  inherited Create;

  // Set defaults
  FRefCount:=0;
  FDelay:=1000;
  FMaxWait:=5000;

  // Register the instance of this message filter
  if Failed(CoRegisterMessageFilter(Self, FOldFilter)) then FOldFilter:=nil;

end;

destructor TMessageFilter.Destroy;
var  pvFilter:      IMessageFilter;
begin

  // Resource protection
  try
     // Resource protection
     try
        // Unregister the message filter
        if Succeeded(CoRegisterMessageFilter(FOldFilter, pvFilter)) then pvFilter:=nil;
     finally
        // Release old message filter interface
        FOldFilter:=nil;
     end;
  finally
     // Perform inherited
     inherited Destroy;
  end;

end;

//// TEnumerator ///////////////////////////////////////////////////////////////
procedure TEnumerator.GetEnumVariant(Dispatch: IDispatch);
var  pdParams:      TDispParams;
     ovEnum:        OleVariant;
begin

  // Check interface
  if Assigned(Dispatch) then
  begin
     // Clear disp params
     FillChar(pdParams, SizeOf(TDispParams), 0);
     // Get enumerator
     OleCheck(Dispatch.Invoke(DISPID_NEWENUM, GUID_NULL, LOCALE_SYSTEM_DEFAULT, DISPATCH_PROPERTYGET or DISPATCH_METHOD, pdParams, @ovEnum, nil, nil));
     // Resource protection
     try
        // Check returned interface
        if (TVariantArg(ovEnum).vt = VT_UNKNOWN) then
           // Query interface for the IEnumVariant
           OleCheck(IUnknown(ovEnum).QueryInterface(IEnumVariant, FEnumVariant))
        else
           // Throw error
           OleError(E_NOINTERFACE);
     finally
        // Clear interface
        ovEnum:=Unassigned;
     end;
  end
  else
     // Throw error
     OleError(E_NOINTERFACE);

end;

function TEnumerator.ForEach(out Obj: OleVariant): Boolean;
var  dwFetch:       Cardinal;
begin

  // Get the next item
  result:=(FEnumVariant.Next(1, Obj, dwFetch) = S_OK) and (dwFetch = 1);

end;

function TEnumerator.ForEachObject(const IID: TGUID; out Obj): Boolean;
var  ovItem:        OleVariant;
begin

  // Get next item as OleVariant
  if ForEach(ovItem) then
  begin
     // Resource protection
     try
        // Check interface for IUknown
        if (TVariantArg(ovItem).vt = VT_UNKNOWN) then
           // Query interface for the desired interface
           result:=(IUnknown(ovItem).QueryInterface(IID, Obj) = S_OK)
        // Check interface for IDispatch
        else if (TVariantArg(ovItem).vt = VT_DISPATCH) then
           // Query interface for the desired interface
           result:=(IDispatch(ovItem).QueryInterface(IID, Obj) = S_OK)
        else
        begin
           // Pacify the compiler
           result:=False;
           // Throw error
           OleError(E_NOINTERFACE);
        end;
     finally
        // Clear obtained item
        ovItem:=Unassigned;
     end;
  end
  else
     // Failed to get item
     result:=False;

end;

function TEnumerator.Reset: Boolean;
begin

  // Reset enumerator
  result:=(FEnumVariant.Reset = S_OK);

end;

function TEnumerator.Skip(Count: LongWord): Boolean;
begin

  // Skip items in enumerator
  result:=(FEnumVariant.Skip(Count) = S_OK);

end;

function TEnumerator.Clone: IEnumerator;
var  pvEnum:        IEnumVariant;
begin

  // Clone
  if (FEnumVariant.Clone(pvEnum) = S_OK) then
  begin
     // Resource protection
     try
        // Return wrapper
        result:=TEnumerator.CreateWrapper(pvEnum);
     finally
        // Release interface
        pvEnum:=nil;
     end
  end
  else
     // Return nil
     result:=nil;

end;

constructor TEnumerator.CreateWrapper(EnumVariant: IEnumVariant);
begin

  // Perform inherited
  inherited Create;

  // Check interface pointer
  if Assigned(EnumVariant) then
     // Bind to the passed interface
     FEnumVariant:=EnumVariant
  else
     // Throw error
     OleError(E_NOINTERFACE);

end;

constructor TEnumerator.Create(Dispatch: IDispatch);
begin

  // Perform inherited
  inherited Create;

  // Get enumerator interface
  GetEnumVariant(Dispatch);

end;

destructor TEnumerator.Destroy;
begin

  // Resource protection
  try
     // Release the interface
     FEnumVariant:=nil;
  finally
     // Perform inherited
     inherited Destroy;
  end;

end;

//// TComRegistration //////////////////////////////////////////////////////////
function TComRegistration.GetLoaded: Boolean;
begin

  // Do we have a library loaded?
  result:=(FLibHandle <> 0);

end;

function TComRegistration.GetAvailableActions: TRegActionTypes;
begin

  // Set default result set
  result:=[];

  // Check loaded state
  if GetLoaded then
  begin
     // Check function table
     if Assigned(@FFunctions.lpRegister) then Include(result, raRegister);
     if Assigned(@FFunctions.lpUnregister) then Include(result, raUnregister);
  end;

end;

function TComRegistration.GetIsComLibrary: Boolean;
begin

  // Is this an ActiveX library
  result:=GetLoaded and (Assigned(@FFunctions.lpRegister) and Assigned(@FFunctions.lpUnregister));

end;

function TComRegistration.Load(LibraryName: String): Integer;
begin

  // Unload first
  Unload;

  // Attempt to load the libary
  FLibHandle:=LoadLibrary(PChar(LibraryName));

  // Get result status
  if (FLibHandle = 0) then
     // Return last error
     result:=GetLastError
  else
  begin
     // Get the function addresses
     @FFunctions.lpRegister:=GetProcAddress(FLibHandle, 'DllRegisterServer');
     @FFunctions.lpUnregister:=GetProcAddress(FLibHandle, 'DllUnregisterServer');
     // Success
     result:=ERROR_SUCCESS;
  end;

end;

function TComRegistration.Perform(Action: TRegActionType): HResult;
begin

  // Check loaded state
  if not(GetLoaded) then
     // Failure
     result:=ERROR_MOD_NOT_FOUND
  else
  begin
     // Check the functions
     case Action of
        // Register
        raRegister  :
        begin
           // Check function
           if Assigned(@FFunctions.lpRegister) then
              // Call the function
              result:=FFunctions.lpRegister
           else
              // No function
              result:=ERROR_PROC_NOT_FOUND;
        end;
        // Unregister
        raUnregister:
        begin
           // Check function
           if Assigned(@FFunctions.lpUnregister) then
              // Call the function
              result:=FFunctions.lpUnregister
           else
              // No function
              result:=ERROR_PROC_NOT_FOUND;
        end;
     else
        // Unknown action
        result:=ERROR_INVALID_PARAMETER;
     end;
  end;

end;

procedure TComRegistration.Unload;
begin

  // Clear the function table
  FillChar(FFunctions, SizeOf(TRegFunctions), 0);

  // Unload any loaded library
  if (FLibHandle > 0) then
  begin
     // Resource protection
     try
        // Free the library
        FreeLibrary(FLibHandle);
     finally
        // Clear the library handle
        FLibHandle:=0;
     end;
  end;

end;

constructor TComRegistration.Create;
begin

  // Perform inherited
  inherited;

  // Set starting defaults
  FLibHandle:=0;
  FillChar(FFunctions, SizeOf(TRegFunctions), 0);

end;

destructor TComRegistration.Destroy;
begin

  // Resource protection
  try
     // Make sure everything is unloaded
     Unload;
  finally
     // Perform inherited
     inherited Destroy;
  end;

end;

//// TGIT //////////////////////////////////////////////////////////////////////
function TGIT.GetComObject: IUnknown;
begin

  // Wait for mutex
  WaitForSingleObject(hmtxSync, INFINITE);

  // Resource protection
  try
     // Get the interface from the git
     OleCheck(GetGIT.GetInterfaceFromGlobal(FCookie, FInterface, result));
  finally
     // Release ownership of mutex
     ReleaseMutex(hmtxSync);
  end;

end;

constructor TGIT.Create(IID: TGUID; Unknown: IUnknown);
begin

  // Perform inherited
  inherited Create;

  // Set defaults
  FInterface:=IID;

  // Wait for mutex
  WaitForSingleObject(hmtxSync, INFINITE);

  // Resource protection
  try
     // Register in git
     OleCheck(GetGIT.RegisterInterfaceInGlobal(Unknown, IID, FCookie));
  finally
     // Release ownership of mutex
     ReleaseMutex(hmtxSync);
  end;

end;

destructor TGIT.Destroy;
begin

  // Resource protection
  try
     // Wait for mutex
     WaitForSingleObject(hmtxSync, INFINITE);
     // Resource protection
     try
        // Unregister the interface
        GetGIT.RevokeInterfaceFromGlobal(FCookie);
     finally
        // Release ownership of mutex
        ReleaseMutex(hmtxSync);
     end;
  finally
     // Perform inherited
     inherited Destroy;
  end;

end;

//// Global functions //////////////////////////////////////////////////////////
procedure OleServerRun;
var  lpMsg:         TMsg;
begin

  // Call InitProc for the program
  if Assigned(InitProc) then TProcedure(InitProc);

  // Check start mode, exit if register or unregister
  if FindCmdLineSwitch('REGSERVER', ['-', '/'], True) or FindCmdLineSwitch('UNREGSERVER', ['-', '/'], True) then Exit;

  // Running in Automation mode, enter the standard message handling loop
  while GetMessage(lpMsg, 0, 0, 0) do
  begin
     // Translate message
     TranslateMessage(lpMsg);
     // Dispatch
     DispatchMessage(lpMsg);
  end;

end;

function GetCOMObject(Name: String; IID: TGUID; out Obj): HResult;
var  pvUnknown:     IUnknown;
     pvMoniker:     IMoniker;
     pvBindCtx:     IBindCtx;
     lpwszName:     PWideChar;
     cbEaten:       LongInt;
     guidCLSID:     TGUID;
begin

  // Attempt to get the CLSID from a possible programmatic id
  result:=CLSIDFromProgID(PWideChar(WideString(Name)), guidCLSID);

  // Check result
  if Succeeded(result) then
  begin
     // Check running object table
     result:=GetActiveObject(guidCLSID, nil, pvUnknown);
     // Check result
     if Succeeded(result) then
     begin
        // Resource protection
        try
           // QI for the desired interface
           result:=pvUnknown.QueryInterface(IID, Obj);
        finally
           // Release the interface
           pvUnknown:=nil;
        end;
     end;
  end
  else
  begin
     // Try to access the object using a moniker
     result:=CreateBindCtx(0, pvBindCtx);
     // Check result
     if Succeeded(result) then
     begin
        // Resource protection
        try
           // Convert name to bstr value
           lpwszName:=StringToOleStr(Name);
           // Resource protection
           try
              // Attempt to parse the moniker display name
              result:=MkParseDisplayName(pvBindCtx, lpwszName, cbEaten, pvMoniker);
              // Check result code
              if Succeeded(result) then
              begin
                 // Resource protection
                 try
                    // Attempt to bind the moniker
                    result:=BindMoniker(pvMoniker, 0, IID, Obj);
                 finally
                    // Release the interface
                    pvMoniker:=nil;
                 end;
              end;
           finally
              // Release the string
              SysFreeString(lpwszName);
           end;
        finally
           // Release the interface
           pvBindCtx:=nil;
        end;
     end;
  end;

end;

function GetEnumerator(Dispatch: IDispatch): IEnumerator;
begin

  // Create class and return interface
  result:=TEnumerator.Create(Dispatch);

end;

function GetGIT: IGIT;
begin

  // Access mutex
  WaitForSingleObject(hmtxSync, INFINITE);

  // Resource protection
  try
     // Check assignment
     if Assigned(pvGIT) then
        // Return pointer to global interface table
        result:=pvGIT
     else
     begin
        // Create new instance of global interface table
        OleCheck(CoCreateInstance(CLSID_GIT, nil, CLSCTX_ALL, IGIT, pvGIT));
        // Return instance
        result:=pvGIT;
     end;
  finally
     // Release the mutex
     ReleaseMutex(hmtxSync);
  end;

end;

initialization

  // Create mutex for synchronization
  hmtxSync:=CreateMutex(nil, False, 'ComUtils');

finalization

  // Release the global interface pointer
  pvGIT:=nil;

  // Release the mutex
  CloseHandle(hmtxSync);

end.

 
