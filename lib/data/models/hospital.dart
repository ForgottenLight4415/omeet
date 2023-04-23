import 'package:omeet_motor/utilities/data_cleaner.dart';

class Hospital {
  final String name;
  final String address;
  final String city;
  final String state;
  final String roomCategory;

  Hospital.fromJson(Map<String, dynamic> decodedJson)
      : name = cleanOrConvert(decodedJson["hospital_name"]),
        address = cleanOrConvert(decodedJson["hospital_address"]),
        city = cleanOrConvert(decodedJson["hospital_city"]),
        state = cleanOrConvert(decodedJson["hospital_state"]),
        roomCategory = cleanOrConvert(decodedJson["room_category"]);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Name': name,
      'Address': address,
      'City': city,
      'State': state,
      'Room category': roomCategory,
    };
  }
}
