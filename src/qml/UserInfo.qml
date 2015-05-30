import QtQuick 2.3

QtObject {
    id: userInfo

    //Basic info
    property string email: ""
    property string username: ""
    property string password: ""
    property string firstname: ""
    property string lastname: ""

    //Personal info
    property bool gender: true
    property date birthdate: new Date()
    property real height: 170
    property real weight: 80
    property int lifestyle: 0
    property bool diabetic: false

    //Extra info
    property real abdomen: 80
    property real neck: 50
    property real hip: 35

    property int age: 30
    property real fatpercent: 0.2

    function today() {
        return new Date()
    }

    function fromEds(date) {
        return Date.fromLocaleString(Qt.locale(), date, "yyyy-MM-ddThh:mm:ss.zzzZ")
    }

    function toEds(date) {
        var d = Qt.formatDate(date, "yyyy-MM-ddThh:mm:ss.zzzZ")
        console.log(d)
        return d
    }

    function update(info) {
        gender = info.gender
        birthdate = fromEds(info.birth)
        age = today().getFullYear() - birthdate.getFullYear()
        height = info.height
        weight = info.weight
        fatpercent = info.fatpercent
        lifestyle = info.lifestyle
        diabetic = info.diabetic
    }

    function create() {
        return {
            "username": username,
            "password": password,
            "email": email,
            "firstName": firstname,
            "lastName": lastname,
            "gender": gender,
            "birthdate": birthdate,
            "height": height,
            "weight": weight,
            "lifestyle": lifestyle,
            "diabetic": diabetic,
            "abdomen": abdomen,
            "neck": neck,
            "hip": hip
        }
    }
}

