import QtQuick 2.0
import QtWebEngine 1.5

WebEngineView {
    id: view
    visible: true
    anchors.fill: parent
    opacity: 0.001

    property string uri
    property bool isPlaying: false
    property bool isShown: false


    settings.localContentCanAccessFileUrls: true
    settings.javascriptCanOpenWindows: false
    settings.errorPageEnabled: false
    settings.pluginsEnabled: false
    settings.focusOnNavigationEnabled: false
    userScripts: [
        WebEngineScript {
            sourceCode: "
                (function() {
                    window.signage = {
                        width_: " + width + ",
                        height_: " + height +"
                     };
                 })();
            "
            injectionPoint: WebEngineScript.DocumentCreation
            worldId: WebEngineScript.MainWorld
        }

    ]

    Component.onDestruction: {
        console.log("{WebApp} destroyed");
    }

    Component.onCompleted: {
        console.log(Qt.application.arguments);
        backgroundColor = "transparent"
        console.log("{WebPlayer} onCompleted", uri);
    }

    onFeaturePermissionRequested: {
        if (feature === WebEngineView.Geolocation) {
            grantFeaturePermission(securityOrigin, feature, true);
        } else {
            grantFeaturePermission(securityOrigin, feature, false);
        }
    }

    onAuthenticationDialogRequested: {
        console.log("{WebPlayer} rejecting authentication dialog");
        request.dialogReject();
    }

    onColorDialogRequested: {
        console.log("{WebPlayer} rejecting color dialog");
        request.dialogReject();
    }

    onFileDialogRequested: {
        console.log("{WebPlayer} rejecting file dialog");
        request.dialogReject();
    }

    onJavaScriptDialogRequested: {
        console.log("{WebPlayer} rejecting javascript dialog");
        request.dialogReject();
    }

    onCertificateError: {
        console.log('{WebPlayer} onCertificateError');
        error["msg"] = error.description;
    }

    onLoadingChanged: {
        if (loadRequest.status === WebEngineLoadRequest.LoadSucceededStatus) {
            console.log('{WebPlayer} load succeeded');
            if (isPlaying) {
                isShown = true;
                runJavaScript("window.signage.isVisible_=true");
                sendEvent('show');
            }
        } else if (loadRequest.status === WebEngineLoadRequest.LoadFailedStatus) {
            console.log('{WebPlayer} load failed');
            // load backofftimer
            error["msg"] = "url load failed";
        }
    }

    onContextMenuRequested: {
        request.accepted = true;
    }

    onHeightChanged: {
        runJavaScript("if (window.signage) window.signage.height_=" + height);
    }

    onWidthChanged: {
        runJavaScript("if (window.signage) window.signage.width_=" + width);
    }

    function sendEvent(eventName) {
        runJavaScript("
            var event = document.createEvent('HTMLEvents');
            event.initEvent('" + eventName + "', true, false);
            document.dispatchEvent(event);
        ");
    }

    function prepare(uri) {
        console.log("{WebPlayer} prepare", uri);
        url = uri;
    }

    function play() {
        console.log("{WebPlayer} play");
        opacity = 1.0
        isPlaying = true;
        if (!isShown) {
            isShown = true;
            runJavaScript("window.signage.isVisible_=true");
            sendEvent('show');
        }
    }

    function stop() {
        console.log("{WebPlayer} stop");
        opacity = 0.0;
        isPlaying = false;
        runJavaScript("window.signage.isVisible_=false");
    }
}
