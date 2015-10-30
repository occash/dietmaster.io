#!/usr/bin/env python
# -*- coding: utf8 -*-

import math
import datetime

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
        return 86.010 * math.log(abdomen - neck, 10) - 70.041 * math.log(height, 10) + 36.76
    else:
        return 163.205 * math.log(abdomen + hip - neck, 10) - 97.684 * math.log(height, 10) - 78.387

# Basal Metabolic Rate, Harris-Benedict revised
# kg and cm
def bmr(gender, age, height, weight):
    if gender:
        return 88.362 + 13.397 * weight + 4.799 * height - 5.677 * age
    else:
        return 447.593 + 9.247 * weight + 3.098 * height - 4.330 * age

def calculate_index(user, body):
    user_age = datetime.datetime.utcnow() - user['birthdate']
    user_age = user_age.days / 365

    bmi_value = bmi(body['height'], body['weight'])
    bfp_value = 0.0
    if body.get('abdomen', None):
        bfp_value = bfp(user['gender'], body['height'], body['abdomen'], body['neck'], body['hip'])
        bfp_value = bfp_value if bfp_value > 0 else 0
    bmr_value = bmr(user['gender'], user_age, body['height'], body['weight'])
    
    base_value = body['weight'] * (1 - bfp_value / 100.0)

    energy = bmr_value * lifestyle_coef[user['lifestyle']]
    protein = base_value * 5 # Enought potein to gain muscles
    carbohydrate = base_value # Low-carbs diet
    lipid = (energy - protein * 4 - carbohydrate * 9) / 4 # Rest calories

    index = {
        'bmi': bmi_value,
        'bfp': bfp_value,
        'bmr': bmr_value,
    }

    nutrition = {
        'energy': energy,
        'protein': protein,
        'lipid': lipid,
        'carbohydrate': carbohydrate
    }

    return (index, nutrition)