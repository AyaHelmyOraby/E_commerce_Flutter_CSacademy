abstract class RegisterStates {}

class RegisterInitial extends RegisterStates {}

class RegisterLoading extends RegisterStates {}

class RegisterSuccess extends RegisterStates {}

class RegisterFailure extends RegisterStates {
  final String error;
  RegisterFailure(this.error);
}
