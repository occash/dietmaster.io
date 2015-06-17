.pragma library

function capitalizeFirst(str) {
    return str.charAt(0).toUpperCase() + str.slice(1);
}

function today() {
    return new Date()
}

function fromEds(date) {
    return Date.fromLocaleString(Qt.locale(), date, "yyyy-MM-ddThh:mm:ss.zzzZ")
}

function toEds(date) {
    return Qt.formatDateTime(date, "yyyy-MM-ddThh:mm:ss.zzzZ")
}
