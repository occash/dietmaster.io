import QtQuick 2.3

QtObject {
    id: gravatar

    property string email: ""
    property string username: ""
    property string name: ""
    property string surname: ""
    property color profileColor: "lightblue"
    property string location: ""

    property url profileUrl: "http://www.gravatar.com/" + Qt.md5(email) + ".json"
    property url photo: "http://www.gravatar.com/" + Qt.md5(email)

    signal found()

    function request(mail) {
        var url = "http://www.gravatar.com/" + Qt.md5(mail) + ".json"
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4) {
                if (xhr.status == 200) {
                    var info = JSON.parse(xhr.responseText)

                    email = mail
                    username = info.entry[0].displayName
                    name = info.entry[0].name.givenName
                    surname = info.entry[0].name.familyName
                    profileColor = info.entry[0].profileBackground.color
                    location = info.entry[0].currentLocation

                    found()
                }
            }
        }
        xhr.open('GET', url, true);
        xhr.send('');
    }
}
