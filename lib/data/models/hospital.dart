import 'package:omeet_motor/utilities/data_cleaner.dart';

class Hospital {
  final String id;
  final String name;
  final String address;
  final String nameOfAuthority;
  final String location;
  final String region;

  Hospital.fromJson(Map<String, dynamic > decodedJson) 
    : id = cleanOrConvert(decodedJson["hospital_id"]),
    name = cleanOrConvert(decodedJson["hospital_name"]),
    address = cleanOrConvert(decodedJson["hospital_address"]),
    nameOfAuthority = cleanOrConvert(decodedJson["name_of_hospital_authority"]),
    location = cleanOrConvert(decodedJson["location"]),
    region = cleanOrConvert(decodedJson["region"]);

  Map<String, String> toMap() {
    return <String, String> {
      'Hospital ID': id,
      'Name': name,
      'Address': address,
      'Name of Authority': nameOfAuthority,
      'Location': location,
      'Region': region
    };
  }
}