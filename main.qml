import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Window 2.1
import QtQuick.Layouts 1.1
import QtAudioEngine 1.0

import "pad.js" as JsPad

ApplicationWindow {
    id: applicationWindow1

    // Aspect de la fenetre
    x: 800
    y: 800
    visible: true
    width: 300
    height: 300
    minimumWidth: 300
    minimumHeight: 300
    maximumWidth: 300
    maximumHeight: 300
    title: qsTr("Pomodoro")
    flags: Qt.CustomizeWindowHint | Qt.WindowTitleHint | Qt.WindowSystemMenuHint | Qt.WindowMinMaxButtonsHint | Qt.WindowCloseButtonHint

    // proprietes
    property int longBreak: 600
    property int shortBreak: 300
    property int pomodoro: 1500

    Item{
        id: itemInitTime
        function initTime(){
            applicationWindow1.shortBreak = 300;
            applicationWindow1.longBreak = 600;
            applicationWindow1.pomodoro = 1500;
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
        y: 50
        width: 225
        height: 225
        visible: true
        source: "qrc:/tomato2.png"

        Label {
            id: minute1
            x: 36
            y: 83
            text: qsTr("25")
            font.pointSize: 50
            font.bold: true
        }

        Label {
            id: label1
            x: 102
            y: 78
            text: qsTr(":")
            font.pointSize: 50
        }

        Label {
            id: second1
            x: 121
            y: 83
            text: qsTr("00")
            font.pointSize: 50
            font.bold: true
        }

    }

    Button {
        id: start1
        x: 12
        y: 266
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
        x: 82
        y: 266
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
        x: 223
        y: 266
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
                        audioengine.sounds["SonneriePom"].play();
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
                        audioengine2.sounds["SonnerieEndPause"].play();
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
                        audioengine2.sounds["SonnerieEndPause"].play();
                        radioLong.enabled = true;
                        radioPom.enabled = true;
                        timeforBuzz.start();
                    }
                }
            }
        }

    }

    AudioEngine {
        id:audioengine

        AudioSample {
            name:"dring"
            source: "338.wav"
        }

        Sound {
            name:"SonneriePom"
            PlayVariation {
                sample:"dring"
                minPitch: 0.8
                maxPitch: 1.1
            }
        }
    }

    AudioEngine {
        id:audioengine2

        AudioSample {
            name:"EndPause"
            source: "346.wav"
        }

        Sound {
            name:"SonnerieEndPause"
            PlayVariation {
                sample:"EndPause"
                minGain: 1.1
                maxGain: 1.5
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

            var xpos = applicationWindow1.x;
            var ypos = applicationWindow1.y;

                for ( var i = 32; i > 0; )
                {
                    var delta = i >> 2;
                    var dir = i & 3;
                    var dx = ((dir==1)||(dir==2)) ? delta : -delta;
                    var dy = (dir==2) ? delta : -delta;
                    applicationWindow1.x = xpos + dx;
                    applicationWindow1.y = ypos + dy;
                    i--;
                }
                applicationWindow1.x = xpos;
                applicationWindow1.y = ypos;

            }
        }
    }
}
