<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Purchase;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class PurchaseController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $purchases = Purchase::where('user_id', $request->user()->id)
            ->orderBy('purchase_date', 'desc')
            ->get();

        return response()->json(['purchases' => $purchases]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'product_barcode' => 'required|string|max:255',
            'price' => 'required|numeric|min:0',
            'store' => 'required|string|max:255',
            'purchase_date' => 'required|date',
            'receipt_photo_url' => 'nullable|string',
        ]);

        $purchase = Purchase::create([
            ...$validated,
            'user_id' => $request->user()->id,
        ]);

        return response()->json(['purchase' => $purchase], 201);
    }

    public function show(Request $request, int $id): JsonResponse
    {
        $purchase = Purchase::where('user_id', $request->user()->id)
            ->findOrFail($id);

        return response()->json(['purchase' => $purchase]);
    }

    public function update(Request $request, int $id): JsonResponse
    {
        $purchase = Purchase::where('user_id', $request->user()->id)
            ->findOrFail($id);

        $validated = $request->validate([
            'product_barcode' => 'sometimes|string|max:255',
            'price' => 'sometimes|numeric|min:0',
            'store' => 'sometimes|string|max:255',
            'purchase_date' => 'sometimes|date',
            'receipt_photo_url' => 'nullable|string',
        ]);

        $purchase->update($validated);

        return response()->json(['purchase' => $purchase]);
    }

    public function destroy(Request $request, int $id): JsonResponse
    {
        $purchase = Purchase::where('user_id', $request->user()->id)
            ->findOrFail($id);

        $purchase->delete();

        return response()->json(['message' => 'Purchase deleted']);
    }
}