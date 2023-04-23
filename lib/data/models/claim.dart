import '../../utilities/data_cleaner.dart';

class Claim {
  final String id;
  final String hospitalId;
  final String claimId;
  
  Claim.fromJson(Map<String, dynamic> decodedJson)
    : id = cleanOrConvert(decodedJson["id"]),
  hospitalId = cleanOrConvert(decodedJson["Hos_ID"]),
  claimId = cleanOrConvert(decodedJson["Claim_ID"]);
}