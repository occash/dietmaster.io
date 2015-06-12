import QtQuick 2.3

import "js/facts.js" as Facts

QtObject {
    id: user

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

    //Social info
    property url photo: "photo-default.png"
    property url backgroundImage: ""
    property color backgroundColor: "#607d8b"

    function today() {
        return new Date()
    }

    function fromEds(date) {
        return Date.fromLocaleString(Qt.locale(), date, "yyyy-MM-ddThh:mm:ss.zzzZ")
    }

    function toEds(date) {
        return Qt.formatDate(date, "yyyy-MM-ddThh:mm:ss.zzzZ")
    }

    function update(info) {
        email = info.email
        username = info.username
        firstname = info.firstName
        lastname = info.lastName

        gender = info.gender
        birthdate = fromEds(info.birthdate)
        height = info.height
        weight = info.weight
        lifestyle = info.lifestyle
        diabetic = info.diabetic

        abdomen = info.abdomen
        neck = info.neck
        hip = info.hip
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

    property QtObject nutrition: QtObject {
        property real calories: Facts.bmr(user) * Facts.lifestyleCoef(user)
        property real protein: user.weight * (1 - Facts.bfp(user) / 100.0) * 5
        property real fat: user.weight * 3
        property real carbohydrate: user.weight * (1 - Facts.bfp(user) / 100.0)
    }
}

