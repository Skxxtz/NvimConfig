local user_specific = require("data.user_specific")


UserSettings = {
    Os = {
        Platform = os.getenv("OS"),
    },
    StartUpPlugin = {
        Header = user_specific.StartUpPlugin.Header or "Tree",
        Signiture = user_specific.StartUpPlugin.Signiture or "Squirly",
    },
    Cpp = {
        Compiler = user_specific.Cpp.Compiler or "g++",
        Version = user_specific.Cpp.Version or "-std=c++20",
    },
    FormatOnSave = user_specific.FormatOnSave or false
}

