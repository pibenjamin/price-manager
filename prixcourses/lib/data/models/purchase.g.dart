// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PurchaseAdapter extends TypeAdapter<Purchase> {
  @override
  final int typeId = 1;

  @override
  Purchase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Purchase(
      id: fields[0] as String,
      productBarcode: fields[1] as String,
      price: fields[2] as double,
      store: fields[3] as String,
      purchaseDate: fields[4] as DateTime,
      receiptPhotoUrl: fields[5] as String?,
      createdAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Purchase obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productBarcode)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.store)
      ..writeByte(4)
      ..write(obj.purchaseDate)
      ..writeByte(5)
      ..write(obj.receiptPhotoUrl)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
