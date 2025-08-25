import 'package:equatable/equatable.dart';

const dialList123 = <DialDataModel>[
  DialDataModel(dialNo: "1", dialText: ""),
  DialDataModel(dialNo: "2", dialText: "ABC"),
  DialDataModel(dialNo: "3", dialText: "DEF"),
];

const dialList456 = [
  DialDataModel(dialNo: "4", dialText: "GHI"),
  DialDataModel(dialNo: "5", dialText: "JKL"),
  DialDataModel(dialNo: "6", dialText: "MNO"),
];

const dialList789 = [
  DialDataModel(dialNo: "7", dialText: "PQRS"),
  DialDataModel(dialNo: "8", dialText: "TUV"),
  DialDataModel(dialNo: "9", dialText: "WXYZ"),
];

const dialListSpecialAnd0 = [
  DialDataModel(dialNo: "*", dialText: ""),
  DialDataModel(dialNo: "0", dialText: ""),
  DialDataModel(dialNo: "#", dialText: ""),
];

class DialDataModel extends Equatable {
  final String dialNo;
  final String dialText;

  const DialDataModel({required this.dialNo, required this.dialText});

  @override
  List<Object?> get props => [dialNo, dialText];
}
