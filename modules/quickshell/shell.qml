//@pragma UseQApplication

import QtQuick
import Quickshell
import qs.bar
import qs.services
import "modules/lockscreen" as Locks
import "modules/menus"

ShellRoot {
    id: root

    ThemeMenu { id: themeMenu }

    AppLauncher {
        id: appLauncher
    }


    Variants {
        model: Quickshell.screens
    }

    Variants {
        model: Quickshell.screens
        Bar {
            required property var modelData
            targetScreen: modelData
        }
    }

    Variants {
        model: Quickshell.screens
        Mask {
            required property var modelData
            targetScreen: modelData
        }
    }

    Locks.Lockscreen { id: lockscreen }
}
