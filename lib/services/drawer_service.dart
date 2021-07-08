import 'dart:io';

import 'package:http_demo/models/uploaded_file.dart';
import 'package:http_demo/services/api_service.dart';

extension DrawerService on ApiService {
  Future uploadAvatar({
    required File file,
    required String token,
    required Function(String) onSuccess,
    required Function(String) onFailure,
  }) async {
    Map<String, String> headers = {
      "Authorization": "Bearer $token",
    };

    await apiService.request(
      path: "/api/upload",
      method: Method.post,
      headers: headers,
      file: file,
      onSuccess: (json) {
        UploadedFile file = UploadedFile.fromJson(json);
        onSuccess(file.path ?? "");
      },
      onFailure: (error) {
        print('uploadAvatar error');
      },
    );
  }
}
