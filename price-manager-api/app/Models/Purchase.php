<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Purchase extends Model
{
    protected $fillable = [
        'user_id',
        'product_barcode',
        'price',
        'store',
        'purchase_date',
        'receipt_photo_url',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'purchase_date' => 'datetime',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}