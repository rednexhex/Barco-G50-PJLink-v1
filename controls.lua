
table.insert(ctrls, {
  Name           = "IPAddress",
  ControlType    = "Text",
  Count          = 1
})

table.insert(ctrls, {
  Name           = "Port",
  ControlType    = "Knob",
  ControlUnit    = "Integer",
  DefaultValue   = 4352,
  Min            = 1,
  Max            = 65535,
  Count          = 1,
})

table.insert(ctrls, {
  Name           = "Password",
  ControlType    = "Text",
  Count          = 1,
})

table.insert(ctrls, {
  Name           = "Status",
  ControlType    = "Indicator",
  IndicatorType  = Reflect and "StatusGP" or "Status",
  Count          = 1,
  UserPin        = true,
  PinStyle       = "Output"
})

table.insert(ctrls, {
  Name           = "Manufacturer",
  ControlType    = "Indicator",
  IndicatorType  = "Text",
  Count          = 1,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "Model",
  ControlType    = "Indicator",
  IndicatorType  = "Text",
  Count          = 1,
  UserPin        = true,
  PinStyle       = "Output"
})

table.insert(ctrls, {
  Name           = "DeviceName",
  ControlType    = "Indicator",
  IndicatorType  = "Text",
  Count          = 1,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "SerialNumber",
  ControlType    = "Indicator",
  IndicatorType  = "Text",
  Count          = 1,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "DeviceFirmware",
  ControlType    = "Indicator",
  IndicatorType  = "Text",
  Count          = 1,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "PowerStatus",
  ControlType    = "Indicator",
  IndicatorType  = "Text",
  Count          = 1,
  UserPin        = true,
  PinStyle       = "Output"
})

table.insert(ctrls, {
  Name           = "Power",
  ControlType    = "Button",
  ButtonType     = "Toggle",
  IconType       = "Icon",
  Icon           = "Power",
  UserPin        = true,
  PinStyle       = "Both"
})

table.insert(ctrls, {
  Name           = "ProjOn",
  ControlType    = "Button",
  ButtonType     = "Trigger"
  })

  table.insert(ctrls, {
    Name           = "ProjOff",
    ControlType    = "Button",
    ButtonType     = "Trigger"
    })

table.insert(ctrls, {
  Name           = "AVMute",
  ControlType    = "Button",
  ButtonType     = "Toggle",
  UserPin        = true,
  PinStyle       = "Both",
  Count          = 3
})


table.insert(ctrls, {
  Name           = "VideoFreeze",
  ControlType    = "Button",
  ButtonType     = "Toggle",
  UserPin        = true,
  PinStyle       = "Both",
  Count          = 1
})


table.insert(ctrls, {
  Name           = "LampHours",
  ControlType    = "Indicator",
  IndicatorType  = "Text",
  Count          = 2,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "FilterHours",
  ControlType    = "Indicator",
  IndicatorType  = "Text",
  Count          = 1,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "LampText",
  ControlType    = "Text",
  TextBoxType    = "NoBackground",
  Count          = 1,
})


table.insert(ctrls, {
  Name           = "FilterText",
  ControlType    = "Text",
  DefaultValue   = "Filter Hours:",
  TextBoxType    = "NoBackground",
  Count          = 1,
})

table.insert(ctrls, {
  Name           = "NoRGB",
  ControlType    = "Text",
  TextBoxType    = "NoBackground",
  Count          = 1,
})


table.insert(ctrls, {
  Name           = "NoVid",
  ControlType    = "Text",
  TextBoxType    = "NoBackground",
  Count          = 1,
})


table.insert(ctrls, {
  Name           = "NoDig",
  ControlType    = "Text",
  TextBoxType    = "NoBackground",
  Count          = 1,
})


table.insert(ctrls, {
  Name           = "NoSto",
  ControlType    = "Text",
  TextBoxType    = "NoBackground",
  Count          = 1,
})


table.insert(ctrls, {
  Name           = "NoNet",
  ControlType    = "Text",
  TextBoxType    = "NoBackground",
  Count          = 1,
})


table.insert(ctrls, {
  Name           = "NoInternal",
  ControlType    = "Text",
  TextBoxType    = "NoBackground",
  Count          = 1,
})


table.insert(ctrls, {
  Name           = "RGB",
  ControlType    = "Button",
  ButtonType     = "Toggle",
  Count          = props["Input Count"].Value,
  UserPin        = true,
  PinStyle       = "Input"
})


table.insert(ctrls, {
  Name           = "RGBName",
  ControlType    = "Text",
  TextBoxType    = "NoBackground",
  Count          = props["Input Count"].Value,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "SelectedRGB",
  ControlType    = "Indicator",
  IndicatorType  = "LED",
  Count          = props["Input Count"].Value,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "Video",
  ControlType    = "Button",
  ButtonType     = "Toggle",
  Count          = props["Input Count"].Value,
  UserPin        = true,
  PinStyle       = "Input"
})


table.insert(ctrls, {
  Name           = "VideoName",
  ControlType    = "Text",
  TextBoxType    = "NoBackground",
  Count          = props["Input Count"].Value,
  UserPin        = true,
  PinStyle       = "Output"
})

table.insert(ctrls, {
  Name           = "SelectedVideo",
  ControlType    = "Indicator",
  IndicatorType  = "LED",
  Count          = props["Input Count"].Value,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "Digital",
  ControlType    = "Button",
  ButtonType     = "Toggle",
  Count          = props["Input Count"].Value,
  UserPin        = true,
  PinStyle       = "Input"
})


table.insert(ctrls, {
  Name           = "DigitalName",
  ControlType    = "Text",
  TextBoxType    = "NoBackground",
  Count          = props["Input Count"].Value,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "SelectedDigital",
  ControlType    = "Indicator",
  IndicatorType  = "LED",
  Count          = props["Input Count"].Value,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "Storage",
  ControlType    = "Button",
  ButtonType     = "Toggle",
  Count          = props["Input Count"].Value,
  UserPin        = true,
  PinStyle       = "Input"
})


table.insert(ctrls, {
  Name           = "StorageName",
  ControlType    = "Text",
  TextBoxType    = "NoBackground",
  Count          = props["Input Count"].Value,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "SelectedStorage",
  ControlType    = "Indicator",
  IndicatorType  = "LED",
  Count          = props["Input Count"].Value,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "Network",
  ControlType    = "Button",
  ButtonType     = "Toggle",
  Count          = props["Input Count"].Value,
  UserPin        = true,
  PinStyle       = "Input"
})


table.insert(ctrls, {
  Name           = "NetworkName",
  ControlType    = "Text",
  TextBoxType    = "NoBackground",
  Count          = props["Input Count"].Value,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "SelectedNetwork",
  ControlType    = "Indicator",
  IndicatorType  = "LED",
  Count          = props["Input Count"].Value,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "Internal",
  ControlType    = "Button",
  ButtonType     = "Toggle",
  Count          = props["Input Count"].Value,
  UserPin        = true,
  PinStyle       = "Input"
})


table.insert(ctrls, {
  Name           = "InternalName",
  ControlType    = "Text",
  TextBoxType    = "NoBackground",
  Count          = props["Input Count"].Value,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "SelectedInternal",
  ControlType    = "Indicator",
  IndicatorType  = "LED",
  Count          = props["Input Count"].Value,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "PJJLinkClass",
  ControlType    = "Knob",
  ControlUnit    = "Integer",
  DefaultValue   = 1,
  Count          = 1,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "FanStatus",
  ControlType    = "Indicator",
  IndicatorType  = "LED",
  Count          = 3,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "LampStatus",
  ControlType    = "Indicator",
  IndicatorType  = "LED",
  Count          = 3,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "TemperatureStatus",
  ControlType    = "Indicator",
  IndicatorType  = "LED",
  Count          = 3,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "CoverStatus",
  ControlType    = "Indicator",
  IndicatorType  = "LED",
  Count          = 3,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "FilterStatus",
  ControlType    = "Indicator",
  IndicatorType  = "LED",
  Count          = 3,
  UserPin        = true,
  PinStyle       = "Output"
})

table.insert(ctrls, {
  Name           = "OtherStatus",
  ControlType    = "Indicator",
  IndicatorType  = "LED",
  Count          = 3,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "InputResolution",
  ControlType    = "Indicator",
  IndicatorType  = "Text",
  Count          = 1,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "RecommendedResolution",
  ControlType    = "Indicator",
  IndicatorType  = "Text",
  Count          = 1,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "ReplacementFilter",
  ControlType    = "Indicator",
  IndicatorType  = "Text",
  Count          = 1,
  UserPin        = true,
  PinStyle       = "Output"
})


table.insert(ctrls, {
  Name           = "ReplacementLamp",
  ControlType    = "Indicator",
  IndicatorType  = "Text",
  Count          = 1,
  UserPin        = true,
  PinStyle       = "Output"
})

table.insert(ctrls, {
  Name           = "voldn",
  ControlType    = "Button",
  ButtonType     = "Momentary"
})
table.insert(ctrls, {
  Name           = "volup",
  ControlType    = "Button",
  ButtonType     = "Momentary"
})