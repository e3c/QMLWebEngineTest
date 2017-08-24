import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import "cache.js" as Cache

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

    Component.onCompleted: {
        Cache.init(10, factory, root);
    }

    onTimerChanged: {
        console.log("Timer is now", timer);

        if (current) {
            current.stop();
            Cache.release(current);
        }
        current = next;

        if (current) current.play();

        next = Cache.fetch();

        var urls = [];
        urls.push("http://www.google.com/");
        urls.push("http://www.bbc.com/");
        urls.push("http://youtube.com/");
        next.prepare(urls[Math.floor(Math.random() * 3)]);

    }


}
