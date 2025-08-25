// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leads_filter_request_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LeadsFilterRequestModelAdapter
    extends TypeAdapter<LeadsFilterRequestModel> {
  @override
  final int typeId = 1;

  @override
  LeadsFilterRequestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LeadsFilterRequestModel(
      leadFilterEnum: fields[0] as LeadFilterEnum,
      val: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LeadsFilterRequestModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.leadFilterEnum)
      ..writeByte(1)
      ..write(obj.val);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeadsFilterRequestModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
