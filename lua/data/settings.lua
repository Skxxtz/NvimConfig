local user_specific = require("data.user_specific")

local parsed = {
    Os = user_specific.Os or {},
    StartUpPlugin = user_specific.StartUpPlugin or {},
    CommandPallettePlugin = user_specific.CommandPallettePlugin or {},
    Cpp = user_specific.Cpp or {},
}



UserSettings = {
    Os = {
        Platform = os.getenv("OS"),
    },
    StartUpPlugin = {
        Header = parsed.StartUpPlugin.Header or "Tree",
        Signiture = parsed.StartUpPlugin.Signiture or "Squirly",
        AccentColor = parsed.StartUpPlugin.AccentColor or "#24B364",
    },
    CommandPallettePlugin = {
        AccentColor = parsed.CommandPallettePlugin.AccentColor or "#24B364",
    },
    Cpp = {
        Compiler = parsed.Cpp.Compiler or "g++",
        Version = parsed.Cpp.Version or "-std=c++20",
    },
    FormatOnSave = parsed.FormatOnSave or false
}

