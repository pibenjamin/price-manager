// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 0;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      barcode: fields[0] as String,
      name: fields[1] as String,
      brand: fields[2] as String?,
      imageUrl: fields[3] as String?,
      category: fields[4] as String?,
      nutriScore: fields[5] as String?,
      createdAt: fields[6] as DateTime?,
      energyKcal: fields[7] as double?,
      fat: fields[8] as double?,
      saturatedFat: fields[9] as double?,
      carbohydrates: fields[10] as double?,
      sugars: fields[11] as double?,
      proteins: fields[12] as double?,
      salt: fields[13] as double?,
      fibers: fields[14] as double?,
      origins: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.barcode)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.brand)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.nutriScore)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.energyKcal)
      ..writeByte(8)
      ..write(obj.fat)
      ..writeByte(9)
      ..write(obj.saturatedFat)
      ..writeByte(10)
      ..write(obj.carbohydrates)
      ..writeByte(11)
      ..write(obj.sugars)
      ..writeByte(12)
      ..write(obj.proteins)
      ..writeByte(13)
      ..write(obj.salt)
      ..writeByte(14)
      ..write(obj.fibers)
      ..writeByte(15)
      ..write(obj.origins);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
