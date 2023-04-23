import 'package:omeet_motor/utilities/data_cleaner.dart';

class Hospital {
  final String id;
  final String name;
  final String address;
  final String nameOfAuthority;
  final String location;
  final String region;

  Hospital.fromJson(Map<String, dynamic > decodedJson) 
    : id = cleanOrConvert(decodedJson["Hos_ID"]),
    name = cleanOrConvert(decodedJson["Hospital_Name"]),
    address = cleanOrConvert(decodedJson["Hospital_Address"]),
    nameOfAuthority = cleanOrConvert(decodedJson["Name_of_Hospital_Authority"]),
    location = cleanOrConvert(decodedJson["Location"]),
    region = cleanOrConvert(decodedJson["Region"]);

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