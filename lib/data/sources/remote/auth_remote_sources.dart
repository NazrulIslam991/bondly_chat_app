import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/network/api_clients.dart';
import '../../../core/network/api_end_points.dart';
import '../../../core/network/response_model.dart';
import '../../../core/resources/constant/color_manager.dart';
import '../../../core/resources/utils/utils.dart';
import '../shares_preference/shared_preference.dart';

class AuthRemoteServices {
  final ApiClient apiClient;
  AuthRemoteServices({required this.apiClient});

  SharedPreferenceData sharedPreferenceData = SharedPreferenceData();

  ///************************  sign up remote source *******************************
  Future<ResponseModel> signUp({
    required String name,
    required String email,
    required String password,
    required XFile profile,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'name': name,
        'email': email,
        'password': password,
        'avatar': await MultipartFile.fromFile(
          profile.path,
          filename: profile.name,
        ),
      });

      final response = await apiClient.postRequest(
        endpoints: ApiEndpoints.signUp,
        formData: formData,
      );
      if (response['success'] == true) {
        Utils.showToast(
          message: response['message'],
          backgroundColor: ColorManager.purpleShade,
          textColor: ColorManager.white,
        );
        return ResponseModel(isSuccess: true, message: response['message']);
      } else {
        return ResponseModel(isSuccess: false, message: response['message']);
      }
    } catch (e) {
      return ResponseModel(isSuccess: false, message: e.toString());
    }
  }

  ///****************************** couch login ****************************
  Future<ResponseModel> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final body = {"email": email, "password": password};
      final response = await apiClient.postRequest(
        endpoints: ApiEndpoints.login,
        body: body,
      );
      final String? accessToken = response["authorization"]["access_token"];
      final String? refreshToken = response["authorization"]["refresh_token"];
      final String? role = response["type"];
      if (accessToken != null && refreshToken != null) {
        await SharedPreferenceData.setToken(accessToken);
        await SharedPreferenceData.setRefreshToken(refreshToken);
        await sharedPreferenceData.setRole(role);
        ApiClient.headerSet(accessToken);
      }
      if (response['success'] == true) {
        Utils.showToast(
          message: response['message'],
          backgroundColor: ColorManager.purpleShade,
          textColor: ColorManager.white,
        );
        return ResponseModel(
          isSuccess: true,
          message: response['message'],
          data: response,
        );
      } else {
        return ResponseModel(isSuccess: false, message: response['message']);
      }
    } catch (e) {
      return ResponseModel(isSuccess: false, message: e.toString());
    }
  }

  /// ************************* refresh token section ****************************
  Future<ResponseModel> reFreshToken({required String refreshToken}) async {
    try {
      final body = {"refreshToken": refreshToken};
      final response = await apiClient.postRequest(
        endpoints: ApiEndpoints.refreshToken,
        body: body,
      );
      if (response['success'] == true) {
        return ResponseModel(isSuccess: true, message: response['message']);
      } else {
        return ResponseModel(isSuccess: false, message: response['message']);
      }
    } catch (e) {
      return ResponseModel(isSuccess: false, message: e.toString());
    }
  }
}
