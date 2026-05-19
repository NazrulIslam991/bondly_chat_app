import 'package:image_picker/image_picker.dart';

import '../../core/network/response_model.dart';
import '../sources/remote/auth_remote_sources.dart';

class AuthRepository {
  final AuthRemoteServices remoteServices;
  AuthRepository({required this.remoteServices});

  /// ******************* signup *******************
  Future<ResponseModel> signUp({
    required String name,
    required String email,
    required String password,
    required XFile profile,
  }) async {
    return await remoteServices.signUp(
      name: name,
      email: email,
      password: password,
      profile: profile,
    );
  }

  /// ******************* login *******************
  Future<ResponseModel> logIn({
    required String email,
    required String password,
  }) async {
    return await remoteServices.logIn(email: email, password: password);
  }
}
