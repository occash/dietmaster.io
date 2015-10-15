#!/usr/bin/env python
# -*- coding: utf8 -*-

import math

# BMR adjustment
lifestyle_coef = {
    0: 1.2,
    1: 1.375,
    2: 1.4625,
    3: 1.550,
    4: 1.6375,
    5: 1.725,
    6: 1.9,
}

# Body mass index
# kg and m
def bmi(height, weight):
    height = height / 100
    return weight / (height * height)

# BMI compared to country average
def prime_bmi(bmi, average):
    return bmi / average

# Body fat percentage, U.S. Navy method
# cm
def bfp(gender, height, abdomen, neck, hip=0):
    if gender:
        return 86.010 * math.log(abdomen - neck) - 70.041 * math.log(height) + 30.30
    else:
        return 163.205 * math.log(abdomen + hip - neck) - 97.684 * math.log(height) - 104.912

# Basal Metabolic Rate, Harris-Benedict revised
# kg and cm
def bmr(gender, age, height, weight):
    if gender:
        return 88.362 + 13.397 * weight + 4.799 * height - 5.677 * age
    else:
        return 447.593 + 9.247 * weight + 3.098 * height - 4.330 * age