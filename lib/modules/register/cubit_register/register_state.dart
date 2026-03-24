abstract class ClinicRegisterState {}

class ClinicRegisterInitialState extends ClinicRegisterState {}

class ClinicRegisterLodingState extends ClinicRegisterState {}

class ClinicRegisterSuccesState extends ClinicRegisterState {}

class ClinicRegisterErrorState extends ClinicRegisterState {
  final String error;
  ClinicRegisterErrorState(this.error);
}

class ClinicCreateUserSuccesState extends ClinicRegisterState {}

class ClinicCreateUserErrorState extends ClinicRegisterState {
  final String error;
  ClinicCreateUserErrorState(this.error);
}

class ClinicRegisterChangeIconSuffixState extends ClinicRegisterState {}
