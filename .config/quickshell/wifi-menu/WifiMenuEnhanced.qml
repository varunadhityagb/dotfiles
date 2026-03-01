import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

PanelWindow {
    id: wifiPanel
    
    width: 350
    height: 600
    color: "transparent"
    
    // Background with glassmorphism
    Rectangle {
        id: glassBackground
        anchors.fill: parent
        anchors.margins: 10
        radius: 16
        
        // Dark translucent background
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#3a3d4a" }
            GradientStop { position: 1.0; color: "#2a2d3a" }
        }
        opacity: 0.92
        
        // Border for glass effect
        border.color: Qt.rgba(1, 1, 1, 0.15)
        border.width: 1
        
        // Subtle shadow
        layer.enabled: true
    }
    
    // Content
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 16
        
        // Header with Wi-Fi toggle
        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            
            Text {
                text: "Wi-Fi"
                font.pixelSize: 18
                font.weight: Font.Medium
                color: "#e8eaed"
                font.family: "Inter"
            }
            
            Item { Layout.fillWidth: true }
            
            // iOS-style toggle switch
            Rectangle {
                id: toggleBackground
                width: 52
                height: 32
                radius: 16
                color: wifiEnabled ? "#5b9dd9" : "#404556"
                
                Behavior on color { 
                    ColorAnimation { duration: 200; easing.type: Easing.InOutQuad } 
                }
                
                Rectangle {
                    id: toggleKnob
                    width: 28
                    height: 28
                    radius: 14
                    color: "white"
                    x: wifiEnabled ? parent.width - width - 2 : 2
                    y: 2
                    
                    Behavior on x { 
                        NumberAnimation { duration: 200; easing.type: Easing.OutCubic } 
                    }
                    
                    // Subtle shadow on knob
                    layer.enabled: true
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: toggleWifi()
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
        
        // Search bar
        Rectangle {
            Layout.fillWidth: true
            height: 44
            radius: 8
            color: "#1f222d"
            border.color: Qt.rgba(1, 1, 1, 0.1)
            border.width: 1
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10
                
                Text {
                    text: "⚲"
                    font.pixelSize: 18
                    color: "#6a6d76"
                }
                
                TextInput {
                    id: searchInput
                    Layout.fillWidth: true
                    font.pixelSize: 14
                    color: "#e8eaed"
                    selectByMouse: true
                    
                    onTextChanged: filterNetworks(text)
                    
                    Text {
                        text: "Search Networks..."
                        font.pixelSize: 14
                        color: "#5a5d66"
                        visible: searchInput.text === "" && !searchInput.activeFocus
                    }
                }
            }
        }
        
        // Known Network section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8
            visible: connectedNetwork !== ""
            
            Text {
                text: "KNOWN NETWORK"
                font.pixelSize: 11
                font.weight: Font.DemiBold
                font.letterSpacing: 0.5
                color: "#8a8d96"
                leftPadding: 4
            }
            
            Rectangle {
                id: connectedNetworkItem
                Layout.fillWidth: true
                height: 56
                radius: 8
                color: connectedMouse.containsMouse ? "#3d4250" : "#363a48"
                border.color: "#4a4e5c"
                border.width: 1
                
                Behavior on color { ColorAnimation { duration: 150 } }
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 12
                    
                    // Wi-Fi signal icon
                    Text {
                        text: getSignalIcon(100)
                        font.pixelSize: 20
                    }
                    
                    Text {
                        text: connectedNetwork
                        font.pixelSize: 15
                        font.weight: Font.Medium
                        color: "#e8eaed"
                        Layout.fillWidth: true
                    }
                    
                    // Lock icon for secured networks
                    Text {
                        text: "🔒"
                        font.pixelSize: 15
                        color: "#8a8d96"
                        opacity: 0.7
                    }
                    
                    // Connected checkmark
                    Text {
                        text: "✓"
                        font.pixelSize: 18
                        color: "#5b9dd9"
                        font.weight: Font.Bold
                    }
                }
                
                MouseArea {
                    id: connectedMouse
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    
                    onClicked: showNetworkDetails(connectedNetwork)
                }
            }
        }
        
        // Other Networks section
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 8
            
            Text {
                text: "OTHER NETWORKS"
                font.pixelSize: 11
                font.weight: Font.DemiBold
                font.letterSpacing: 0.5
                color: "#8a8d96"
                leftPadding: 4
            }
            
            // Scrollable network list
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                
                ColumnLayout {
                    width: parent.width - 10
                    spacing: 4
                    
                    Repeater {
                        id: networkRepeater
                        model: networkListModel
                        
                        delegate: Rectangle {
                            Layout.fillWidth: true
                            height: 56
                            radius: 8
                            color: networkMouse.containsMouse ? "#2d3040" : "transparent"
                            
                            Behavior on color { ColorAnimation { duration: 150 } }
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 12
                                
                                Text {
                                    text: getSignalIcon(model.signal)
                                    font.pixelSize: 20
                                }
                                
                                Text {
                                    text: model.ssid
                                    font.pixelSize: 15
                                    color: "#e8eaed"
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
                                
                                Text {
                                    text: "🔒"
                                    font.pixelSize: 15
                                    color: "#8a8d96"
                                    opacity: 0.7
                                    visible: model.secure
                                }
                            }
                            
                            MouseArea {
                                id: networkMouse
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                
                                onClicked: connectToNetwork(model.ssid, model.secure)
                            }
                        }
                    }
                }
            }
        }
        
        // Footer with settings button
        Rectangle {
            Layout.fillWidth: true
            height: 44
            radius: 8
            color: settingsMouse.containsMouse ? "#2d3040" : "#252835"
            border.color: Qt.rgba(1, 1, 1, 0.05)
            border.width: 1
            
            Behavior on color { ColorAnimation { duration: 150 } }
            
            Text {
                anchors.centerIn: parent
                text: "Wi-Fi Settings..."
                font.pixelSize: 14
                color: "#b8bbc4"
            }
            
            MouseArea {
                id: settingsMouse
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                
                onClicked: openWifiSettings()
            }
        }
    }
    
    // Data model for networks
    ListModel {
        id: networkListModel
    }
    
    // Properties
    property bool wifiEnabled: true
    property string connectedNetwork: "GBA"
    
    // Process declarations - all defined at the top level
    Process {
        id: networkScanner
        command: ["nmcli", "-t", "-f", "SSID,SIGNAL,SECURITY", "device", "wifi", "list"]
        
        onExited: {
            if (exitCode === 0) {
                parseNetworks(stdout)
            }
        }
    }
    
    Process {
        id: wifiToggleProcess
        command: ["nmcli", "radio", "wifi", wifiEnabled ? "on" : "off"]
    }
    
    Process {
        id: wifiConnectProcess
        onExited: {
            if (exitCode === 0) {
                networkScanner.running = true
            }
        }
    }
    
    Process {
        id: wifiSettingsProcess
        command: ["nm-connection-editor"]
    }
    
    // Refresh timer
    Timer {
        interval: 10000 // Refresh every 10 seconds
        running: wifiPanel.visible && wifiEnabled
        repeat: true
        onTriggered: networkScanner.running = true
    }
    
    // Functions
    function toggleWifi() {
        wifiEnabled = !wifiEnabled
        wifiToggleProcess.command = ["nmcli", "radio", "wifi", wifiEnabled ? "on" : "off"]
        wifiToggleProcess.running = true
    }
    
    function parseNetworks(output) {
        networkListModel.clear()
        
        var lines = output.split('\n')
        for (var i = 0; i < lines.length; i++) {
            var parts = lines[i].split(':')
            if (parts.length >= 3 && parts[0] !== connectedNetwork && parts[0].trim() !== "") {
                networkListModel.append({
                    ssid: parts[0],
                    signal: parseInt(parts[1]) || 50,
                    secure: parts[2].indexOf("WPA") >= 0 || parts[2].indexOf("WEP") >= 0
                })
            }
        }
    }
    
    function getSignalIcon(strength) {
        if (strength > 80) return "📶"
        if (strength > 60) return "📶"
        if (strength > 40) return "📡"
        return "📡"
    }
    
    function connectToNetwork(ssid, secure) {
        console.log("Attempting to connect to:", ssid)
        
        if (secure) {
            // Use --ask flag to prompt for password
            wifiConnectProcess.command = ["nmcli", "--ask", "device", "wifi", "connect", ssid]
        } else {
            wifiConnectProcess.command = ["nmcli", "device", "wifi", "connect", ssid]
        }
        wifiConnectProcess.running = true
    }
    
    function showNetworkDetails(ssid) {
        console.log("Showing details for:", ssid)
    }
    
    function openWifiSettings() {
        wifiSettingsProcess.running = true
    }
    
    function filterNetworks(searchText) {
        // Filter logic would go here
        // For now, just refresh the list
        if (searchText === "") {
            networkScanner.running = true
        }
    }
    
    Component.onCompleted: {
        // Initial network scan
        networkScanner.running = true
    }
}
