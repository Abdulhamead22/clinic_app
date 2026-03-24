abstract class ClinicState {}

class ClinicInitialState extends ClinicState {}

class ClinicChangeNagBarState extends ClinicState {}

class ClinicGetPatientDataLoadingState extends ClinicState {}

class ClinicGetPatientDataSuccessState extends ClinicState {}

class ClinicGetPatientDataErrorState extends ClinicState {}

class ClinicChangeSelectedDoctorState extends ClinicState{}

class ClinicChangeDateState extends ClinicState{}

class ClinicChangeTimeState extends ClinicState{}

class ClinicAddAppointmentsLoadingState extends ClinicState {}

class ClinicAddAppointmentsSuccessState extends ClinicState {}

class ClinicAddAppointmentsErrorState extends ClinicState {}

class ClinicGetAppointmentsPatientLoadingState extends ClinicState {}

class ClinicGetAppointmentsPatientSuccessState extends ClinicState {}

class ClinicGetAppointmentsPatientErrorState extends ClinicState {}

class ClinicGetDoctorDataLoadingState extends ClinicState {}

class ClinicGetDoctorDataSuccessState extends ClinicState {}

class ClinicGetDoctorDataErrorState extends ClinicState {}


class ClinicUpdateStatusSuccessState extends ClinicState {}

class ClinicUpdateStatusErrorState extends ClinicState {}

class ClinicCheckAppointmentsLoadingState extends ClinicState {}

class ClinicCheckAppointmentsSuccessState extends ClinicState {}

class ClinicCheckAppointmentsErrorState extends ClinicState {}

class ClinicCancelAppointmentsLoadingState extends ClinicState {}

class ClinicCancelAppointmentsSuccessState extends ClinicState {}

class ClinicCancelAppointmentsErrorState extends ClinicState {}

class ClinicChangeDoctorFilterState extends ClinicState{}
