import QtQuick 2.0

QtObject {
    id: optimal

    property UserInfo user: null

    property real calories: harrisBenedict(user.gender, user.age,
                                           user.weight, user.height) *
                            lifestyleCoef(user.lifestyle)
    property real protein: user.weight * (1 - user.fatpercent / 100.0) * 5
    property real fat: user.weight * 3
    property real carbohydrate: user.weight * (1 - user.fatpercent / 100.0)

    function lifestyleCoef(l) {
        switch (l)
        {
        case 0: return 1.2
        case 1: return 1.375
        case 2: return 1.4625
        case 3: return 1.550
        case 4: return 1.6375
        case 5: return 1.725
        case 6: return 1.9
        }
    }

    function harrisBenedict(g, a, w, h) {
        var fc = g ? 66.5 : 655.1
        var wc = g ? 13.75 : 9.563
        var hc = g ? 5.003 : 1.85
        var ac = g ? 6.775 : 4.676

        return fc + (wc * w) + (hc * h) - (ac * a)
    }
}

