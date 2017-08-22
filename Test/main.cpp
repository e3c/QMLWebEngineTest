#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWebEngine>

#include "test.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QtWebEngine::initialize();

    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    Test* test = new Test(&engine);


    return app.exec();
}
