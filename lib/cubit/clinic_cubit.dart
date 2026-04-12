import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/cubit/clinic_state.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/appointment_models.dart';
import 'package:flutter_application_1/models/doctor_user_model.dart';
import 'package:flutter_application_1/models/patient_user_model.dart';
import 'package:flutter_application_1/modules/appointments/appointments_doctor_screen.dart';
import 'package:flutter_application_1/modules/appointments/appointments_patient_screen.dart';
import 'package:flutter_application_1/modules/settings/settings_screen.dart';
import 'package:flutter_application_1/role_selection_screen.dart';
import 'package:flutter_application_1/shared/cache_helper.dart';
import 'package:flutter_application_1/shared/widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClinicCubit extends Cubit<ClinicState> {
  ClinicCubit() : super(ClinicInitialState());

  static ClinicCubit get(context) => BlocProvider.of(context);
  AppointmentModels? appointmentModels;
  PatientUserModel? patientModel;
  DoctorUserModel? doctorModel;

  DoctorUserModel? selectedDocotrFilter;

  //دالة جلب بيانات المريض
  void getUserPatientData() {
    emit(ClinicGetPatientDataLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then(
      (value) {
        // getAllPatientsData();
        patientModel = PatientUserModel.fromJson(value.data());

        // print('Patient model: ${patientModel?.toMap()}');

        emit(ClinicGetPatientDataSuccessState());
      },
    ).catchError((error) {
      emit(ClinicGetPatientDataErrorState());
    });
  }

//دالة جلب كل بيانات الدكاترة
  Map<String, PatientUserModel> patient = {};
  List<PatientUserModel> patientList = [];

  void getAllPatientsData() {
    emit(ClinicGetAllPatientDataLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .where('type', isEqualTo: 'patient')
        .snapshots()
        .listen((value) {
      patient.clear();
      patientList.clear();

      for (var element in value.docs) {
        patient[element.id] = PatientUserModel.fromJson(element.data());
        patientList.add(patient[element.id]!);
      }

      emit(ClinicGetAllPatientDataSuccessState());
    }, onError: (error) {
      emit(ClinicGetAllPatientDataErrorState());
    });
  }

//   //دالة جلب بيانات الدكتور
  Future<void> getUserDoctorAllData() async {
    try {
      emit(ClinicGetDoctorDataLoadingState());

      getUserDoctorData();
      final value =
          await FirebaseFirestore.instance.collection('users').doc(uId).get();

      doctorModel = DoctorUserModel.fromJson(value.data()!);

      emit(ClinicGetDoctorDataSuccessState());
    } catch (error) {
      emit(ClinicGetDoctorDataErrorState());
    }
  }

//هنا استخدمنا map لانها اسرع وافضل
  Map<String, DoctorUserModel> doctors = {};
  List<DoctorUserModel> doctorsList = [];

  void getUserDoctorData() {
    emit(ClinicGetFilterDoctorDataLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .where('type', isEqualTo: 'doctor')
        .snapshots()
        .listen((value) {
      doctors.clear();
      doctorsList.clear();

      selectedDoctor = null;
      selectedTime = null;
      for (var element in value.docs) {
        doctors[element.id] = DoctorUserModel.fromJson(
          element.data(),
        );
        doctorsList.add(doctors[element.id]!);
      }

      emit(ClinicGetFilterDoctorDataSuccessState());
    }, onError: (error) {
      emit(ClinicGetFilterDoctorDataErrorState());
    });
  }

  int currentIndex = 0;
  List<Widget> pagePatient = [
    const AppointmentsPatientScreen(),
    const SettingsScreen(),
  ];

  List<Widget> pageDoctor = [
    const AppointmentsDoctorScreen(),
    const SettingsScreen(),
  ];
  List<String> title = [
    'Appointments',
    'Settings',
  ];
  //تغيير الصفحة
  changIndexNavBar(
    int index,
  ) {
    currentIndex = index;
    emit(ClinicChangeNagBarState());
  }

  //تغيير اسم الدكتور
  DoctorUserModel? selectedDoctor;
  changSelectedDoctor(
    DoctorUserModel selected,
  ) {
    selectedDoctor = selected;
    emit(ClinicChangeSelectedDoctorState());
  }

//تغيير التاريخ
  DateTime? selectedDate;
  changeDatePicker(DateTime date) {
    selectedDate = date;
    emit(ClinicChangeDateState());
  }

//تغيير الوقت
  TimeOfDay? selectedTime;
  changeTimePicker(TimeOfDay? time) {
    selectedTime = time;
    emit(ClinicChangeTimeState());
  }

  //اضافة موعد
  void addAppointmentsPatient({
    required String time,
    required String date,
  }) {
    emit(ClinicAddAppointmentsLoadingState());

    var dataId = FirebaseFirestore.instance.collection('appointments').doc();
    appointmentModels = AppointmentModels(
      date: date,
      time: time,
      status: 'upcoming',
      patientId: patientModel!.patientId,
      appointmentId: dataId.id,
      doctorId: selectedDoctor!.doctorId,
    );

    // print('Saving appointment: ${appointmentModels!.toMap()}');

    dataId.set(appointmentModels!.toMap()).then(
      (value) {
        emit(ClinicAddAppointmentsSuccessState());
      },
    ).catchError((error) {
      emit(ClinicAddAppointmentsErrorState());
    });
  }

  List<AppointmentModels> appoin = [];
  //جلب المواعيد
  void getAppointmentsData() {
    emit(ClinicGetAppointmentsPatientLoadingState());
    FirebaseFirestore.instance
        .collection('appointments')
        .orderBy("date")
        .snapshots()
        .listen(
      (value) {
        //  print(value.data());
        appoin = [];
        value.docs.forEach(
          (element) {
            appoin.add(AppointmentModels.fromJson(element.data()));
          },
        );
        emit(ClinicGetAppointmentsPatientSuccessState());
      },
    );
  }

//تسجيل الخروج
  void signOut(context) async {
    await FirebaseAuth.instance.signOut(); // 🔥 أهم سطر

    CacheHelper.clearData(key: 'uId');
    CacheHelper.clearData(key: 'userType');
    appoin = [];
    emit(ClinicInitialState());
    navigatFinish(context, const RoleSelectionScreen());
  }

//تحديث الحالة
  void updateStatusAppointment(String appointmentId, String status) {
    FirebaseFirestore.instance
        .collection('appointments')
        .doc(appointmentId)
        .update({'status': status}).then(
      (value) {
        emit(ClinicUpdateStatusSuccessState());
        getAppointmentsData();
      },
    ).catchError((error) {
      ('Upadate Error ');
      emit(ClinicUpdateStatusErrorState());
    });
  }

  //منع تكرار حجز بنفس الموعد
  void checkAndAddAppointment({
    required String doctorId,
    required String date,
    required String time,
  }) async {
    emit(ClinicCheckAppointmentsLoadingState());

    final snapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('date', isEqualTo: date)
        .where('time', isEqualTo: time)
        .get();

    if (snapshot.docs.isNotEmpty) {
      toast("This Time is already selected", Colors.red);
      emit(ClinicCheckAppointmentsErrorState());
    } else {
      // الوقت متاح → أضف الموعد
      addAppointmentsPatient(date: date, time: time);

      emit(ClinicCheckAppointmentsSuccessState());
    }
  }

  //حذف موعد
  // void updateAppointmentsPatient(String id) {
  //   emit(ClinicDeleteAppointmentsLoadingState());

  //   var dataId = FirebaseFirestore.instance.collection('appointments').doc(id);

  // dataId.update({'status':"cancel"}).then(
  //     (value) {
  //       emit(ClinicDeleteAppointmentsSuccessState());
  //       print('Success Delete');
  //     },
  //   ).catchError((error) {
  //     emit(ClinicDeleteAppointmentsErrorState());
  //   });
  // }

//تغيير الدكتور حسب الفلترة
  void changeFilterDoctor(selectedFilter) {
    selectedDocotrFilter = selectedFilter;
    emit(ClinicChangeDoctorFilterState());
  }

  //تغيير الاسم
  void changeName(String name) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId!)
        .update({'name': name});

    if (doctorModel != null) {
      doctorModel!.name = name;
    }

    if (patientModel != null) {
      patientModel!.name = name;
    }

    emit(ClinicChangeNameState());
  }

  bool isDark = false;

  void changeTheme() {
    isDark = !isDark;
    CacheHelper.saveData(key: 'isDark', value: isDark);
    emit(ClinicChangeThemeState());
  }
}
