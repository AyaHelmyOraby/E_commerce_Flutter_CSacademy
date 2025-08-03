abstract class LoginStates {}

class InitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {}

class LoginFailState extends LoginStates {
  final String error;
  LoginFailState(this.error);
}
