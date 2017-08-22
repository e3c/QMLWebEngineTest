import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    id: root
    property var timer;

    property var next;
    property var current;

    visible: true
    width: 640
    height: 480

    Component {
        id: factory
        WebApp {

        }
    }

    onTimerChanged: {
        console.log("Timer is now", timer);

        if (current) {
            current.stop();
            current.destroy();
        }
        current = next;
        if (current) current.play();

        next = factory.createObject(root);

    }


}
