import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/modules/login/cubit_login/login_state.dart';
import 'package:flutter_application_1/shared/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClinicLoginCubit extends Cubit<ClinicLoginState> {
  ClinicLoginCubit() : super(ClinicLoginInitialState());

  static ClinicLoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(ClinicLoginLodingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then(
      (value) {
        uId = value.user!.uid;
        
          
        FirebaseFirestore.instance.collection('users').doc(uId).get().then(
          (value1) {
            userType=value1.data()!['type'];
            CacheHelper.saveData(key: 'uId', value: value.user!.uid);
            CacheHelper.saveData(key: 'userType', value: userType);

            if (userType == "patient") {
              emit(ClinicLoginSuccesState(value.user!.uid, userType!));
          
            } 
        
          },
        );
      },
    ).catchError((error) {
      emit(ClinicLoginErrorState(error.toString()));
    });
  }

  // التعامل مع الأيقونة الخاصة بكلمة المرور
  Widget suffixIcon = const Icon(Icons.visibility_outlined);
  bool isPassword = true;

  void changeSuffixIcon() {
    isPassword = !isPassword;
    suffixIcon = isPassword
        ? const Icon(Icons.visibility_outlined)
        : const Icon(Icons.visibility_off_outlined);
    emit(ClinicChangeIconSuffixState()); // تغيير الحالة للأيقونة
  }
}
