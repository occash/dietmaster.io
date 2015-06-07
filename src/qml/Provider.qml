import QtQuick 2.3

import "js/providers.js" as Providers

Item {
    id: provider

    property string email: ""
    property string username: ""
    property string fullname: ""
    property string location: ""
    property bool gender: true
    property date birthdate: new Date()

    property color backgroundColor: "lightblue"
    property url backgroundPicture: ""
    property url userPhoto: ""

    signal success()
    signal error(string message)

    function request(provider, id) {
        switch (provider)
        {
        case Providers.Gravatar:
            gravatar.request(id)
            break
        case Providers.Twitter:
            twitter.request(id)
            break
        }
    }

    QtObject {
        id: gravatar

        function request(mail) {
            var request = new XMLHttpRequest();

            request.onreadystatechange = function() {
                if (request.readyState === XMLHttpRequest.DONE) {
                    var info = JSON.parse(request.responseText)

                    if (request.status == 200) {
                        var entry = info.entry[0]

                        email = mail
                        if (displayName in entry)
                            username = entry.displayName
                        if (name in entry)
                            fullname = entry.name.formatted
                        if (location in entry)
                            location = entry.currentLocation

                        userPhoto = entry.avatar
                        if (profileBackground in entry) {
                            backgroundColor = entry.profileBackground.color
                            backgroundPicture = entry.profileBackground.picture
                        }

                        provider.success()
                    } else
                        provider.error(info.error)
                }
            }

            var profile = "http://www.gravatar.com/" + Qt.md5(mail) + ".json"
            request.open('GET', profile, true);
            request.send('');
        }
    }

    QtObject {
        id: twitter

        property string consumerKey : "56jgFp0AjOhuaYh0csWLooAqs"
        property string consumerSecret : "ZOr3mjMYeLyLCudtDPaj7JehKpKBSqzEeFJL8MbS2wFaXxGZ7K"
        property string bearerToken : ""

        Component.onCompleted: {
            var authReq = new XMLHttpRequest;
            authReq.open("POST", "https://api.twitter.com/oauth2/token");
            authReq.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
            authReq.setRequestHeader("Authorization", "Basic " + Qt.btoa(consumerKey + ":" + consumerSecret));
            authReq.onreadystatechange = function() {
                if (authReq.readyState === XMLHttpRequest.DONE) {
                    var jsonResponse = JSON.parse(authReq.responseText);
                    if (jsonResponse.errors !== undefined)
                        console.log("Authentication error: " + jsonResponse.errors[0].message)
                    else {
                        bearerToken = jsonResponse.access_token;
                        console.log(bearerToken)
                    }
                }
            }
            authReq.send("grant_type=client_credentials");
        }

        function request(name) {
            var request = new XMLHttpRequest();

            request.onreadystatechange = function() {
                if (request.readyState === XMLHttpRequest.DONE) {
                    var entry = JSON.parse(request.responseText)

                    if (request.status == 200) {
                        email = ""
                        username = entry.screen_name
                        fullname = entry.name
                        location = entry.location

                        userPhoto = entry.profile_image_url_https
                        backgroundColor = "#" + entry.profile_background_color
                        backgroundPicture = entry.profile_background_image_url

                        provider.success()
                    } else
                        provider.error(info.error)
                }
            }

            var profile = "https://api.twitter.com/1.1/users/show.json?screen_name=" + name
            request.open('GET', profile, true);
            request.setRequestHeader("Authorization", "Bearer " + bearerToken);
            request.send('');
        }
    }
}
