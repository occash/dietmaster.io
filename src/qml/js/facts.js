.pragma library

//Determine age
function age(bdate) {
    var today = new Date()
    return today.getFullYear() - bdate.getFullYear()
}

//Body mass index
//kg and m
function bmi(user) {
    var height = user.height / 100
    return user.weight / (height * height)
}

//BMI compared to country averae
function primeBmi(bmi, average) {
    return bmi / average
}

//Body fat percentage, U.S. Navy method
//cm
function bfp(user) {
    if (user.gender)
        return 86.010 * Math.log(user.abdomen - user.neck) - 70.041 * Math.log(user.height) + 30.30
    else
        return 163.205 * Math.log(user.abdomen + user.hip - user.neck) - 97.684 * Math.log(user.height) - 104.912
}

//Basal Metabolic Rate, Harris-Benedict revised
//kg and cm
function bmr(user) {
    var uage = age(user.birthdate)
    if (user.gender)
        return 88.362 + 13.397 * user.weight + 4.799 * user.height - 5.677 * uage
    else
        return 447.593 + 9.247 * user.weight + 3.098 * user.height - 4.330 * uage
}

//Error for confidence rate 95%
function caloryError(gender) {
    return gender ? 210.5 : 201.0
}

function lifestyleCoef(user) {
    switch (user.lifestyle)
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

function activityString(l) {
    switch (l)
    {
    case 0: return "No fitness"
    case 1: return "Fitness 3 times a week"
    case 2: return "Fitness 5 times a week"
    case 3: return "Intensive fitness 5 times a week"
    case 4: return "Fitness every day"
    case 5: return "Intensive fitness every day"
    case 6: return "Intensive fitness every day + physical work"
    }
}
