import '../../utilities/data_cleaner.dart';

class Patient {
  final String name;
  final String age;
  final String gender;
  final String city;
  final String state;
  final String nameOfDoctor;
  final String provisionalDiagnosis;
  final String queryRemark;
  final String observation;

  Patient.fromJson(Map<String, dynamic> decodedJson)
      : name = cleanOrConvert(decodedJson["patient_name"]),
        age = cleanOrConvert(decodedJson["patient_age"]),
        gender = cleanOrConvert(decodedJson["patient_gender"]),
        city = cleanOrConvert(decodedJson["patient_city"]),
        state = cleanOrConvert(decodedJson["patient_state"]),
        nameOfDoctor = cleanOrConvert(decodedJson["name_dr"]),
        provisionalDiagnosis =
            cleanOrConvert(decodedJson["provisional_dignosis"]),
        queryRemark = cleanOrConvert(decodedJson["query_remark"]),
        observation = cleanOrConvert(decodedJson["Observation"]);

  Map<String, dynamic> toMap() {
    return <String, String> {
      'Name': name,
      'Age': age,
      'Gender': gender,
      'City': city,
      'State': state,
      'Name of doctor': nameOfDoctor,
      'Provisional diagnosis': provisionalDiagnosis,
      'Query remark': queryRemark,
      'Observation': observation,
    };
  }
}

class InsuredPerson {
  final String insuredName;
  final String insuredContactNumber;
  final String relationWithPatient;

  InsuredPerson.fromJson(Map<String, dynamic> decodedJson)
      : insuredName = cleanOrConvert(decodedJson["insured_name"]),
        insuredContactNumber =
            cleanOrConvert(decodedJson["Insured_Contact_Number"]),
        relationWithPatient =
            cleanOrConvert(decodedJson["relation_with_patient"]);

  Map<String, dynamic> toMap() {
    return <String, String> {
      'Insured name': insuredName,
      'Insured contact number': insuredContactNumber,
      'Relation with patient': relationWithPatient,
    };
  }
}
