import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'register_states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitial());

  final Dio dio = Dio();
  Future<void> register({
    required String username,
    required String password,
    required String email,
  }) async {
    emit(RegisterLoading());

    try {
      final res = await dio.post(
        'https://fakestoreapi.com/users',
        data: {
          "username": username,
          "password": password,
          "email": email,
        },
        options: Options(headers: {
          "Content-Type": "application/json",
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        emit(RegisterSuccess());
      } else {
        emit(RegisterFailure("Unexpected status: ${res.statusCode}"));
      }
    } catch (e) {
      emit(RegisterFailure("error : ${e.toString()}"));
    }
  }
}
