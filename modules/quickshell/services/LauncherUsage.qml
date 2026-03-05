import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    readonly property string usagePath: Quickshell.statePath("launcher-usage.json")

    FileView {
        id: usageFile
        path: root.usagePath
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        JsonAdapter {
            id: adapter
            property var usage: ({})
        }
    }

    function _entryFor(id) {
        const u = adapter.usage || {};
        const e = u[id];
        if (e && typeof e.count === "number" && typeof e.last === "number") return e;
        return { count: 0, last: 0 };
    }

    function score(id) {
        const e = _entryFor(id);
        return (e.count * 1000000000000) + e.last;
    }

    function bump(id) {
        const u0 = adapter.usage || {};
        const u = Object.assign({}, u0);
        const prev = _entryFor(id);

        u[id] = {
            count: prev.count + 1,
            last: Date.now()
        };

        adapter.usage = u;
    }
}
