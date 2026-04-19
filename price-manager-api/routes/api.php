<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\PurchaseController;
use App\Http\Controllers\Api\ProductController;

Route::prefix('v1')->group(function () {
    Route::post('/auth/register', [AuthController::class, 'register']);
    Route::post('/auth/login', [AuthController::class, 'login']);

    Route::middleware('auth:sanctum')->group(function () {
        Route::get('/auth/me', [AuthController::class, 'me']);
        Route::post('/auth/logout', [AuthController::class, 'logout']);

        Route::get('/purchases', [PurchaseController::class, 'index']);
        Route::post('/purchases', [PurchaseController::class, 'store']);
        Route::get('/purchases/{id}', [PurchaseController::class, 'show']);
        Route::put('/purchases/{id}', [PurchaseController::class, 'update']);
        Route::delete('/purchases/{id}', [PurchaseController::class, 'destroy']);

        Route::get('/products', [ProductController::class, 'index']);
        Route::get('/products/barcode/{barcode}', [ProductController::class, 'byBarcode']);
        Route::get('/products/{id}', [ProductController::class, 'show']);
    });
});