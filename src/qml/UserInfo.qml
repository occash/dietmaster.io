import QtQuick 2.3

QtObject {
    id: userInfo

    //property alias birthdate: d.birthdate
    property bool gender: true
    property int age: 30
    property real height: 170
    property real weight: 80
    property real fatpercent: 25
    property int lifestyle: 0

    function update(info) {
        d.birthdate = d.fromEds(info.birth)
        gender = info.gender
        age = d.today().getFullYear() - d.birthdate.getFullYear()
        height = info.height
        weight = info.weight
        fatpercent = info.fatpercent
        lifestyle = info.lifestyle
    }

    function query() {
        return {
            "gender": gender,
            "birthdate": d.birthdate,
            "height": height,
            "weight": weight,
            "fatpercent": fatpercent,
            "lifestyle": lifestyle
        }
    }

    //Private part
    property var d: QtObject {
        property date birthdate: new Date()

        function today() {
            return new Date()
        }

        function fromEds(date) {
            return Date.fromLocaleString(Qt.locale(), date, "yyyy-MM-ddThh:mm:ss.zzzZ")
        }
    }
}

