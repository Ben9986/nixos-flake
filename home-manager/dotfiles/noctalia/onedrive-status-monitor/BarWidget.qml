import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs.Widgets
import qs.Commons
import qs.Services.UI
import qs.Services.System

// We use a Row to display the two icons side-by-side
Rectangle {
    id: root

    property var pluginApi: null
    property ShellScreen screen
    property string widgetId: "onedrive-status-monitor"
    property string section: "right"

    // Horizontal bar (top/bottom)
    // implicitWidth: content.implicitWidth + Style.marginM * 2
    // implicitHeight: Style.barHeight

    // Vertical bar (left/right) - adapt to bar position
    readonly property string barPosition: Settings.data.bar.position
    readonly property bool isVertical: barPosition === "left" || barPosition === "right"

    implicitWidth: isVertical ? Style.capsuleHeight : row.implicitWidth + Style.marginM * 2
    implicitHeight: isVertical ? row.implicitHeight + Style.marginM * 2 : Style.capsuleHeight

    // Required: Background color
    color: Style.capsuleColor
    radius: Style.radiusM
    border.color: Style.capsuleBorderColor
    border.width: Style.capsuleBorderWidth
    // --- Configuration ---
    property string serviceName1: "onedrive@onedrive"
    property string serviceName2: "onedrive@onedrive-strath"

    property string serviceName1Pretty: "OneDrive Personal"
    property string serviceName2Pretty: "Onedrive Strathclyde"

    property bool s1Active: false
    property bool s2Active: false

    // --- Service 1 Monitor ---
    Process {
        id: checkService1
        // 'is-active' returns "active" or "inactive"
        command: ["systemctl", "--user", "is-active", root.serviceName1]
        stdout: StdioCollector {
            onTextChanged: {
                // If text contains "active", show checkmark, else show alert
                if (text.trim() === "active") {
                    icon1.icon = "cloud-check" // Tabler icon name
                    icon1.color = Color.mOnSurface     // Green (adjust to your theme)
                    s1Active = true
                } else {
                    icon1.icon = "cloud-off"
                    icon1.color = Color.mError// "#ed8796"     // Red
                    s1Active=false
                }
            }
        }
    }

    // --- Service 2 Monitor ---
    Process {
        id: checkService2
        command: ["systemctl", "--user", "is-active", root.serviceName2]
        stdout: StdioCollector {
            onTextChanged: {
                if (text.trim() === "active") {
                    icon2.icon = "school"
                    icon2.color = Color.mOnSurface     // Blue
                    s2Active = true
                } else {
                    icon2.icon = "school-off"
                    icon2.color = Color.mError     // red
                    s2Active = false
                }
            }
        }
    }


    // Process {
    //     id: restartService1
    //     command: ["systemctl", "--user", "start", root.serviceName1 ]
    // }
    
    // Process {
    //     id: restartService2
    //     command: ["systemctl", "--user", "start", root.serviceName2 ]
    // }

    Process {
        id: commandProc
        // We leave command empty for now and set it dynamically
        command: [] 
        
        onExited: {
            // After the action finishes, refresh the status icons immediately
            checkService1.running = true
            checkService2.running = true
        }
    }
    // --- Timer to Refresh Status ---
    Timer {
        interval: 5000 // Check every 5000ms (5 seconds)
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            checkService1.running = false
            checkService1.running = true
            checkService2.running = false
            checkService2.running = true
        }
    }

    function buildTooltip(icon) {
        var name = (icon === icon1) ? "Personal" : "Strathclyde"
        return name + ": " + (icon.active ? "Active" : "Inactive")
    }


    NPopupContextMenu {
    id: contextMenu1
    model: [
        { 
            "label": 'Service Status',
            "action": "status",
            "icon": "info-square-rounded"
        },
        {
            "label": root.s1Active ? `Stop ${root.serviceName1Pretty}` : `Start ${root.serviceName1Pretty}`,
            "action": root.s1Active ? "stop" : "start",
            "icon": root.s1Active ? "player-stop" : "player-play"
        },
        { 
            "label": `Restart ${root.serviceName1Pretty}`,
            "action": "restart",
            "icon": "refresh"
        },
    ]

    onTriggered: action => {
      var popupMenuWindow = PanelService.getPopupMenuWindow(screen);
      if (popupMenuWindow) popupMenuWindow.close();

      if (action == "status") commandProc.command = [ "kitty", "-e", "--user", "status", root.serviceName1]
      else if (action === "start") commandProc.command = ["systemctl", "--user", "start", root.serviceName1];
      else if (action === "stop") commandProc.command = ["systemctl", "--user", "stop", root.serviceName1];
      else if (action === "restart") commandProc.command = ["systemctl", "--user", "restart", root.serviceName1];

      if (action !== "settings") commandProc.running = true;
    }
  }

  NPopupContextMenu {
    id: contextMenu2
    model: [
        { 
            "label": 'Service Status',
            "action": "status",
            "icon": "info-square-rounded"
        },
        {
            "label": root.s2Active ? `Stop ${root.serviceName2Pretty}` : `Start ${root.serviceName2Pretty}`,
            "action": root.s2Active ? "stop" : "start",
            "icon": root.s2Active ? "player-stop" : "player-play"
        },
        { 
            "label": `Restart ${root.serviceName2Pretty}`,
            "action": "restart",
            "icon": "refresh"
        },
    ]

    onTriggered: action => {
      var popupMenuWindow = PanelService.getPopupMenuWindow(screen);
      if (popupMenuWindow) popupMenuWindow.close();

      if (action == "status") commandProc.command = [ "kitty", "-e", "--user", "status", root.serviceName2]  
      else if (action === "start") commandProc.command = ["systemctl", "--user", "start", root.serviceName2];
      else if (action === "stop") commandProc.command = ["systemctl", "--user", "stop", root.serviceName2];
      else if (action === "restart") commandProc.command = ["systemctl", "--user", "restart", root.serviceName2];

      if (action !== "settings") commandProc.running = true;
    }
  }

  Timer {
      id: delayTimer
      interval: 500 
      onTriggered: statusCheck.running = true
  }
    
    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: Style.marginS
        uniformCellSizes: true
        
    Item {
        Layout.minimumWidth: 18; Layout.minimumHeight: 16 // Standard icon size
        
        NIcon {
            id: icon1
            anchors.centerIn: parent
            icon: "question-mark"
            color: Color.mPrimary
            applyUiScale: false
            // property bool active: false
            // size: 20
        }
        
        MouseArea {
            id: ma1
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            hoverEnabled: true
            onClicked: (mouse) => {
                    // Left click: Just refresh
                    if (mouse.button === Qt.LeftButton) {
                        checkService1.running = true;
                        return;
                    }

                    // Right click: Show Menu 1
                    var popupMenuWindow = PanelService.getPopupMenuWindow(screen);
                    if (popupMenuWindow) {
                        popupMenuWindow.showContextMenu(contextMenu1);
                        // Open strictly at this specific icon
                        contextMenu1.openAtItem(ma1, screen);
                    }
                }
            /* onEntered: {
                TooltipService.show(root, buildTooltip(icon1), BarService.getTooltipDirection())
            }
            onExited: { TooltipService.hide()} */
        }
    }

    Item {
        Layout.minimumWidth: 18; Layout.minimumHeight: 16 // Standard icon size
        
        NIcon {
            id: icon2
            anchors.centerIn: parent
            icon: "question-mark"
            color: Color.mPrimary
            applyUiScale: false
            // property bool active: false
            // size: 20
        }
        
        MouseArea {
            id: ma2
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            hoverEnabled: true
            onClicked: (mouse) => {
                    if (mouse.button === Qt.LeftButton) {
                        checkService2.running = true;
                        return;
                    }

                    // Right click: Show Menu 2
                    var popupMenuWindow = PanelService.getPopupMenuWindow(screen);
                    if (popupMenuWindow) {
                        popupMenuWindow.showContextMenu(contextMenu2);
                        contextMenu2.openAtItem(ma2, screen);
                    }
                }
            onEntered: {
                TooltipService.show(root, buildTooltip(icon2), BarService.getTooltipDirection())
            }
            onExited: { TooltipService.hide()}
        }
    }
    }
    // --- Visual Icons ---
    // Using NIconButton for native Noctalia look and feel
    //NIconButton {
    //    id: icon1
    //     icon: "question-mark" // Default icon before first check
    //     onClicked: checkService1.running = true // Force refresh on click
    //     applyUiScale: true
    // }

    /* NIconButton {
        id: icon2
        icon: "question-mark"
        onClicked: checkService2.running = true
    } */
}
