abstract class ClinicLoginState {}

class ClinicLoginInitialState extends ClinicLoginState {}

class ClinicLoginLodingState extends ClinicLoginState {}

class ClinicLoginSuccesState extends ClinicLoginState {
  final String uId;
  final String type;

  ClinicLoginSuccesState(this.uId,this.type);
}

class ClinicLoginErrorState extends ClinicLoginState {
  final String error;
  ClinicLoginErrorState(this.error);
}

class ClinicChangeIconSuffixState extends ClinicLoginState {}
