import QtQuick 2.3

QtObject {
    id: gravatar

    property string email: ""
    property string username: ""

    property string __url: "http://www.gravatar.com/" + Qt.md5(email) + ".json"

    function request(url) {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4) {
                if (xhr.status == 200) {
                    var info = JSON.parse(xhr.responseText)
                    username = info.entry[0].displayName
                    console.log(JSON.stringify(info))
                } else {
                }
            }
        }
        xhr.open('GET', url, true);
        xhr.send('');
    }

    onEmailChanged: request(__url)
}

