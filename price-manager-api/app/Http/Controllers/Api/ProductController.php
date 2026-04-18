<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $products = Product::whereHas('purchases', function ($query) use ($request) {
            $query->where('user_id', $request->user()->id);
        })->get();

        return response()->json(['products' => $products]);
    }

    public function show(Request $request, int $id): JsonResponse
    {
        $product = Product::whereHas('purchases', function ($query) use ($request) {
            $query->where('user_id', $request->user()->id);
        })->findOrFail($id);

        return response()->json(['product' => $product]);
    }

    public function byBarcode(Request $request, string $barcode): JsonResponse
    {
        $product = Product::where('barcode', $barcode)->first();

        if (!$product) {
            return response()->json(['message' => 'Product not found'], 404);
        }

        return response()->json(['product' => $product]);
    }
}