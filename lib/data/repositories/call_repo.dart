import 'package:rc_clone/data/providers/call_provider.dart';

class CallRepository {
  final CallProvider _callProvider = CallProvider();

  Future<bool> callClient(
          {required String claimNumber,
          required String phoneNumber,
          required String customerName}) =>
      _callProvider.callClient(
        claimNumber: claimNumber,
        phoneNumber: phoneNumber,
        customerName: customerName,
      );

  Future<bool> sendMessage(
          {required String claimNumber, required String phoneNumber}) =>
      _callProvider.sendMessage(
        claimNumber: claimNumber,
        phoneNumber: phoneNumber,
      );
}
