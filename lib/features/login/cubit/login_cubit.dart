import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit(Dio dio) : super(InitialState());

  final Dio dio = Dio();

  Future<void> login(
      {required String username, required String password}) async {
    emit(LoginLoadingState());
    try {
      final res = await dio.post(
        'https://fakestoreapi.com/auth/login',
        data: {
          "username": username,
          "password": password,
        },
        options: Options(headers: {
          "Content-Type": "application/json",
        }),
      );

      if (res.statusCode == 200) {
        emit(LoginSuccessState());
      } else {
        emit(LoginFailState("Invalid status code: ${res.statusCode}"));
      }
    } catch (e) {
      emit(LoginFailState(e.toString()));
    }
  }
}
