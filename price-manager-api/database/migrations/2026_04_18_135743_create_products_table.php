<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('products', function (Blueprint $table) {
            $table->id();
            $table->string('barcode')->unique()->index();
            $table->string('name');
            $table->string('brand')->nullable();
            $table->string('image_url')->nullable();
            $table->string('category')->nullable();
            $table->string('nutri_score')->nullable();
            $table->decimal('energy_kcal', 10, 2)->nullable();
            $table->decimal('fat', 10, 2)->nullable();
            $table->decimal('saturated_fat', 10, 2)->nullable();
            $table->decimal('carbohydrates', 10, 2)->nullable();
            $table->decimal('sugars', 10, 2)->nullable();
            $table->decimal('proteins', 10, 2)->nullable();
            $table->decimal('salt', 10, 2)->nullable();
            $table->decimal('fibers', 10, 2)->nullable();
            $table->text('origins')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('products');
    }
};
