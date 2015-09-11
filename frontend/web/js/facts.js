var Facts = function() {

    return {
        //Determine age
        age: function(bdate) {
            var today = new Date()
            return today.getFullYear() - bdate.getFullYear()
        },

        //Body mass index
        //kg and m
        bmi: function(user) {
            var height = user.height / 100
            return user.weight / (height * height)
        },

        //BMI compared to country averae
        primeBmi: function(bmi, average) {
            return bmi / average
        },

        //Body fat percentage, U.S. Navy method
        //cm
        bfp: function(user) {
            if (user.gender == 'm')
                return 86.010 * Math.log(user.abdomen - user.neck) - 70.041 * Math.log(user.height) + 30.30
            else
                return 163.205 * Math.log(user.abdomen + user.hip - user.neck) - 97.684 * Math.log(user.height) - 104.912
        },

        //Basal Metabolic Rate, Harris-Benedict revised
        //kg and cm
        bmr: function(user) {
            var uage = 20//age(user.birthdate)
            if (user.gender)
                return 88.362 + 13.397 * user.weight + 4.799 * user.height - 5.677 * uage
            else
                return 447.593 + 9.247 * user.weight + 3.098 * user.height - 4.330 * uage
        },

        lifestyleCoef: function(user) {
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
        },
    }
}();
