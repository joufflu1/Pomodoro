#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QWindow>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));


    /*QQmlComponent component(&engine,QUrl::fromLocalFile("qrc:/main.qml"));
    QObject *object = component.create();
    QWindow *window = object->findChild<QWindow*>("applicationWindow1");*/

    return app.exec();
}
