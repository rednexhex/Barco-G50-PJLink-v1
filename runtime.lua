

-- Control Aliases
IPAddress = Controls.IPAddress
Port=Controls.Port
Password=Controls.Password
ManufacturerFB = Controls.Manufacturer
ModelFB = Controls.Model
PrjNameFB = Controls.DeviceName
SerialNumber = Controls.SerialNumber
SWVersion = Controls.DeviceFirmware
PowerStatusFB = Controls.PowerStatus
LampHrsFB1 = Controls.LampHours[1]
LampHrsFB2 = Controls.LampHours[2]
Status = Controls.Status
LampHrs2 = Controls.LampText
FilterHrs = Controls.FilterHours
FilterHrsLabel = Controls.FilterText
ReplacementFilter = Controls.ReplacementFilter
ReplacementLamp = Controls.ReplacementLamp
Power = Controls.Power
PwrOn = Controls.ProjOn
PwrOff = Controls.ProjOff
AVMute = Controls.AVMute
Freeze = Controls.VideoFreeze
RGBNo = Controls.NoRGB
VidNo = Controls.NoVid
DigNo = Controls.NoDig
StoNo = Controls.NoSto
NetNo = Controls.NoNet
IntNo = Controls.NoInternal


-- Global Constants
H = "%1"
CR = "\r"
PowerOn = { 40, 197, 38 }
PowerOff = { 255, 50, 50 }
WarmUp = { 255, 242, 62 }
PollRate = Properties["Poll Rate"].Value
WarmupTimeout = Properties["Warmup Time"].Value
InputCount = Properties["Input Count"].Value


-- Global Variables
PowerStatus = false
DebugTx=false
DebugRx=false
DebugFunction=false
DebugPrint=Properties["Debug Print"].Value
InputSwitchResponse = ""
CurrentInputNameRequest = nil
WarmupTime = false


--Commands; Does not include header, transmission parameters or <CR>
cmds = {
  --Control Commands
  ["pwr"   ] = { "POWR "   , "Power Instruction"            },
  ["input" ] = { "INPT "   , "Input Instruction"            },
  ["mute"  ] = { "AVMT "   , "Audio/Video Mute Instruction" },
  ["frez"  ] = { "FREZ "   , "Video Freeze Instruction"     },
  --Query Commands
  ["manufq"  ] = { "INF1 ?" , "Manufacturer Query"           },
  ["modelq"  ] = { "INF2 ?" , "Model Query"                  },
  ["swverq"  ] = { "SVER ?" , "Software Version Query"       },
  ["snumq"   ] = { "SNUM ?" , "Serial Number Query"          },
  ["infoq"   ] = { "INFO ?" , "Information Query"            },
  ["pwrq"    ] = { "POWR ?" , "Power Status Query"           },
  ["inptq"   ] = { "INPT ?" , "Input selection query"        },
  ["inptnq"  ] = { "INNM ?" , "Input Terminal Name query"    },
  ["errorq"  ] = { "ERST ?" , "Error Status Query"           },
  ["lampq"   ] = { "LAMP ?" , "Lamp query"                   },
  ["filterq" ] = { "FILT ?" , "Filter hours query"           },
  ["nameq"   ] = { "NAME ?" , "Projector/Display Name Query" },
  ["classq"  ] = { "CLSS ?" , "Class Information Query"      },
  ["inlistq" ] = { "INST ?" , "Input List Query"             },
  ["muteq"   ] = { "AVMT ?" , "Audio/Video Mute Query"       },
  ["frezq"   ] = { "FREZ ?" , "Video Freeze Query"           },
  ["iresq"   ] = { "IRES ?" , "Input Resolution Query"       },
  ["rresq"   ] = { "RRES ?" , "Recommended Resolution Query" },
  ["rlampq"  ] = { "RLMP ?" , "Replacement Lamp Query"       },
  ["rfiltq"  ] = { "RFIL ?" , "Replacement Filter Query"     }
}

if not Properties["Uppercase Messages"].Value then
  for key,value in pairs(cmds)do
    value[1] = string.lower(value[1])
  end
end


--Init States
LampHrs2.String = "Lamp 2:"
ConnectionStatus = "Disconnected"
Power.Boolean = false
RGBNo.String, VidNo.String, DigNo.String, StoNo.String, NetNo.String, IntNo.String = "Input not available", "Input not available", "Input not available", "Input not available", "Input not available", "Input not available"
status_state = {OK=0,COMPROMISED=1,FAULT=2,NOTPRESENT=3,MISSING=4,INITIALIZING=5}


--Input tables
RGBin,Videoin,Digitalin,Storagein,Networkin,Internalin = {},{},{},{},{},{}


-- Timers
Heartbeat = Timer.New()
WarmupTimer = Timer.New()
RetryTimer = Timer.New()
VolTimer = Timer.New()


-- Sockets
PJLink = TcpSocket.New()
PJLink.ReconnectTimeout = 5
PJLink.ReadTimeout = math.max(10, WarmupTimeout+1)
PJLink.WriteTimeout = math.max(10, WarmupTimeout+1)


-- Functions
-- A function to determine common print statement scenarios for troubleshooting
function SetupDebugPrint()
  if DebugPrint=="Tx/Rx" then
    DebugTx,DebugRx=true,true
  elseif DebugPrint=="Tx" then
    DebugTx=true
  elseif DebugPrint=="Rx" then
    DebugRx=true
  elseif DebugPrint=="Function Calls" then
    DebugFunction=true
  elseif DebugPrint=="All" then
    DebugTx,DebugRx,DebugFunction=true,true,true
  end
end

function Connect()
  if DebugFunction then print("Connect() called") end
  Heartbeat:Stop()
  if PJLink.IsConnected then
    PJLink:Disconnect()
  end
  ConnectionStatus = "Initializing"
  PJLink:Connect(ipaddress,Port.Value)
end

function ReportStatus(state,msg)
  if DebugFunction then print("ReportStatus() called") end
  if state == "OK" and Properties["Poll Errors"].Value then
    for j,name in ipairs({"Fan", "Lamp", "Temperature", "Cover", "Filter", "Other"}) do
      if Controls[name.."Status"][2].Boolean then
        msg = msg .. " " .. name .. " warning;"
        state = "COMPROMISED"
      elseif Controls[name.."Status"][3].Boolean then
        msg = msg .. " " .. name .. " fault;"
        state = "COMPROMISED"
      end
    end
  end
  Status.Value = status_state[state]
  Status.String = msg
end

function Init()
  if DebugFunction then print("Init() called") end
  Disconnected()
  ipaddress = IPAddress.String
  password = Password.String
  if ipaddress ~= "" then
    Connect()
  else
    ReportStatus("MISSING","No IP Address")
  end
end

function Disconnected()
  if DebugFunction then print("Disconnected() called") end
  for i,obj in ipairs({ManufacturerFB, ModelFB, PrjNameFB, LampHrsFB1, LampHrsFB2, PowerStatusFB, SWVersion, SerialNumber, FilterHrs, ReplacementFilter, ReplacementLamp}) do
    obj.String = "Connect Device"
  end
  RGBin,Videoin,Digitalin,Storagein,Networkin,Internalin = {},{},{},{},{},{}
  ConnectionStatus = "Disconnected"
  Heartbeat:Stop()
  WarmupTimer:Stop()
  if PJLink.IsConnected then
    PJLink:Disconnect()
  end
  HideInputs()
  DisableErrorStatus()
end

function Send(cmd)
  if DebugFunction then print("Send() called") end
  if PJLink.IsConnected then
    if DebugTx then print("TX: "..cmd) end
    PJLink:Write(cmd..CR)
  end
end

function Authenticate(resp)
  if DebugFunction then print("Authenticate() called") end
  ConnectionStatus = "Authenticated"
  local init = "%1"..cmds["classq"][1]
  Send(tostring(resp and resp or "")..init)
end

  -- Manage Input Buttons
function HideInputs()
  if DebugFunction then print("HideInputs() called") end
  for i=1,InputCount do
    Controls['RGB'][i].IsInvisible = true
    Controls['Video'][i].IsInvisible = true
    Controls['Digital'][i].IsInvisible = true
    Controls['Storage'][i].IsInvisible = true
    Controls['Network'][i].IsInvisible = true
    Controls['Internal'][i].IsInvisible = true
    Controls['RGBName'][i].IsInvisible = true
    Controls['VideoName'][i].IsInvisible = true
    Controls['DigitalName'][i].IsInvisible = true
    Controls['StorageName'][i].IsInvisible = true
    Controls['NetworkName'][i].IsInvisible = true
    Controls['InternalName'][i].IsInvisible = true
  end
  InputSwitchResponse = ""
  RGBNo.IsInvisible = false
  VidNo.IsInvisible = false
  DigNo.IsInvisible = false
  StoNo.IsInvisible = false
  NetNo.IsInvisible = false
  IntNo.IsInvisible = false
end

function ShowInputs(r, v, d, s, n, internal)
  if DebugFunction then print("ShowInputs() called") end
  if r > 0 then RGBNo.IsInvisible = true end
  if v > 0 then VidNo.IsInvisible = true end
  if d > 0 then DigNo.IsInvisible = true end
  if s > 0 then StoNo.IsInvisible = true end
  if n > 0 then NetNo.IsInvisible = true end
  if internal > 0 then IntNo.IsInvisible = true end
  for i=1, math.min(InputCount, r) do
    Controls['RGB'][i].IsInvisible = false
    Controls['RGBName'][i].IsInvisible = false
  end
  for i=1, math.min(InputCount, v) do
    Controls['Video'][i].IsInvisible = false
    Controls['VideoName'][i].IsInvisible = false
  end
  for i=1, math.min(InputCount, d) do
    Controls['Digital'][i].IsInvisible = false
    Controls['DigitalName'][i].IsInvisible = false
  end
  for i=1, math.min(InputCount, s) do
    Controls['Storage'][i].IsInvisible = false
    Controls['StorageName'][i].IsInvisible = false
  end
  for i=1, math.min(InputCount, n) do
    Controls['Network'][i].IsInvisible = false
    Controls['NetworkName'][i].IsInvisible = false
  end
  for i=1, math.min(InputCount, internal) do
    Controls['Internal'][i].IsInvisible = false
    Controls['InternalName'][i].IsInvisible = false
  end
end

function DisableErrorStatus()
  if DebugFunction then print("DisableErrorStatus() called") end
  for i,name in ipairs({"Fan","Lamp","Temperature","Cover","Filter","Other"}) do
    for j=1,3 do
      Controls[name.."Status"][j].Boolean = false
    end
  end
end

function CurrentInput(InputNum)
  if DebugFunction then print("CurrentInput() called") end
  if InputNum:sub(1,3) == "ERR" then
    print("Error retrieving current input")
    return
  end
  for k,v in pairs(RGBin) do
    if string.match(RGBin[k], InputNum) then
      Controls['RGB'][k].Value = true
      Controls["SelectedRGB"][k].Boolean = true
    else
      Controls['RGB'][k].Value = false
      Controls["SelectedRGB"][k].Boolean = false
    end
  end
  for k,v in pairs(Videoin) do
    if string.match(Videoin[k], InputNum) then
      Controls['Video'][k].Value = true
      Controls["SelectedVideo"][k].Boolean = true
    else
      Controls['Video'][k].Value = false
      Controls["SelectedVideo"][k].Boolean = false
    end
  end  
  for k,v in pairs(Digitalin) do
    if string.match(Digitalin[k], InputNum) then
      Controls['Digital'][k].Value = true
      Controls["SelectedDigital"][k].Boolean = true
    else
      Controls['Digital'][k].Value = false
      Controls["SelectedDigital"][k].Boolean = false
    end
  end
  for k,v in pairs(Storagein) do
    if string.match(Storagein[k], InputNum) then
      Controls['Storage'][k].Value = true
      Controls["SelectedStorage"][k].Boolean = true
    else
      Controls['Storage'][k].Value = false
      Controls["SelectedStorage"][k].Boolean = false
    end
  end
  for k,v in pairs(Networkin) do
    if string.match(Networkin[k], InputNum) then
      Controls['Network'][k].Value = true
      Controls["SelectedNetwork"][k].Boolean = true
    else
      Controls['Network'][k].Value = false
      Controls["SelectedNetwork"][k].Boolean = false
    end
  end
  for k,v in pairs(Internalin) do
    if string.match(Internalin[k], InputNum) then
      Controls['Internal'][k].Value = true
      Controls["SelectedInternal"][k].Boolean = true
    else
      Controls['Internal'][k].Value = false
      Controls["SelectedInternal"][k].Boolean = false
    end
  end
end


  -- Polling
  -- Init Queries
function ProjectorNamePoll()
  Send("%1"..cmds["nameq"][1])
end

function ManufacturerPoll()
  Send("%1"..cmds["manufq"][1])
end

function ModelPoll()
  Send("%1"..cmds["modelq"][1])
end

function SerialNumberPoll()
  Send("%2"..cmds["snumq"][1])
end

function SWVersionPoll()
  Send("%2"..cmds["swverq"][1])
end

function ReplacementLampPoll()
  Send("%2"..cmds["rlampq"][1])
end

function ReplacementFilterPoll()
  Send("%2"..cmds["rfiltq"][1])
end

  -- Repeated Queries
function PowerPoll()
  Send("%1"..cmds["pwrq"][1])
end

function ErrorStatusPoll()
  if Properties["Poll Errors"].Value then
    Send("%1"..cmds["errorq"][1])
  else
    LampHrsPoll()
  end
end

function LampHrsPoll()
  if Properties["Poll Lamp"].Value then
    Send("%1"..cmds["lampq"][1])
  else
    InputPoll()
  end
end

function InputPoll()
  if Controls["PJJLinkClass"].Value == 2.0 then
    Send("%2"..cmds["inptq"][1])
  else
    Send("%1"..cmds["inptq"][1])
  end
end

function InputTypePoll()
  if Controls["PJJLinkClass"].Value == 2.0 then
    Send("%2"..cmds["inlistq"][1])
  else
    Send("%1"..cmds["inlistq"][1])
  end
end

function MutePoll()
  Send("%1"..cmds["muteq"][1])
end

function FreezePoll()
  Send("%2"..cmds["frezq"][1])
end

function InputResolutionPoll()
  if Properties["Poll Resolution"].Value then
    Send("%2"..cmds["iresq"][1])
  else
    FilterPoll()
  end
end

function RecommendedResolutionPoll()
  Send("%2"..cmds["rresq"][1])
end

function FilterPoll()
  if Properties["Poll Filters"].Value then
    Send("%2"..cmds["filterq"][1])
  end
end

  -- Input Name queries (one execution per update to input list)
function SendIfNameUnknown(target, inputNumber)
  if target.String == "" then
    CurrentInputNameRequest = target
    Send("%2"..cmds["inptnq"][1]..inputNumber)
    return true
  end
  return false
end

function InputNamePoll()
  if DebugFunction then print("InputNamePoll() called") end
  for key, array in pairs({ ["RGBName"] = RGBin, ["VideoName"] = Videoin, ["DigitalName"] = Digitalin, ["StorageName"] = Storagein, ["NetworkName"] = Networkin, ["InternalName"] = Internalin }) do
    for i,inputNumber in ipairs(array) do
      if SendIfNameUnknown( Controls[key][i], inputNumber) then
        return 
      end
    end
  end
end

  -- Parsers
function DeviceInfoParser(data)
  if DebugFunction then print("DeviceInfoParser() called") end
  local cmd = data:match("^%%[12](%w+)")
  if data:match("=(.+)") then
    param = data:match("=(.+)")
  else
    param = ""
  end
  if cmd ~= nil then
    if Properties["Uppercase Messages"].Value then
      cmd=string.upper(cmd)
    else
      cmd=string.lower(cmd)
    end
    -- Intial Connection poll sequence
    if cmd:find(cmds["classq"][1]) then
      ClassParser(param)
      ProjectorNamePoll()
    elseif cmd:find(cmds["nameq"][1]) then
      NameParser(param)
      ManufacturerPoll()
    elseif cmd:find(cmds["manufq"][1]) then
      ManufacturerParser(param)
      ModelPoll()
    elseif cmd:find(cmds["modelq"][1]) then
      ModelParser(param)
      if Controls["PJJLinkClass"].Value == 2.0 then
        SerialNumberPoll()
      end
    elseif cmd:find(cmds["snumq"][1]) then
      SerialNumberParser(param)
      SWVersionPoll()
    elseif cmd:find(cmds["swverq"][1]) then
      SWVersionParser(param)
      ReplacementLampPoll()
    elseif cmd:find(cmds["rlampq"][1]) then
      ReplacementLampParser(param)
      ReplacementFilterPoll()
    elseif cmd:find(cmds["rfiltq"][1]) then
      ReplacementFilterParser(param)
      
    -- Polling Loop Monitor Sequence
    elseif cmd:find(cmds["pwrq"][1]) then
      PowerParser(param)
      if Properties["Power Off Polling"].Value or Power.Boolean then
        ErrorStatusPoll()
      end
    elseif cmd:find(cmds["errorq"][1]) then
      ErrorStatusParser(param)
      LampHrsPoll()
    elseif cmd:find(cmds["lampq"][1]) then
      LampHrsParser(param)
      InputPoll()
    elseif cmd:find(cmds["inptq"][1]) then
      CurrentInput(param)
      InputTypePoll()
    elseif cmd:find(cmds["inlistq"][1]) then
      InputsParser(param)
      MutePoll()
    elseif cmd:find(cmds["muteq"][1]) then
      MuteParser(param)
      if Controls["PJJLinkClass"].Value == 2.0 then
        FreezePoll()
      end
    elseif cmd:find(cmds["frezq"][1]) then
      FreezeParser(param)
      InputResolutionPoll()
    elseif cmd:find(cmds["iresq"][1]) then
      InputResolutionParser(param)
      RecommendedResolutionPoll()
    elseif cmd:find(cmds["rresq"][1]) then
      RecommendedResolutionParser(param)
      FilterPoll()
    elseif cmd:find(cmds["filterq"][1]) then
      FilterHrsParser(param)
    elseif cmd:find(cmds["inptnq"][1]) then
      InputNameParser(param)
    end
  else
    print("Unprocessed data: "..data)
  end
end

function ClassParser(param)
  if DebugFunction then print("ClassParser() called") end
  Controls["PJJLinkClass"].Value = param
  if Controls["PJJLinkClass"].Value == 2.0 then
    FilterHrs.IsInvisible = false
    FilterHrsLabel.IsInvisible = false
    Freeze.IsInvisible = false
    Controls.SerialNumber.String = "Unavailable"
    Controls.DeviceFirmware.String = "Unavailable"
  else
    FilterHrs.IsInvisible = true
    FilterHrsLabel.IsInvisible = true
    Freeze.IsInvisible = true
  end
end

function NameParser(Name)
  if DebugFunction then print("NameParser() called") end
  if Name:sub(1,3) == "ERR" or Name == "" then
    PrjNameFB.String = "Name not available"
  else
    PrjNameFB.String = Name
  end
end

function ManufacturerParser(Manufacturer)
  if DebugFunction then print("ManufacturerParser() called") end
  if Manufacturer == "ERR2" or Manufacturer == "ERR3" or Manufacturer == "" then
    ManufacturerFB.String = "Manufacturer not available"
  else
    ManufacturerFB.String = Manufacturer
  end
end

function ModelParser(Model)
  if DebugFunction then print("ModelParser() called") end
  if Model == "ERR2" or Model == "" then
    ModelFB.String = "Model not available"
  else
    ModelFB.String = Model
  end
end

function SerialNumberParser(SerialNum)
  if DebugFunction then print("SerialNumberParser() called") end
  if SerialNum:sub(1,3) == "ERR" or SerialNum == "" then
    SerialNumber.String = "Unavailable"
  else
    SerialNumber.String = SerialNum
  end
end

function SWVersionParser(Version)
  if DebugFunction then print("SWVersionParser() called") end
  if Version:sub(1,3) == "ERR" or Version == "" then
    SWVersion.String = "Unavailable"
  else
    SWVersion.String = Version
  end
end

function ReplacementFilterParser(FilterData)
  if DebugFunction then print("ReplacementFilterParser() called") end
  if FilterData:sub(1,3) == "ERR" or FilterData == "" then
    ReplacementFilter.String = "Unavailable"
  else
    ReplacementFilter.String = FilterData
  end
end

function ReplacementLampParser(LampData)
  if DebugFunction then print("ReplacementLampParser() called") end
  if LampData:sub(1,3) == "ERR" or LampData == "" then
    ReplacementLamp.String = "Unavailable"
  else
    ReplacementLamp.String = LampData
  end
end

function LampHrsParser(LampData)
  if DebugFunction then print("LampHrsParser() called") end
  if LampData == "ERR1" then
    Controls.LampHours[t].String = "No Lamp"
    return
  elseif LampData:sub(1,3) == "ERR" or LampData == "" then
    Controls.LampHours[t].String = "Unavailable"
    return
  end
  LampHours = {}
  t=0
  for m in string.gmatch(LampData, "(%d+) (%d)") do
    t=t+1
    LampHours[t] = m
    Controls.LampHours[t].String = LampHours[t]
  end
  if t < 2 then
    Controls.LampHours[2].IsInvisible = true
    LampHrs2.IsInvisible = true
  else
    Controls.LampHours[2].IsInvisible = false
    LampHrs2.IsInvisible = false
  end
end

function FilterHrsParser(FilterData)
  if DebugFunction then print("FilterHrsParser() called") end
  if FilterData == "ERR1" then
    FilterHrs.String = "No Filter"
  elseif FilterData:sub(1,3) == "ERR" then
    FilterHrs.String = "Unavailable"
  else
    FilterHrs.String = FilterData
  end
end

function PowerParser(PowerState)
  if DebugFunction then print("PowerParser() called") end
  if PowerState == "0" then
    PowerStatus = PowerState
    PowerStatusFB.String = "Projector is OFF"
    PowerStatusFB.Color = "White"
    Power.Boolean = false
  elseif PowerState == "1" then
    PowerStatus = PowerState
    PowerStatusFB.String = "Projector is ON"
    PowerStatusFB.Color = "White"
    Power.Boolean = true 
  end
end

function InputsParser(InputData)
  if DebugFunction then print("InputsParser() called") end
  if InputData == InputSwitchResponse then
    return
  elseif InputData:sub(1,3) == "ERR" or InputData == "" then
    print("Error retrieving input list")
    return
  end
  InputSwitchResponse = InputData
  r, v, d, s, n, internal = 0, 0, 0, 0, 0, 0
  for Input in string.gmatch(InputData, "(%w+)") do
    if Input:sub(1,1) == "1" and r < InputCount then
      r=r+1
      RGBin[r] = Input
    elseif Input:sub(1,1) == "2" and v < InputCount then
      v=v+1
      Videoin[v] = Input
    elseif Input:sub(1,1) == "3" and d < InputCount then
      d=d+1
      Digitalin[d] = Input
    elseif Input:sub(1,1) == "4" and s < InputCount then
      s=s+1
      Storagein[s] = Input
    elseif Input:sub(1,1) == "5" and n < InputCount then
      n=n+1
      Networkin[n] = Input
    elseif Input:sub(1,1) == "6" and internal < InputCount then
      internal=internal+1
      Internalin[n] = Input
    else
      print("Bad Input Number")
    end
  end
  ShowInputs(r, v, d, s, n, internal)
  for i=1,InputCount do
    Controls["RGBName"][i].String = ""
    Controls["VideoName"][i].String = ""
    Controls["DigitalName"][i].String = ""
    Controls["StorageName"][i].String = ""
    Controls["NetworkName"][i].String = ""
    Controls["InternalName"][i].String = ""
  end
  if Controls["PJJLinkClass"].Value == 2.0 then
    InputNamePoll()
  end
end

Controls.voldn.EventHandler = function() 
  Send("\x25\x32\x53\x56\x4f\x4c\x20\x00\x0d")
end

Controls.volup.EventHandler = function() 
  Send("\x25\x32\x53\x56\x4f\x4c\x20\x01\x0d")
end


function MuteParser(MuteData)
  if DebugFunction then print("MuteParser() called") end
  local ctrl,state=MuteData:match("^(%d?)(%d?)$")
  if MuteData:sub(1,3) == "ERR" then
    print("Error retrieving mute data.")
  elseif MuteData == "31" then
    Controls.AVMute[1].Boolean = true
    Controls.AVMute[2].Boolean = true
    Controls.AVMute[3].Boolean = true
  elseif MuteData == "30" then
    Controls.AVMute[1].Boolean = false
    Controls.AVMute[2].Boolean = false
    Controls.AVMute[3].Boolean = false
  elseif MuteData == "11" then
    Controls.AVMute[1].Boolean = true
    Controls.AVMute[2].Boolean = false
    Controls.AVMute[3].Boolean = false
  elseif MuteData == "21" then
    Controls.AVMute[1].Boolean = false
    Controls.AVMute[2].Boolean = true
    Controls.AVMute[3].Boolean = false
  end
end

function FreezeParser(FreezeData)
  if DebugFunction then print("FreezeParser() called") end
  if FreezeData == "1" then
    Controls.VideoFreeze.Boolean = true
  elseif FreezeData == "0" then
    Controls.VideoFreeze.Boolean = false
  end
end

function InputNameParser(InputData)
  if DebugFunction then print("InputNameParser() called") end
  if InputData == "ERR2" then
    print("Invalid input name request")
  elseif InputData:sub(1,3) == "ERR" then
    print("Error retrieving input name")
  elseif CurrentInputNameRequest == nil then
    return
  else
    CurrentInputNameRequest.String = InputData
    InputNamePoll()
  end
end

function ErrorStatusParser(ErrorData)
  if DebugFunction then print("ErrorStatusParser() called") end
  if ErrorData:sub(1,3) == "ERR" or #ErrorData<6 then
    print("Error retrieving status infomration")
  else
    for i,name in ipairs({"Fan","Lamp","Temperature","Cover","Filter","Other"}) do
      local errorLevel = tonumber(ErrorData:sub(i,i)) + 1
      for j=1,3 do
        Controls[name.."Status"][j].Boolean = j==errorLevel
      end
    end
  end
end

function InputResolutionParser(InputData)
  if DebugFunction then print("InputResolutionParser() called") end
  if InputData:sub(1,3) == "ERR" then
    Controls["InputResolution"].String = "Unavailable"
  elseif InputData:sub(1,3) == "-" then
    Controls["InputResolution"].String = "No Signal Input"
  elseif InputData:sub(1,3) == "*" then
    Controls["InputResolution"].String = "Unknown Signal"
  else
    Controls["InputResolution"].String = InputData
  end
end

function RecommendedResolutionParser(InputData)
  if DebugFunction then print("InputResolutionParser() called") end
  if InputData:sub(1,3) == "ERR" then
    Controls["RecommendedResolution"].String = "Unavailable"
  else
    Controls["RecommendedResolution"].String = InputData
  end
end


-- Event Handlers
  -- Socket EventHandler
PJLink.EventHandler = function(sock, evt, err)
  if DebugFunction then print("TCPConnection Handler called") end
  if evt == TcpSocket.Events.Connected then
    Heartbeat:Start(PollRate)
    ConnectionStatus = "Initializing"
  elseif evt == TcpSocket.Events.Reconnect then
    ReportStatus("MISSING","Reconnecting")
    Disconnected()
  elseif evt == TcpSocket.Events.Data then
    local line = sock:ReadLine( TcpSocket.EOL.Any )
    if DebugRx then print("RX: " .. line) end
    if ConnectionStatus == "Initializing" then
      local protocol, auth, seed = line:match("(%a+) (%d) (%w+)")
      if seed then
        local hash = Crypto.MD5Compute(seed..password)        
        Authenticate(hash)
      else
        Authenticate()
      end
    elseif line:find("PJLINK ERRA") then
      Disconnected()
      ReportStatus("FAULT","Authentication Error")
      RetryTimer:Start(PollRate)
    elseif line:find("^%%") then
      ReportStatus("OK","")
      ConnectionStatus = "Authenticated"
      DeviceInfoParser(line)
    end
  elseif evt == TcpSocket.Events.Closed then
    Disconnected()
    ReportStatus("MISSING", "Socket Closed")
    Connect()
  elseif evt == TcpSocket.Events.Error then
    Disconnected()
    ReportStatus("MISSING", "Socket Error")
  elseif evt == TcpSocket.Events.Timeout then
    if WarmupTime then
      return
    end
    Disconnected()
    ReportStatus("MISSING", "Timeout")
  else
    Disconnected()
    ReportStatus("MISSING",err)
  end
end

  -- Control EventHandlers
Power.EventHandler = function()
  if DebugFunction then print("Power Eventhandler called") end
  if Power.Boolean == true then
    Send("%1"..cmds["pwr"][1].."1")
    PowerStatusFB.String = "Warming up..."
    PowerStatusFB.Color = "Yellow"
    WarmupTime = true
    WarmupTimer:Start(WarmupTimeout)
  elseif Power.Boolean == false then
    Send("%1"..cmds["pwr"][1].."0")
  end 
end

PwrOn.EventHandler = function ()
  PJLink:Write("%1POWR 1",CR)
end

PwrOff.EventHandler = function ()
  PJLink:Write("%1POWR 0",CR)
end

for i=1,3 do
  Controls.AVMute[i].EventHandler = function()
    if DebugFunction then print("AVMute "..i.." Eventhandler called") end
    if Controls.AVMute[i].Boolean then
      cmd=1
    else
      cmd=0 
    end
    Send("%1"..cmds["mute"][1]..i..cmd)
  end
end

Controls.VideoFreeze.EventHandler = function()
  if DebugFunction then print("VideoFreeze Eventhandler called") end
  if Controls.VideoFreeze.Boolean then
    Send("%2"..cmds["frez"][1].."1")
  else
    Send("%2"..cmds["frez"][1].."0")
  end
end

for i=1,InputCount do
  Controls['RGB'][i].EventHandler = function(InptNum)
    if DebugFunction then print("RGB "..i.." Eventhandler called") end
    if Controls["PJJLinkClass"].Value == 2.0 then
      Send("%2"..cmds["input"][1]..RGBin[i])
    else
      Send("%1"..cmds["input"][1]..RGBin[i])
    end
  end
  Controls['Video'][i].EventHandler = function(ctl)
    if DebugFunction then print("Video "..i.." Eventhandler called") end
    if Controls["PJJLinkClass"].Value == 2.0 then
      Send("%2"..cmds["input"][1]..Videoin[i])
    else
      Send("%1"..cmds["input"][1].Videoin[i])
    end
  end
  Controls['Digital'][i].EventHandler = function(ctl)
    if DebugFunction then print("Digital "..i.." Eventhandler called") end
    if Controls["PJJLinkClass"].Value == 2.0 then
      Send("%2"..cmds["input"][1]..Digitalin[i])
    else
      Send("%1"..cmds["input"][1]..Digitalin[i])
    end
  end
  Controls['Storage'][i].EventHandler = function(ctl)
    if DebugFunction then print("Storage "..i.." Eventhandler called") end
    if Controls["PJJLinkClass"].Value == 2.0 then
      Send("%2"..cmds["input"][1]..Storagein[i])
    else
      Send("%1"..cmds["input"][1]..Storagein[i])
    end
  end
  Controls['Network'][i].EventHandler = function(ctl)
    if DebugFunction then print("Network "..i.." Eventhandler called") end
    if Controls["PJJLinkClass"].Value == 2.0 then
      Send("%2"..cmds["input"][1]..Networkin[i])
    else
      Send("%1"..cmds["input"][1]..Networkin[i])
    end
  end
  Controls['Internal'][i].EventHandler = function(ctl)
    if DebugFunction then print("Internal "..i.." Eventhandler called") end
    if Controls["PJJLinkClass"].Value == 2.0 then
      Send("%2"..cmds["input"][1]..Internalin[i])
    else
      Send("%1"..cmds["input"][1]..Internalin[i])
    end
    
  end
end

IPAddress.EventHandler = function()
  if DebugFunction then print("IPAddress Eventhandler called") end
  Init()
end

Port.EventHandler = function()
  if DebugFunction then print("Port Eventhandler called") end
  Init()
end

Password.EventHandler = function()
  if DebugFunction then print("Password Eventhandler called") end
  Init()
end

  -- Timer EventHandlers
Heartbeat.EventHandler = function()
  if DebugFunction then print("Heartbeat Eventhandler called") end
  PowerPoll()
end

WarmupTimer.EventHandler = function()
  if DebugFunction then print("Heartbeat Eventhandler called") end
  WarmupTime = false
  WarmupTimer:Stop()
end

RetryTimer.EventHandler = function()
  if DebugFunction then print("RetryAuthentication() called") end
  if not PJLink.IsConnected then
    Connect()
  end
  RetryTimer:Stop()
end



-- Start at runtime
SetupDebugPrint()
Init()