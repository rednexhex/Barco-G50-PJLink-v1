 
 local function GetIPos(qty, rowlen, base, ofs)
 local row,col = (qty-1)//(rowlen),(qty-1)%rowlen
 return { base.x + col*ofs.x, base.y + row*ofs.y }
 end 


 -- Local Variables
 local CurrentPage = pagenames[props["page_index"].Value]
 local layout, graphics = {}, {}
 local PJLinkLogo = rdxlogo
 local sig = sig
 local MuteLabels={"Video","Audio","A/V","Freeze"}
 
 -- Color Lookup Table
 local Black        = { 0  , 0  , 0   }
 local White        = { 255, 255, 255 }
 local BGGray       = { 236, 236, 236 }
 local BtnGrn       = { 0  , 199, 0   }
 local BtnGrnOff    = { 0  , 127, 0   }
 local BtnGrnOn     = { 0  , 255, 0   }
 local LEDRedOff    = { 127, 0  , 0   }
 local LEDRedOn     = { 255, 0  , 0   }
 local LEDGreenOff  = { 0  , 127, 0   }
 local LEDGreenOn   = { 0  , 255, 0   }
 local LEDYellowOff = { 127, 127, 0   }
 local LEDYellowOn  = { 255, 255, 0   }
 
 local BtnGray   = { 130, 130, 130 }
 
 --Controls Layout
 if CurrentPage=="Control" then
   local offset = math.max(0, (props["Input Count"].Value - 4) * 25)
   -- Groupbox
   table.insert(graphics,{
     Type            = "GroupBox",
     Fill            = BGGray,
     StrokeWidth     = 1,
     CornerRadius    = 0,
     Position        = {0,0},
     Size            = {278 + offset*2,425}
   })
     -- Header
   table.insert(graphics,{
     Type            = "Header",
     Text            = "Power",
     Position        = {9,59},
     Size            = {259 + offset*2,10},
     FontSize        = 14
   })
   table.insert(graphics,{
     Type            = "Header",
     Text            = "A/V Mute",
     Position        = {9,122},
     Size            = {259 + offset*2,10},
     FontSize        = 14
   })
   table.insert(graphics,{
     Type            = "Header",
     Text            = "Inputs",
     Position        = {9,195},
     Size            = {259 + offset*2,10},
     FontSize        = 14
   })
     -- Text
     table.insert(graphics,{
     Type            = "Text",
     Text            = "RGB",
     Position        = {2,238},
     Size            = {60,16},
     HTextAlign      = "Right",
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Video",
     Position        = {2,270},
     Size            = {60,16},
     HTextAlign      = "Right",
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Digital",
     Position        = {2,302},
     Size            = {60,16},
     HTextAlign      = "Right",
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Storage",
     Position        = {2,332},
     Size            = {60,16},
     HTextAlign      = "Right",
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Network",
     Position        = {2,364},
     Size            = {60,16},
     HTextAlign      = "Right",
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Internal",
     Position        = {2,396},
     Size            = {60,16},
     HTextAlign      = "Right",
     StrokeWidth     = 0,
     FontSize        = 12
   })
     -- Logo
   table.insert(graphics,{
     Type            = "Image",
     Image           = PJLinkLogo,
     Position        = {65 + offset,12},
     Size            = {149,36}
   })
     -- Controls
   layout["Power"]={
     PrettyName      = "Device Power",
     Style           = "Button",
     ButtonStyle     = "Toggle",
     Color           = {241,53,45},
     OffColor        = {167,35,35},
     UnlinkOffColor  = true,
     Position        = {85 + offset,84},
     Size            = {33,25}
   }

   layout["ProjOn"]={
    PrettyName      = "Power On",
    Style                = "Button",
    ButtonStyle     = "Trigger",
    Legend            = "Power\x0DOn",
    Color               = {255,255,255},
    Position          = {1 + offset,84},
    Size                = {40,25}
  }

  layout["ProjOff"]={
    PrettyName      = "Power Off",
    Style                = "Button",
    ButtonStyle     = "Trigger",
    Legend            = "Power\x0DOff",
    Color               = {255,255,255},
    Position          = {45 + offset,84},
    Size                = {40,25}
  }

   layout["PowerStatus"]={
     PrettyName      = "Device's Power Status",
     Style           = "Textdisplay",
     FontSize        = 12,
     Color           = White,
     IsReadOnly      = true,
     Position        = {125 + offset,84},
     Size            = {149,22}
   }
   layout["NoRGB"]={
     PrettyName      = "No RGB Inputs",
     Style           = "Text",
     TextBoxStyle    = "NoBackground",
     IsReadOnly      = true,
     Position        = {81,238},
     Size            = {149,16},
     FontSize        = 12
   }
   layout["NoVid"]={
     PrettyName      = "No Analog Video Inputs",
     Style           = "Text",
     TextBoxStyle    = "NoBackground",
     IsReadOnly      = true,
     Position        = {81,270},
     Size            = {149,16},
     FontSize        = 12
   }
   layout["NoDig"]={
     PrettyName      = "No Digital Video Inputs",
     Style           = "Text",
     TextBoxStyle    = "NoBackground",
     IsReadOnly      = true,
     Position        = {81,302},
     Size            = {149,16},
     FontSize        = 12
   }
   layout["NoSto"]={
     PrettyName      = "No Storage Inputs",
     Style           = "Text",
     TextBoxStyle    = "NoBackground",
     IsReadOnly      = true,
     Position        = {81,332},
     Size            = {149,16},
     FontSize        = 12
   }
   layout["NoNet"]={
     PrettyName      = "No Network Inputs",
     Style           = "Text",
     TextBoxStyle    = "NoBackground",
     IsReadOnly      = true,
     Position        = {81,364},
     Size            = {149,16},
     FontSize        = 12
   }
   layout["NoInternal"]={
     PrettyName      = "No Internal Inputs",
     Style           = "Text",
     TextBoxStyle    = "NoBackground",
     IsReadOnly      = true,
     Position        = {81 + offset,396},
     Size            = {149,16},
     FontSize        = 12
   }
   for i=1,3 do
     layout["AVMute "..i]={
       PrettyName      = "Mute~"..MuteLabels[i],
       Style           = "Button",
       Legend          = MuteLabels[i],
       ButtonStyle     = "Toggle",
       Position        = GetIPos(i,3,{x=16 + offset,y=141},{x=90,y=0}),
       Size            = {68,20}
     }
   end
   layout["VideoFreeze"]={
     PrettyName      = "Mute~Video Freeze",
     Style           = "Button",
     Legend          = "Freeze",
     ButtonStyle     = "Toggle",
     Position        = {106 + offset,166},
     Size            = {68,20}
   }
   for i=1,props["Input Count"].Value do
     table.insert(graphics,{
       Type            = "Text",
       Text            = "" .. i,
       Position        = {22 + i*50,210},
       Size            = {36,14},
       StrokeWidth     = 0,
       FontSize        = 12
     })
     layout["RGBName "..i]={
       PrettyName      = "RGB Inputs~RGB "..i.." Name",
       Style           = "Text",
       TextBoxStyle    = "NoBackground",
       IsReadOnly      = true,
       FontSize        = 10,
       HTextAlign      = "Center",
       Position        = GetIPos(i,props["Input Count"].Value,{x=68,y=226},{x=50,y=52}),
       Size            = {44,12}
     }
     layout["RGB "..i]={
       PrettyName      = "RGB Inputs~RGB In "..i,
       Style           = "Button",
       UnlinkOffColor  = true,
       Color           = White,
       OffColor        = BtnGray,
       Position        = GetIPos(i,props["Input Count"].Value,{x=72,y=238},{x=50,y=52}),
       Size            = {36,16}
       
     }
     layout["SelectedRGB "..i]={
       PrettyName      = "RGB Inputs~RGB "..i.." Selected",
       Style           = "None"
     }
 
     layout["VideoName "..i]={
       PrettyName      = "Analog Video Inputs~Analog "..i.." Name",
       Style           = "Text",
       TextBoxStyle    = "NoBackground",
       IsReadOnly      = true,
       FontSize        = 10,
       HTextAlign      = "Center",
       Position        = GetIPos(i,props["Input Count"].Value,{x=68,y=258},{x=50,y=52}),
       Size            = {44,12}
     }
     layout["Video "..i]={
       PrettyName      = "Analog Video Inputs~Analog Video In "..i,
       Style           = "Button",
       UnlinkOffColor  = true,
       Color           = White,
       OffColor        = BtnGray,
       Position        = GetIPos(i,props["Input Count"].Value,{x=72,y=270},{x=50,y=52}),
       Size            = {36,16}
     }
     layout["SelectedVideo "..i]={
       PrettyName      = "Analog Video Inputs~Analog "..i.." Selected",
       Style           = "None"
     }
 
     layout["DigitalName "..i]={
       PrettyName      = "Digital Video Inputs~Digital Video "..i.." Name",
       Style           = "Text",
       TextBoxStyle    = "NoBackground",
       IsReadOnly      = true,
       FontSize        = 10,
       HTextAlign      = "Center",
       Position        = GetIPos(i,props["Input Count"].Value,{x=68,y=290},{x=50,y=52}),
       Size            = {44,12}
     }
     layout["Digital "..i]={
       PrettyName      = "Digital Video Inputs~Digital Video In "..i,
       Style           = "Button",
       UnlinkOffColor  = true,
       Color           = White,
       OffColor        = BtnGray,
       Position        = GetIPos(i,props["Input Count"].Value,{x=72,y=302},{x=50,y=52}),
       Size            = {36,16}
     }
     layout["SelectedDigital "..i]={
       PrettyName      = "Digital Video Inputs~Digital Video "..i.." Selected",
       Style           = "None"
     }
 
     layout["StorageName "..i]={
       PrettyName      = "Storage Inputs~Storage "..i.." Name",
       Style           = "Text",
       TextBoxStyle    = "NoBackground",
       IsReadOnly      = true,
       FontSize        = 10,
       HTextAlign      = "Center",
       Position        = GetIPos(i,props["Input Count"].Value,{x=68,y=320},{x=50,y=52}),
       Size            = {44,12}
     }
     layout["Storage "..i]={
       PrettyName      = "Storage Inputs~Storage In "..i,
       Style           = "Button",
       UnlinkOffColor  = true,
       Color           = White,
       OffColor        = BtnGray,
       Position        = GetIPos(i,props["Input Count"].Value,{x=72,y=332},{x=50,y=52}),
       Size            = {36,16}
     }
     layout["SelectedStorage "..i]={
       PrettyName      = "Storage Inputs~Storage "..i.." Selected",
       Style           = "None"
     }
     
     layout["NetworkName "..i]={
       PrettyName      = "Network Inputs~Network "..i.." Name",
       Style           = "Text",
       TextBoxStyle    = "NoBackground",
       IsReadOnly      = true,
       FontSize        = 10,
       HTextAlign      = "Center",
       Position        = GetIPos(i,props["Input Count"].Value,{x=68,y=352},{x=50,y=52}),
       Size            = {44,12}
     }
     layout["Network "..i]={
       PrettyName      = "Network Inputs~Network In "..i,
       Style           = "Button",
       UnlinkOffColor  = true,
       Color           = White,
       OffColor        = BtnGray,
       Position        = GetIPos(i,props["Input Count"].Value,{x=72,y=364},{x=50,y=52}),
       Size            = {36,16}
     }
     layout["SelectedNetwork "..i]={
       PrettyName      = "Network Inputs~Network "..i.." Selected",
       Style           = "None"
     }
     
     layout["InternalName "..i]={
       PrettyName      = "Internal Inputs~Internal "..i.." Name",
       Style           = "Text",
       TextBoxStyle    = "NoBackground",
       IsReadOnly      = true,
       FontSize        = 10,
       HTextAlign      = "Center",
       Position        = GetIPos(i,props["Input Count"].Value,{x=68,y=384},{x=50,y=52}),
       Size            = {44,12}
     }
     layout["Internal "..i]={
       PrettyName      = "Internal Inputs~Internal In "..i,
       Style           = "Button",
       UnlinkOffColor  = true,
       Color           = White,
       OffColor        = BtnGray,
       Position        = GetIPos(i,props["Input Count"].Value,{x=72,y=396},{x=50,y=52}),
       Size            = {36,16}
     }
     layout["SelectedInternal "..i]={
       PrettyName      = "Internal Inputs~Internal "..i.." Selected",
       Style           = "None"
     }
   end
     -- Version Watermark
   table.insert(graphics,{
     Type            = "Label",
     Text            = string.format("Version %s",PluginInfo.Version),
     Position        = {215 + offset*2,415},
     Size            = {60,10},
     FontSize        = 7,
     HTextAlign      = "Right"
   })

   table.insert(graphics,{
    Type            = "Image",
    Image           = sig,
    Position        = {1 +offset*2,400},
    Size            = {20,30}
  })

   layout["voldn"]={
    PrettyName      = "voldn",
    Style           = "Button",
    ButtonStyle     = "Momentary",
    Legend          = "Vol -",
    Position        = {15,170},
    Size            = {60,16}
  }
  
  layout["volup"]={
    PrettyName      = "volup",
    Style           = "Button",
    ButtonStyle     = "Momentary",
    Legend          = "Vol +",
    Position        = {200,170},
    Size            = {60,16}
  }
 
 elseif CurrentPage == "Status" then
     -- Controls
   layout["InputResolution"]={
     PrettyName      = "Status~Input Resoltuion",
     Style           = "Textdisplay",
     TextBoxStyle    = "NoBackground",
     HTextAlign      = "Left",
     FontSize        = 10,
     IsReadOnly      = true,
     Position        = {141,79},
     Size            = {125,14}
   }
   layout["RecommendedResolution"]={
     PrettyName      = "Status~Recommended Resoltuion",
     Style           = "Textdisplay",
     TextBoxStyle    = "NoBackground",
     HTextAlign      = "Left",
     FontSize        = 10,
     IsReadOnly      = true,
     Position        = {141,95},
     Size            = {125,14}
   }
   local LEDLables = {"OK", "Warning", "Fault"}
   for j,name in ipairs({"Fan", "Lamp", "Temperature", "Cover", "Filter", "Other"}) do
     for i,ledColor in ipairs({LEDGreenOn, LEDYellowOn, LEDRedOn}) do
       layout[name.."Status "..i]={
         PrettyName = "Status~"..name.." "..LEDLables[i],
         Style      = "LED",
         Color      = ledColor,
         Position   = GetIPos(i,3,{x=150,y=140+(j*16)},{x=36,y=0}),
         Size       = {16,16}
       }
     end
   end
   layout["LampHours 1"]={
     PrettyName      = "Lamp 1 Hours",
     Style           = "Textdisplay",
     TextBoxStyle    = "NoBackground",
     HTextAlign      = "Left",
     FontSize        = 10,
     IsReadOnly      = true,
     Position        = {141,280},
     Size            = {81,14}
   }
   layout["LampHours 2"]={
     PrettyName      = "Lamp 2 Hours",
     Style           = "Textdisplay",
     TextBoxStyle    = "NoBackground",
     HTextAlign      = "Left",
     FontSize        = 10,
     IsReadOnly      = true,
     Position        = {141,297},
     Size            = {81,14}
   }
   layout["LampText"]={
     PrettyName      = "No 2nd Lamp",
     Style           = "Text",
     TextBoxStyle    = "NoBackground",
     HTextAlign      = "Right",
     IsReadOnly      = true,
     Position        = {51,297},
     Size            = {80,14},
     FontSize        = 12
   }
   layout["FilterText"]={
     PrettyName      = "Filter Info",
     Style           = "Text",
     TextBoxStyle    = "NoBackground",
     HTextAlign      = "Right",
     IsReadOnly      = true,
     Position        = {51,313},
     Size            = {80,14},
     FontSize        = 12
   }
   layout["FilterHours"]={
     PrettyName      = "Filter Hours",
     Style           = "Text",
     TextBoxStyle    = "NoBackground",
     HTextAlign      = "Left",
     FontSize        = 10,
     IsReadOnly      = true,
     Position        = {141,313},
     Size            = {81,14}
   }
   layout["ReplacementLamp"]={
     PrettyName      = "Lamp Model",
     Style           = "Text",
     TextBoxStyle    = "NoBackground",
     HTextAlign      = "Left",
     FontSize        = 10,
     IsReadOnly      = true,
     Position        = {141,357},
     Size            = {125,14}
   }
   layout["ReplacementFilter"]={
     PrettyName      = "Filter Model",
     Style           = "Text",
     TextBoxStyle    = "NoBackground",
     HTextAlign      = "Left",
     FontSize        = 10,
     IsReadOnly      = true,
     Position        = {141,373},
     Size            = {125,14}
   }
     -- Groupbox
   table.insert(graphics,{
     Type            = "GroupBox",
     Fill            = BGGray,
     StrokeWidth     = 1,
     CornerRadius    = 0,
     Position        = {0,0},
     Size            = {278,405}
   })
     -- Header
   table.insert(graphics,{
     Type            = "Header",
     Text            = "Video Info",
     Position        = {9,59},
     Size            = {259,6},
     FontSize        = 14
   })
   table.insert(graphics,{
     Type            = "Header",
     Text            = "Error Status",
     Position        = {9,122},
     Size            = {259,10},
     FontSize        = 14
   })
   table.insert(graphics,{
     Type            = "Header",
     Text            = "Lamp Hours",
     Position        = {9,263},
     Size            = {259,6},
     FontSize        = 14
   })
   table.insert(graphics,{
     Type            = "Header",
     Text            = "Lamp Replacements",
     Position        = {9,340},
     Size            = {259,6},
     FontSize        = 14
   })
     -- Text
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Current Resolution:",
     HTextAlign      = "Right",
     Position        = {13,79},
     Size            = {120,14},
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Recommended:",
     HTextAlign      = "Right",
     Position        = {13,95},
     Size            = {120,14},
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "OK",
     Position        = {140,142},
     Size            = {36,14},
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Warn",
     Position        = {176,142},
     Size            = {36,14},
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Fault",
     Position        = {212,142},
     Size            = {36,14},
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Fan:",
     HTextAlign      = "Right",
     Position        = {33,156},
     Size            = {100,14},
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Lamp:",
     HTextAlign      = "Right",
     Position        = {33,172},
     Size            = {100,14},
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Temperature:",
     HTextAlign      = "Right",
     Position        = {33,188},
     Size            = {100,14},
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Cover:",
     HTextAlign      = "Right",
     Position        = {33,204},
     Size            = {100,14},
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Filter:",
     HTextAlign      = "Right",
     Position        = {33,220},
     Size            = {100,14},
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Other:",
     HTextAlign      = "Right",
     Position        = {33,236},
     Size            = {100,14},
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Lamp 1:",
     HTextAlign      = "Right",
     Position        = {52,280},
     Size            = {81,16},
     StrokeColor     = Black,
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Lamp Model:",
     HTextAlign      = "Right",
     Position        = {33,357},
     Size            = {100,14},
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Filter Model:",
     HTextAlign      = "Right",
     Position        = {33,373},
     Size            = {100,14},
     StrokeWidth     = 0,
     FontSize        = 12
   })
 
   -- Logo
   table.insert(graphics,{
     Type            = "Image",
     Image           = PJLinkLogo,
     Position        = {65,12},
     Size            = {149,36}
   })
     -- Version Watermark
   table.insert(graphics,{
     Type            = "Label",
     Text            = string.format("Version %s",PluginInfo.Version),
     Position        = {215,395},
     Size            = {60,10},
     FontSize        = 7,
     HTextAlign      = "Right"
   })

   table.insert(graphics,{
    Type            = "Image",
    Image           = sig,
    Position        = {1, 375},
    Size            = {20,30}
  })
 
 elseif CurrentPage == "Setup" then
     -- Controls
   layout["IPAddress"]={
     PrettyName      = "Device's IP Address",
     Style           = "Text",
     Color           = White,
     Position        = {128,79},
     Size            = {93,16},
     FontSize        = 9
   }
   layout["Port"]={Style="Text",
     PrettyName      = "Device's Port",
     Position        = {128,99},
     Size            = {93,16},
     Color           = White,
     CornerRadius    = 0,
     Margin          = 0,
     Padding         = 0,
     StrokeColor     = LEDStrk,
     StrokeWidth     = 1
   }
   layout["Password"]={
     PrettyName      = "Device's Password",
     Style           = "Text",
     Color           = White,
     Position        = {128,119},
     Size            = {93,16},
     FontSize        = 9
   }
   layout["Status"]={
     PrettyName      = "Connection Status",
     Style           = "Text",
     TextBoxStyle    = "Normal",
     Position        = {9,163},
     Size            = {259,28}
   } 
   layout["Model"]={
     PrettyName      = "Device's Model",
     Style           = "Textdisplay",
     TextBoxStyle    = "NoBackground",
     HTextAlign      = "Left",
     FontSize        = 10,
     IsReadOnly      = true,
     Position        = {141,220},
     Size            = {122,16}
   }
   layout["Manufacturer"]={
     PrettyName      = "Device's Manufacturer",
     Style           = "Textdisplay",
     TextBoxStyle    = "NoBackground",
     HTextAlign      = "Left",
     FontSize        = 10,
     IsReadOnly      = true,
     Position        = {141,236},
     Size            = {122,16}
   }
   layout["DeviceName"]={
     PrettyName      = "Device's Name",
     Style           = "Textdisplay",
     TextBoxStyle    = "NoBackground",
     HTextAlign      = "Left",
     FontSize        = 10,
     IsReadOnly      = true,
     Position        = {141,252},
     Size            = {122,16}
   }
   layout["SerialNumber"]={
     PrettyName      = "Serial Number",
     Style           = "Textdisplay",
     TextBoxStyle    = "NoBackground",
     HTextAlign      = "Left",
     FontSize        = 10,
     IsReadOnly      = true,
     Position        = {141,268},
     Size            = {122,16}
   }
   layout["DeviceFirmware"]={
     PrettyName      = "Software Version",
     Style           = "Textdisplay",
     TextBoxStyle    = "NoBackground",
     HTextAlign      = "Left",
     FontSize        = 10,
     IsReadOnly      = true,
     Position        = {141,284},
     Size            = {122,16}
   }
   --Hidden PJLink Class for Pin
   layout["PJJLinkClass"]={
     PrettyName      = "PJLink Class",
     Style           = "None"
   }
     -- Groupbox
   table.insert(graphics,{
     Type            = "GroupBox",
     Fill            = BGGray,
     StrokeWidth     = 1,
     CornerRadius    = 0,
     Position        = {0,0},
     Size            = {278,320}
   })
     -- Header
   table.insert(graphics,{
     Type            = "Header",
     Text            = "Connection",
     Position        = {9,59},
     Size            = {259,6},
     FontSize        = 14
 
   })
   table.insert(graphics,{
     Type            = "Header",
     Text            = "Projector Information",
     Position        = {9,206},
     Size            = {259,6},
     FontSize        = 14
   })
     -- Text
   table.insert(graphics,{
     Type            = "Text",
     Text            = "IP Address:",
     HTextAlign      = "Right",
     Position        = {48,79},
     Size            = {75,16},
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Port:",
     HTextAlign      = "Right",
     Position        = {48,99},
     Size            = {75,16},
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Password:",
     HTextAlign      = "Right",
     Position        = {48,120},
     Size            = {75,16},
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Connection Status",
     Position        = {63,147},
     Size            = {150,12},
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Model:",
     HTextAlign      = "Right",
     Position        = {41,220},
     Size            = {93,16},
     StrokeColor     = Black,
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Manufacturer:",
     HTextAlign      = "Right",
     Position        = {41,236},
     Size            = {93,16},
     StrokeColor     = Black,
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Projector Name:",
     HTextAlign      = "Right",
     Position        = {41,252},
     Size            = {93,16},
     StrokeColor     = Black,
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "Serial Number:",
     HTextAlign      = "Right",
     Position        = {41,268},
     Size            = {93,16},
     StrokeColor     = Black,
     StrokeWidth     = 0,
     FontSize        = 12
   })
   table.insert(graphics,{
     Type            = "Text",
     Text            = "SW Version:",
     HTextAlign      = "Right",
     Position        = {41,284},
     Size            = {93,16},
     StrokeColor     = Black,
     StrokeWidth     = 0,
     FontSize        = 12
   })
     -- Logo
   table.insert(graphics,{
     Type            = "Image",
     Image           = PJLinkLogo,
     Position        = {65,12},
     Size            = {149,36}
   })
     -- Version Number
   table.insert(graphics,{
     Type            = "Label",
     Text            = string.format("Version %s",PluginInfo.Version),
     Position        = {215,310},
     Size            = {60,10},
     FontSize        = 7,
     HTextAlign      = "Right"
   })

   table.insert(graphics,{
    Type            = "Image",
    Image           = sig,
    Position        = {1, 300},
    Size            = {20,30}
  })
 end