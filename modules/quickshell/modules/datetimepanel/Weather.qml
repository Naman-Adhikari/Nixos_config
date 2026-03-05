import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.theme as Theme

Rectangle {
    id: root
    radius: 14
    color: Theme.Theme.widget

    // Expansion API
    property bool expanded: false
    signal requestExpand()
    signal requestCollapse()

    // Layout
    readonly property int rowH: 32
    readonly property int dayW: 58
    readonly property int iconBoxW: 38
    readonly property int iconPx: 38
    readonly property int tempW: 38
    readonly property int sepH: 1
    readonly property int iconYOffset: 9
    readonly property int heroRightMargin: -14
    readonly property int rimW: 6
    readonly property int topBarH: 24
    property bool rimHovered: false

    border.width: rimHovered ? 2 : 0
    border.color: Theme.Theme.border
    Behavior on border.width { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

    property string iconDir: ""
    property bool isNight: false
    property double sunriseMs: NaN
    property double sunsetMs: NaN

    // Icon paths
    property string iconBase: "file://" + Quickshell.env("HOME") + "/.config/quickshell/assets/weather_icons"
    property var iconPaths: ({
        clear:            { day: iconBase + "/sun-1.svg", night: iconBase + "/moon-1.svg" },
        mostly_clear:     { day: iconBase + "/sun-1.svg", night: iconBase + "/moon-1.svg" },
        partly_cloudy:    { day: iconBase + "/partly-cloudy-1.svg", night: iconBase + "/partly-cloudy-3.svg" },
        overcast:         { day: iconBase + "/mostly-cloudy-1.svg", night: iconBase + "/mostly-cloudy-1.svg" },
        fog:              { day: iconBase + "/fog-1.svg", night: iconBase + "/fog-4.svg" },
        drizzle_light:    { day: iconBase + "/drizzle.svg", night: iconBase + "/drizzle.svg" },
        drizzle:          { day: iconBase + "/drizzle.svg", night: iconBase + "/drizzle.svg" },
        drizzle_heavy:    { day: iconBase + "/drizzle.svg", night: iconBase + "/drizzle.svg" },
        drizzle_freezing: { day: iconBase + "/snow-day-1.svg", night: iconBase + "/snow-night-1.svg" },
        rain_light:       { day: iconBase + "/rain-1.svg", night: iconBase + "/rain-1.svg" },
        rain:             { day: iconBase + "/rain-1.svg", night: iconBase + "/rain-1.svg" },
        rain_heavy:       { day: iconBase + "/heavy-rain-1.svg", night: iconBase + "/heavy-rain-1.svg" },
        rain_freezing:    { day: iconBase + "/hail-1.svg", night: iconBase + "/hail-1.svg" },
        snow_light:       { day: iconBase + "/snow.svg", night: iconBase + "/snow.svg" },
        snow:             { day: iconBase + "/snow.svg", night: iconBase + "/snow.svg" },
        snow_heavy:       { day: iconBase + "/blizzard.svg", night: iconBase + "/blizzard.svg" },
        snow_grains:      { day: iconBase + "/blizzard.svg", night: iconBase + "/blizzard.svg" },
        showers_light:    { day: iconBase + "/rain-1.svg", night: iconBase + "/rain-1.svg" },
        showers:          { day: iconBase + "/rain-1.svg", night: iconBase + "/rain-1.svg" },
        showers_heavy:    { day: iconBase + "/heavy-rain-1.svg", night: iconBase + "/heavy-rain-1.svg" },
        snow_showers:     { day: iconBase + "/rain-and-snow.svg", night: iconBase + "/rain-and-snow.svg" },
        thunder:          { day: iconBase + "/thunderstorm.svg", night: iconBase + "/thunderstorm.svg" },
        thunder_hail:     { day: iconBase + "/thunderstorm.svg", night: iconBase + "/thunderstorm.svg" },
        unknown:          { day: iconBase + "/sun-1.svg", night: iconBase + "/moon-1.svg" }
    })

    property bool active: true
    property real tempF: NaN
    property int weatherCode: -1
    property string condition: "Loading…"
    property real lat: NaN
    property real lon: NaN
    property string greeting: weekdayGreeting(new Date())
    property string cityLine: "Locating…"

    // Daily forecast
    property var dailyTimes: []
    property var dailyCode: []
    property var dailyHiF: []
    property var dailyLoF: []
    property int dailyCount: 0
    readonly property int shownDays: Math.min(dailyCount, 10)
    readonly property real todayHiF: (dailyCount > 0 && dailyHiF.length > 0) ? Number(dailyHiF[0]) : NaN
    readonly property real todayLoF: (dailyCount > 0 && dailyLoF.length > 0) ? Number(dailyLoF[0]) : NaN

    // Weather code mappings
    readonly property var codeToKey: ({
        0: "clear", 1: "mostly_clear", 2: "partly_cloudy", 3: "overcast",
        45: "fog", 48: "fog",
        51: "drizzle_light", 53: "drizzle", 55: "drizzle_heavy",
        56: "drizzle_freezing", 57: "drizzle_freezing",
        61: "rain_light", 63: "rain", 65: "rain_heavy",
        66: "rain_freezing", 67: "rain_freezing",
        71: "snow_light", 73: "snow", 75: "snow_heavy", 77: "snow_grains",
        80: "showers_light", 81: "showers", 82: "showers_heavy",
        85: "snow_showers", 86: "snow_showers",
        95: "thunder", 96: "thunder_hail", 99: "thunder_hail"
    })

    readonly property var codeToCondition: ({
        0: "Clear", 1: "Mostly clear", 2: "Partly cloudy", 3: "Overcast",
        45: "Fog", 48: "Fog",
        51: "Light drizzle", 53: "Drizzle", 55: "Heavy drizzle",
        56: "Freezing drizzle", 57: "Freezing drizzle",
        61: "Light rain", 63: "Rain", 65: "Heavy rain",
        66: "Freezing rain", 67: "Freezing rain",
        71: "Light snow", 73: "Snow", 75: "Heavy snow", 77: "Snow grains",
        80: "Light showers", 81: "Showers", 82: "Heavy showers",
        85: "Snow showers", 86: "Snow showers",
        95: "Thunderstorm", 96: "Thunderstorm (hail)", 99: "Thunderstorm (hail)"
    })

    function weekdayGreeting(d) {
        const dow = d.getDay()
        if (dow === 5) return "Happy Friday"
        if (dow === 6) return "It's Saturday!"
        return Qt.formatDateTime(d, "dddd")
    }

    function cityOnly(line) {
        if (!line) return ""
        const idx = line.indexOf(",")
        return (idx === -1 ? line : line.slice(0, idx)).trim()
    }

    function parseLocalIso(iso) {
        if (!iso || iso.indexOf("T") === -1) return NaN
        const parts = iso.split("T")
        const d = parts[0].split("-")
        const t = parts[1].split(":")
        if (d.length < 3 || t.length < 2) return NaN
        return new Date(
            parseInt(d[0], 10), parseInt(d[1], 10) - 1, parseInt(d[2], 10),
            parseInt(t[0], 10), parseInt(t[1], 10),
            (t.length >= 3) ? parseInt(t[2], 10) : 0
        ).getTime()
    }

    function updateNightFlag() {
        if (!isNaN(sunriseMs) && !isNaN(sunsetMs)) {
            const now = Date.now()
            const nightStart = sunsetMs + (60 * 60 * 1000)
            root.isNight = (now >= nightStart) || (now < sunriseMs)
        }
    }

    function iconKeyForCode(code) { return codeToKey[code] || "unknown" }
    function conditionForCode(code) { return codeToCondition[code] || "Unknown" }

    function iconSourceFor(code, night) {
        const key = iconKeyForCode(Number(code))
        const entry = iconPaths[key]
        const preferred = entry ? (night ? entry.night : entry.day) : ""
        if (preferred) return Qt.resolvedUrl(preferred)
        if (iconDir) return Qt.resolvedUrl(iconDir + "/" + key + ".svg")
        return ""
    }

    function iconSource() { return iconSourceFor(weatherCode, root.isNight) }

    function dayLabel(yyyy_mm_dd, idx) {
        if (idx === 0) return "Today"
        if (!yyyy_mm_dd || yyyy_mm_dd.length < 10) return ""
        const y = parseInt(yyyy_mm_dd.slice(0,4), 10)
        const m = parseInt(yyyy_mm_dd.slice(5,7), 10) - 1
        const d = parseInt(yyyy_mm_dd.slice(8,10), 10)
        return Qt.formatDateTime(new Date(y, m, d), "ddd")
    }

    function refresh() {
        greeting = weekdayGreeting(new Date())
        updateNightFlag()
        if (!isNaN(lat) && !isNaN(lon)) fetchWeather()
        else fetchGeo()
    }

    function fetchGeo() {
        if (ipProc.running) return
        condition = "Locating…"
        cityLine = "Locating…"
        ipProc.buffer = ""
        ipProc.running = true
    }

    function fetchWeather() {
        if (meteoProc.running) return
        if (!isNaN(tempF)) condition = "Updating…"
        meteoProc.buffer = ""
        meteoProc.command = ["sh", "-c",
            "curl -s 'https://api.open-meteo.com/v1/forecast" +
            "?latitude=" + lat + "&longitude=" + lon +
            "&current=temperature_2m,weather_code" +
            "&daily=weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset" +
            "&forecast_days=10&temperature_unit=fahrenheit&timezone=auto'"]
        meteoProc.running = true
    }

    // Rim toggle
    MouseArea {
        anchors.fill: parent
        z: 999
        hoverEnabled: true
        propagateComposedEvents: true

        function inToggleZone(mx, my) {
            return (my <= root.topBarH) ||
                   (mx < root.rimW || mx > (width - root.rimW) ||
                    my < root.rimW || my > (height - root.rimW))
        }

        onPositionChanged: (m) => {
            root.rimHovered = inToggleZone(m.x, m.y)
            cursorShape = root.rimHovered ? Qt.PointingHandCursor : Qt.ArrowCursor
        }
        onExited: { root.rimHovered = false; cursorShape = Qt.ArrowCursor }
        onClicked: (m) => {
            if (!inToggleZone(m.x, m.y)) { m.accepted = false; return }
            root.expanded ? root.requestCollapse() : root.requestExpand()
            m.accepted = true
        }
    }

    // Content layers
    Item {
        anchors.fill: parent
        anchors.margins: 12

        // Collapsed view
        Item {
            anchors.fill: parent
            opacity: root.expanded ? 0 : 1
            visible: opacity > 0.01
            Behavior on opacity { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }

            Column {
                anchors.left: parent.left
                anchors.top: parent.top
                spacing: 2

                Text {
                    text: root.greeting
                    color: Theme.Theme.text
                    opacity: 0.9
                    font.pixelSize: 24
                    font.weight: 300
                    font.family: "Adwaita Sans"
                }

                Text {
                    text: isNaN(root.tempF) ? "--°F" : (Math.round(root.tempF) + "°F")
                    color: Theme.Theme.text
                    font.pixelSize: 24
                    font.weight: 600
                    font.family: "Adwaita Sans"
                }

                Text {
                    text: root.cityLine
                    color: Theme.Theme.accent
                    font.pixelSize: 12
                    font.family: "Adwaita Sans"
                    elide: Text.ElideRight
                }
            }

            Image {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 36
                anchors.rightMargin: -22
                width: 150
                height: 150
                source: root.iconSource()
                fillMode: Image.PreserveAspectFit
                smooth: true
                visible: source !== ""
                opacity: 0.95
            }
        }

        // Expanded view
        Item {
            anchors.fill: parent
            opacity: root.expanded ? 1 : 0
            visible: opacity > 0.01
            Behavior on opacity { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }

            Image {
                id: heroIcon
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.rightMargin: root.heroRightMargin
                width: 104
                height: 104
                source: root.iconSource()
                fillMode: Image.PreserveAspectFit
                smooth: true
                visible: source !== ""
                opacity: 0.95
            }

            Column {
                id: headerCol
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: heroIcon.visible ? (heroIcon.width + 10) : 0
                spacing: 6

                Text {
                    text: "Weather for " + (root.cityOnly(root.cityLine) || "…")
                    color: Theme.Theme.text
                    font.pixelSize: 16
                    font.weight: 500
                    font.family: "Adwaita Sans"
                    elide: Text.ElideRight
                }

                Text {
                    text: isNaN(root.tempF) ? "--°F" : (Math.round(root.tempF) + "°F")
                    color: Theme.Theme.text
                    font.pixelSize: 20
                    font.weight: 600
                    font.family: "Adwaita Sans"
                }

                Row {
                    spacing: 8

                    Text {
                        text: (isNaN(root.todayHiF) || isNaN(root.todayLoF))
                              ? "High --°  •  Low --°"
                              : ("High " + Math.round(root.todayHiF) + "°  •  Low " + Math.round(root.todayLoF) + "°")
                        color: Theme.Theme.subText
                        font.pixelSize: 13
                        font.weight: 600
                        font.family: "Adwaita Sans"
                    }

                    Text {
                        text: root.condition || ""
                        visible: text.length > 0
                        color: Theme.Theme.accent
                        font.pixelSize: 13
                        font.weight: 600
                        font.family: "Adwaita Sans"
                    }
                }
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: headerCol.bottom
                anchors.topMargin: 10
                height: 1
                color: Theme.Theme.bttnbg
                opacity: 0.7
            }

            Flickable {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: headerCol.bottom
                anchors.bottom: parent.bottom
                anchors.topMargin: 14
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                contentWidth: width
                contentHeight: forecastList.implicitHeight

                Column {
                    id: forecastList
                    width: parent.width
                    spacing: 0

                    Repeater {
                        model: root.shownDays
                        delegate: Item {
                            width: forecastList.width
                            height: root.rowH

                            Rectangle {
                                id: sep
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                height: root.sepH
                                color: Theme.Theme.bttnbg
                                opacity: (index < (root.shownDays - 1)) ? 0.35 : 0.0
                            }

                            RowLayout {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.bottom: sep.top
                                spacing: 10

                                Text {
                                    Layout.preferredWidth: root.dayW
                                    Layout.fillHeight: true
                                    verticalAlignment: Text.AlignVCenter
                                    text: root.dayLabel(String(root.dailyTimes[index]), index)
                                    color: "#cdd6f4"
                                    font.pixelSize: 13
                                    font.weight: 700
                                    font.family: "Adwaita Sans"
                                }

                                Item {
                                    Layout.preferredWidth: root.iconBoxW
                                    Layout.fillHeight: true
                                    Image {
                                        anchors.centerIn: parent
                                        anchors.verticalCenterOffset: root.iconYOffset
                                        width: root.iconPx
                                        height: root.iconPx
                                        source: root.iconSourceFor(root.dailyCode[index], false)
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                        visible: source !== ""
                                        opacity: 0.95
                                    }
                                }

                                Item { Layout.fillWidth: true }

                                Text {
                                    Layout.preferredWidth: root.tempW
                                    Layout.fillHeight: true
                                    horizontalAlignment: Text.AlignRight
                                    verticalAlignment: Text.AlignVCenter
                                    text: (root.dailyHiF.length > index ? Math.round(Number(root.dailyHiF[index])) : "--") + "°"
                                    color: Theme.Theme.text
                                    font.pixelSize: 13
                                    font.weight: 700
                                    font.family: "Adwaita Sans"
                                }

                                Text {
                                    Layout.preferredWidth: root.tempW
                                    Layout.fillHeight: true
                                    horizontalAlignment: Text.AlignRight
                                    verticalAlignment: Text.AlignVCenter
                                    text: (root.dailyLoF.length > index ? Math.round(Number(root.dailyLoF[index])) : "--") + "°"
                                    color: Theme.Theme.subText
                                    font.pixelSize: 13
                                    font.weight: 700
                                    font.family: "Adwaita Sans"
                                }
                            }
                        }
                    }
                }

                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

                // Scroll fade indicator
                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 18
                    z: 10
                    visible: parent.contentHeight > parent.height + 1 &&
                             parent.contentY < (parent.contentHeight - parent.height - 1)
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#001e1e2e" }
                        GradientStop { position: 1.0; color: "#d91e1e2e" }
                    }
                }
            }
        }
    }

    Timer {
        interval: 600000
        repeat: true
        running: root.active
        triggeredOnStart: true
        onTriggered: root.refresh()
    }

    // Location fetch
    Process {
        id: ipProc
        command: ["sh", "-c", "curl -s 'https://ipinfo.io/json'"]
        property string buffer: ""
        stdout: SplitParser { onRead: data => { ipProc.buffer += data } }

        onRunningChanged: {
            if (running) return
            if (!ipProc.buffer || ipProc.buffer.trim() === "") {
                root.condition = "Location failed"
                return
            }
            try {
                const obj = JSON.parse(ipProc.buffer)
                const city = (obj.city || "").trim()
                const region = (obj.region || "").trim()
                root.cityLine = city ? (region ? (city + ", " + region) : city) : "Unknown location"

                const loc = (obj.loc || "").split(",")
                const latV = parseFloat(loc[0])
                const lonV = parseFloat(loc[1])
                if (isNaN(latV) || isNaN(lonV)) throw "bad loc"
                root.lat = latV
                root.lon = lonV
                root.fetchWeather()
            } catch (e) {
                root.condition = "Location failed"
                root.cityLine = "Location failed"
            }
        }
    }

    // Weather fetch
    Process {
        id: meteoProc
        property string buffer: ""
        stdout: SplitParser { onRead: data => { meteoProc.buffer += data } }

        onRunningChanged: {
            if (running) return
            if (!meteoProc.buffer || meteoProc.buffer.trim() === "") {
                root.condition = "Weather failed"
                return
            }
            try {
                const obj = JSON.parse(meteoProc.buffer)
                const cur = obj.current || {}
                root.tempF = Number(cur.temperature_2m)
                root.weatherCode = Number(cur.weather_code)
                root.condition = root.conditionForCode(root.weatherCode)

                const daily = obj.daily || {}
                root.dailyTimes = daily.time || []
                root.dailyCode  = daily.weather_code || []
                root.dailyHiF   = daily.temperature_2m_max || []
                root.dailyLoF   = daily.temperature_2m_min || []

                root.dailyCount = Math.min(
                    root.dailyTimes.length, root.dailyCode.length,
                    root.dailyHiF.length, root.dailyLoF.length, 10
                )

                const sunriseStr = (daily.sunrise && daily.sunrise[0]) ? daily.sunrise[0] : ""
                const sunsetStr  = (daily.sunset  && daily.sunset[0])  ? daily.sunset[0]  : ""
                const sRise = root.parseLocalIso(sunriseStr)
                const sSet  = root.parseLocalIso(sunsetStr)
                if (!isNaN(sRise)) root.sunriseMs = sRise
                if (!isNaN(sSet))  root.sunsetMs  = sSet
                root.updateNightFlag()
            } catch (e) {
                root.condition = "Weather failed"
            }
        }
    }
}