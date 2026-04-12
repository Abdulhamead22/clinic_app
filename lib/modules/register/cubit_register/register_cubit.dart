import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/patient_user_model.dart';
import 'package:flutter_application_1/modules/register/cubit_register/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClinicRegisterCubit extends Cubit<ClinicRegisterState> {
  ClinicRegisterCubit() : super(ClinicRegisterInitialState());

  static ClinicRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister(
      {required String name,
      required String email,
      required String password,
      required String phone}) {
    emit(ClinicRegisterLodingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then(
      (value) {
        // print(value.user?.email);
        userCreate(
          name: name,
          email: email,
          phone: phone,
          uId: value.user!.uid,
        );
        // print('Succes register');
        //    emit(ClinicRegisterSuccesState());
      },
    ).catchError((error) {
      // print('Error: ${error.toString()}');
      emit(ClinicRegisterErrorState(error.toString()));
    });
  }

  void userCreate({
    required String name,
    required String email,
    required String phone,
    required String uId, //عملتوا عشان انا راح احط تحتوا الداتا
  }) {
    PatientUserModel model = PatientUserModel(
      email: email,
      name: name,
      phone: phone,
      patientId: uId,
      image:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXZsywhro6rOO-cOhf51b480ay_0kWJXVywQ&s',
      isEmailVerified: false,
      type: 'patient'
    );
    //   DoctorUserModel model = DoctorUserModel(
    //   email: email,
    //   name: name,
    //   phone: phone,
    //   doctorId: uId,
    //   image:
    //       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXZsywhro6rOO-cOhf51b480ay_0kWJXVywQ&s',
    //   type: 'doctor'
    // );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then(
      (value) {
        emit(ClinicCreateUserSuccesState());
      },
    ).catchError((error) {
      emit(ClinicCreateUserErrorState(error.toString()));
    });
  }

  Widget suffixIcon = const Icon(Icons.visibility_outlined);
  bool isPassword = true;

  void changeSuffixIcon() {
    isPassword = !isPassword;
    suffixIcon = isPassword
        ? const Icon(Icons.visibility_outlined)
        : const Icon(Icons.visibility_off_outlined);
    emit(ClinicRegisterChangeIconSuffixState());
  }
}
