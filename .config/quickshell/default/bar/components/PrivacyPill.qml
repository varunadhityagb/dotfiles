import QtQuick
import QtQuick.Layouts

import "../models"
import "./PillBtn.qml"

PillBtn {
    visible:
        PrivacyModel.micActive ||
        PrivacyModel.screenShareActive

    content: RowLayout {
        spacing: 6

        Text {
            visible: PrivacyModel.micActive

            text: "󰍬"

            font.family: rootBar.fontFamily
            font.pixelSize: rootBar.fontSize + 5

            color: rootBar.blue
        }

        Text {
            visible: PrivacyModel.screenShareActive

            text: "󰹑"

            font.family: rootBar.fontFamily
            font.pixelSize: rootBar.fontSize + 15

            color: rootBar.blue
        }
    }

    Tooltip {
        targetItem: parent
        text: PrivacyModel.tooltipText
    }
}
