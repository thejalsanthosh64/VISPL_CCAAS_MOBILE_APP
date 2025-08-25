import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class DeviceContactListModel extends Equatable {
  final String tag;

  final List<DeviceContactDisplayDetails> contactDisplayDetails;

  const DeviceContactListModel({
    required this.tag,
    required this.contactDisplayDetails,
  });

  DeviceContactListModel copyWidth({
    String? tag,
    List<DeviceContactDisplayDetails>? contactDisplayDetails,
  }) {
    return DeviceContactListModel(
      tag: tag ?? this.tag,
      contactDisplayDetails: contactDisplayDetails ?? this.contactDisplayDetails,
    );
  }

  @override
  List<Object?> get props => [contactDisplayDetails, tag];
}

class DeviceContactDisplayDetails extends Equatable {
  final Uint8List? thumbnail;

  final String? displayName;

  final String number;

  final String id;

  const DeviceContactDisplayDetails({
    this.thumbnail,
    required this.number,
    required this.id,
    this.displayName,
  });

  @override
  List<Object?> get props => [thumbnail.hashCode, number, displayName,id];
}
