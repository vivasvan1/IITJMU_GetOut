
import 'package:cloud_firestore/cloud_firestore.dart';

class InOutEntry {
  DocumentReference id;
  bool approved = false;
  String purpose = "";
  String phoneNumber = "";
  DateTime outTime;
  DateTime inTime;

  InOutEntry({
    this.id,
    this.approved,
    this.purpose,
    this.phoneNumber,
    this.outTime,
    this.inTime,
  });

  InOutEntry.fromMap(Map<String, dynamic> data, DocumentReference id)
      : this(
          id: id,
          approved : data['approved'],
          purpose: data['purpose'],
          phoneNumber: data['phone'],
          outTime: DateTime.parse(data['out_datetime']),
          inTime: DateTime.parse(data['in_datetime']),
        );
}