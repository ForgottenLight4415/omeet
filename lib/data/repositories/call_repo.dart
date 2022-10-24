import '../providers/call_provider.dart';

class CallRepository {
  final CallProvider _callProvider = CallProvider();

  Future<bool> callClient(
          {required String managerNumber,
          required String phoneNumber,
          required String claimNumber}) =>
      _callProvider.callClient(
        managerPhoneNumber: managerNumber,
        phoneNumber: phoneNumber,
        claimNumber: claimNumber,
      );

  Future<bool> sendMessage(
          {required String claimNumber, required String phoneNumber}) =>
      _callProvider.sendMessage(
        claimNumber: claimNumber,
        phoneNumber: phoneNumber,
      );
}
