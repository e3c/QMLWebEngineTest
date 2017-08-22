#ifndef TEST_H
#define TEST_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QTimer>

class Test : public QObject
{
    Q_OBJECT
public:
    explicit Test(QQmlApplicationEngine *engine);

signals:

public slots:
    void gotTimeout();

private:
    QQmlApplicationEngine* engine_;
    QQuickWindow* window_;
    QTimer timer_;
};

#endif // TEST_H
