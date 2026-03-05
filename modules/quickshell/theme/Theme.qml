pragma Singleton
import QtQuick
import Quickshell


Singleton {
    id: theme

    // --- MAIN COLORS ---
    readonly property color bg:        Colors.background
    readonly property color bttnbg:    Colors.surface_container
    readonly property color border:    Colors.outline
    readonly property color accent:    Colors.primary
    readonly property color danger:    Colors.error
    readonly property color text:      Colors.on_background
    readonly property color subText:   Colors.on_surface_variant

    // --- GRID BUTTONS ---
    readonly property color gridBttn_on_bg:    Colors.primary_container
    readonly property color gridBttn_on_ttl:   Colors.on_primary_container
    readonly property color gridBttn_on_subt:  Colors.on_primary

    readonly property color gridBttn_off_bg:   Colors.surface_container_low
    readonly property color gridBttn_off_ttl:  Colors.on_surface
    readonly property color gridBttn_off_subt: Colors.on_surface_variant

    readonly property color gridBttn_disc_bg:  Colors.error_container
    readonly property color gridBttn_disc_ttl: Colors.on_error_container
    readonly property color gridBttn_disc_subt: Colors.on_error

    // --- WIDGETS ---
    readonly property color widget:    Colors.surface_container_lowest
    readonly property color coverArt:  Colors.surface_container

    // --- BATTERY ---
    readonly property color battNormal:   Colors.secondary_container
    readonly property color battCharging:  Colors.tertiary_container
    readonly property color battLow:       Colors.error_container
    readonly property color battText:      Colors.on_secondary_container

    // --- BACKGROUND GRADIENT ---
    readonly property color gradientTop:    Colors.surface_container_lowest
    readonly property color gradientBottom: Colors.background

    Component.onCompleted: {
        console.log("BG:", Colors.background)
        console.log("[Theme] Matugen dynamic theme loaded")
    }
}
