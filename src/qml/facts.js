.pragma library

//Body mass index
//kg and m
function bmi(weight, height) {
    return weight / (height * height)
}

//BMI compared to country averae
function primeBmi(bmi, average) {
    return bmi / average
}

//Body fat percentage, U.S. Navy method
//cm
function bfp(gender, height, abdomen, neck, hip) {
    if (gender)
        return 86.010 * Math.log(abdomen - neck) - 70.041 * Math.log(height) + 30.30
    else
        return 163.205 * Math.log(abdomen + hip - neck) - 97.684 * Math.log(height) - 104.912
}

//Basal Metabolic Rate, Harris-Benedict revised
//kg and cm
function bmr(gender, weight, height, age) {
    if (gender)
        return 88.362 + 13.397 * weight + 4.799 * height - 5.677 * age
    else
        return 447.593 + 9.247 * weight + 3.098 * height - 4.330 * age
}

//Recommended daily kilocalories
function dailyCalories(bmr, lifestyle) {
    return bmr * lifestyle
}

//Error for confidence rate 95%
function caloryError(gender) {
    return gender ? 210.5 : 201.0
}
