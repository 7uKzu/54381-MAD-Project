import 'package:bloodconnect/core/network/api_client.dart';
import 'package:bloodconnect/models/request_model.dart';

class RequestService {
  Future<List<RequestModel>> getMyRequests() async {
    final resp = await ApiClient.I.get('/requests');
    final list = (resp.data as List).cast<Map<String, dynamic>>();
    return list.map(RequestModel.fromJson).toList();
  }

  Future<RequestModel> createRequest(
      {required String bloodGroup,
      required String urgency,
      String? notes}) async {
    final resp = await ApiClient.I.post('/requests',
        data: {'blood_group': bloodGroup, 'urgency': urgency, 'notes': notes});
    return RequestModel.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<RequestModel> updateRequest(int id,
      {String? status, String? notes}) async {
    final resp = await ApiClient.I
        .put('/requests/$id', data: {'status': status, 'notes': notes});
    return RequestModel.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<void> cancelRequest(int id) async {
    await ApiClient.I.delete('/requests/$id');
  }
}
