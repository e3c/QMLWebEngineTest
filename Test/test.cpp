#include "test.h"
#include <QDebug>
#include <QDateTime>

Test::Test(QQmlApplicationEngine* engine) : QObject(NULL), engine_(engine), window_(qobject_cast<QQuickWindow*>(engine_->rootObjects().at(0)))

{
    timer_.setInterval(5000);
    connect(&timer_, &QTimer::timeout, this, &Test::gotTimeout);
    timer_.start();
}


void Test::gotTimeout() {
    window_->setProperty("timer", QDateTime::currentDateTime().toString());
}
