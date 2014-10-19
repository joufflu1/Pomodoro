import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import "pad.js" as JsPad

ApplicationWindow {
    visible: true
    id: applicationWindow
    width: 300
    height: 300
    minimumWidth: 300
    minimumHeight: 300
    maximumWidth: 300
    maximumHeight: 300

    title: qsTr("Pomodoro")

    // proprietes
    property int longBreak: 600
    property int shortBreak: 300
    property int pomodoro: 1500

    Item{
        id: itemInitTime
        clip: false
        visible: true
        function initTime(){
            applicationWindow.shortBreak = 300;
            applicationWindow.longBreak = 600;
            applicationWindow.pomodoro = 1500;
        }

    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    Image {
        id: image1
        x: 38
        y: 33
        width: 225
        height: 225
        z: 1
        visible: true
        source: "qrc:/tomato2.png"

        Label {
            id: minute1
            x: 28
            y: 83
            text: qsTr("25")
            font.pointSize: 40
            font.bold: true
        }

        Label {
            id: label1
            x: 100
            y: 78
            text: qsTr(":")
            font.pointSize: 40
        }

        Label {
            id: second1
            x: 121
            y: 83
            text: qsTr("00")
            font.pointSize: 40
            font.bold: true
        }

    }

    Button {
            id: start1
            x: 7
            y: 241
            text: qsTr("Start")
            onClicked: {
                if (radioLong.checked == false)
                    radioLong.enabled = false;
                if (radioPom.checked == false)
                    radioPom.enabled = false;
                if (radioShort.checked == false)
                    radioShort.enabled = false;
                timeChrono1.start();
            }
        }

        Button {
            id: stop1
            x: 88
            y: 241
            text: qsTr("Stop")
            onClicked: {
                timeChrono1.stop();
                radioLong.enabled = true;
                radioPom.enabled = true;
                radioShort.enabled = true;
            }
        }

        Button {
            id: reset1
            x: 219
            y: 241
            text: qsTr("Reset")
            onClicked: {
                    itemInitTime.initTime();
                if (radioLong.checked == true){
                    minute1.text = JsPad.pad(longBreak/60,2);
                    second1.text = "00";
                }
                else if (radioPom.checked == true){
                    minute1.text = JsPad.pad(pomodoro/60,2);
                    second1.text = "00";
                }
                else if (radioShort.checked == true){
                    minute1.text = JsPad.pad(shortBreak/60,2);
                    second1.text = "00";
                }

            }

        }

        GroupBox {
            id: groupBox1
            x: 3
            y: 6
            width: 242
            height: 44
            ExclusiveGroup { id: group }
            anchors.horizontalCenter: parent.horizontalCenter

            RowLayout {
                x: -116
                y: -84
                visible: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                spacing: 5

                RadioButton {
                    id: radioPom
                    x: 0
                    y: 0
                    width: 51
                    height: 20
                    exclusiveGroup: group
                    checked : true
                    text: qsTr("Pom")
                    onClicked: {
                        itemInitTime.initTime();
                        minute1.text = JsPad.pad(pomodoro/60,2);
                        second1.text = "00";
                    }
                }

                RadioButton {
                    id: radioLong
                    x: 200
                    y: 1
                    text: qsTr("Long")
                    exclusiveGroup: group
                    onClicked: {
                        itemInitTime.initTime();
                        minute1.text = JsPad.pad(longBreak/60,2);
                        second1.text = "00";
                    }
                }

                RadioButton {
                    id: radioShort
                    x: 91
                    y: 1
                    text: qsTr("Short")
                    exclusiveGroup: group
                    onClicked: {
                        itemInitTime.initTime();
                        minute1.text = JsPad.pad(shortBreak/60,2);
                        second1.text = "00";
                    }
                }

            }
        }

        Item {
                x: 12
                y: 12

                Timer {
                    id: timeChrono1
                    interval: 1000; running: false; repeat: true
                    triggeredOnStart: false
                    onTriggered: {
                        if(radioPom.checked == true)
                        {
                            if (pomodoro > 0){
                                pomodoro--;
                                var currentPomCounterDate = new Date(pomodoro*1000);
                                second1.text = JsPad.pad(currentPomCounterDate.getSeconds().toString(),2);
                                minute1.text = JsPad.pad(currentPomCounterDate.getMinutes().toString(),2);
                            }
                            else{
                                stop();
                                radioLong.enabled = true;
                                radioShort.enabled = true;
                                timeforBuzz.start();
                            }
                        }
                        else if (radioLong.checked == true){
                            if (longBreak > 0){
                                longBreak--;
                                var currentLongCounterDate = new Date(longBreak*1000);
                                second1.text = JsPad.pad(currentLongCounterDate.getSeconds().toString(),2);
                                minute1.text = JsPad.pad(currentLongCounterDate.getMinutes().toString(),2);
                            }
                            else{
                                stop();
                                radioPom.enabled = true;
                                radioShort.enabled = true;
                                timeforBuzz.start();
                            }

                        }
                        else if (radioShort.checked == true){
                            if (shortBreak > 0){
                                shortBreak--;
                                var currentShortCounterDate = new Date(shortBreak*1000);
                                second1.text = JsPad.pad(currentShortCounterDate.getSeconds().toString(),2);
                                minute1.text = JsPad.pad(currentShortCounterDate.getMinutes().toString(),2);
                            }
                            else{
                                stop();
                                radioLong.enabled = true;
                                radioPom.enabled = true;
                                timeforBuzz.start();
                            }
                        }
                    }
                }

            }

           Item {

                Timer {
                    // Timer freeze fenetre
                    id: timeforBuzz
                    interval: 1; running: false; repeat: false
                    triggeredOnStart: false
                    onTriggered: {

                    var xpos = applicationWindow.x;
                    var ypos = applicationWindow.y;

                        for ( var i = 32; i > 0; )
                        {
                            var delta = i >> 2;
                            var dir = i & 3;
                            var dx = ((dir==1)||(dir==2)) ? delta : -delta;
                            var dy = (dir==2) ? delta : -delta;
                            applicationWindow.x = xpos + dx;
                            applicationWindow.y = ypos + dy;
                            i--;
                        }
                        applicationWindow.x = xpos;
                        applicationWindow.y = ypos;

                    }
                }
            }
}
