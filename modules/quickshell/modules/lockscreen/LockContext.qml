import QtQuick
import Quickshell
import Quickshell.Services.Pam

Scope {
    id: root

    signal unlocked()

    // Shared state across all monitors
    property string currentText: ""
    property bool unlockInProgress: false
    property bool showFailure: false

    onCurrentTextChanged: showFailure = false

    function reset() {
        currentText = ""
        unlockInProgress = false
        showFailure = false
    }

    function tryUnlock() {
        if (unlockInProgress) return
        if (currentText === "") return
        unlockInProgress = true
        pam.start()
    }

    PamContext {
        id: pam

        // Keep PAM config inside your lockscreen folder
        configDirectory: Quickshell.shellDir + "/modules/lockscreen/pam"
        config: "password.conf"

        onPamMessage: {
            if (this.responseRequired) this.respond(root.currentText)
        }

        onCompleted: result => {
            if (result == PamResult.Success) {
                root.unlocked()
            } else {
                root.currentText = ""
                root.showFailure = true
            }
            root.unlockInProgress = false
        }
    }
}
