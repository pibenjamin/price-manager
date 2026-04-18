<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    protected $fillable = [
        'barcode',
        'name',
        'brand',
        'image_url',
        'category',
        'nutri_score',
        'energy_kcal',
        'fat',
        'saturated_fat',
        'carbohydrates',
        'sugars',
        'proteins',
        'salt',
        'fibers',
        'origins',
    ];

    protected $casts = [
        'energy_kcal' => 'decimal:2',
        'fat' => 'decimal:2',
        'saturated_fat' => 'decimal:2',
        'carbohydrates' => 'decimal:2',
        'sugars' => 'decimal:2',
        'proteins' => 'decimal:2',
        'salt' => 'decimal:2',
        'fibers' => 'decimal:2',
    ];
}