// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lead_filter_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LeadFilterEnumAdapter extends TypeAdapter<LeadFilterEnum> {
  @override
  final int typeId = 2;

  @override
  LeadFilterEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LeadFilterEnum.searchLeads;
      case 1:
        return LeadFilterEnum.startDate;
      case 2:
        return LeadFilterEnum.endDate;
      case 3:
        return LeadFilterEnum.leadStatus;
      case 4:
        return LeadFilterEnum.leadSource;
      case 5:
        return LeadFilterEnum.cityId;
      case 6:
        return LeadFilterEnum.productId;
      case 7:
        return LeadFilterEnum.productPriceLessThan;
      case 8:
        return LeadFilterEnum.productPriceGreaterThan;
      case 9:
        return LeadFilterEnum.productPriceEqualTo;
      case 10:
        return LeadFilterEnum.communicationDate;
      case 11:
        return LeadFilterEnum.createdDate;
      case 12:
        return LeadFilterEnum.agentId;
      default:
        return LeadFilterEnum.searchLeads;
    }
  }

  @override
  void write(BinaryWriter writer, LeadFilterEnum obj) {
    switch (obj) {
      case LeadFilterEnum.searchLeads:
        writer.writeByte(0);
        break;
      case LeadFilterEnum.startDate:
        writer.writeByte(1);
        break;
      case LeadFilterEnum.endDate:
        writer.writeByte(2);
        break;
      case LeadFilterEnum.leadStatus:
        writer.writeByte(3);
        break;
      case LeadFilterEnum.leadSource:
        writer.writeByte(4);
        break;
      case LeadFilterEnum.cityId:
        writer.writeByte(5);
        break;
      case LeadFilterEnum.productId:
        writer.writeByte(6);
        break;
      case LeadFilterEnum.productPriceLessThan:
        writer.writeByte(7);
        break;
      case LeadFilterEnum.productPriceGreaterThan:
        writer.writeByte(8);
        break;
      case LeadFilterEnum.productPriceEqualTo:
        writer.writeByte(9);
        break;
      case LeadFilterEnum.communicationDate:
        writer.writeByte(10);
        break;
      case LeadFilterEnum.createdDate:
        writer.writeByte(11);
        break;
      case LeadFilterEnum.agentId:
        writer.writeByte(12);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeadFilterEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
