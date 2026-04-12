import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/cubit/clinic_cubit.dart';
import 'package:flutter_application_1/modules/doctor/doctor_screen.dart';
import 'package:flutter_application_1/modules/login/cubit_login/login_cubit.dart';
import 'package:flutter_application_1/modules/login/cubit_login/login_state.dart';
import 'package:flutter_application_1/modules/patient/patient_screen.dart';
import 'package:flutter_application_1/modules/register/register_screen.dart';
import 'package:flutter_application_1/shared/widget.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key, required this.userType});
  String userType;

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    var formkey = GlobalKey<FormState>();
    final FocusNode emailfocusNode = FocusNode();
    final FocusNode passwordfocusNode = FocusNode();
    return BlocProvider(
      create: (context) => ClinicLoginCubit(),
      child: BlocConsumer<ClinicLoginCubit, ClinicLoginState>(
        listener: (context, state) {
          if (state is ClinicLoginErrorState) {
            toast(state.error, Colors.red);
          }
          if (state is ClinicLoginSuccesState) {
            if (userType != state.type) {
              toast('The Account is not $userType', Colors.red);
              FirebaseAuth.instance.signOut();
              //عملتها عشان لو الشرط صح مباشرة يقف وما يكمل الي بعدها
              return;
            }
            Widget? screen;
            if (state.type == "patient") {
              screen= const PatientScreen();
            } else if (state.type == "doctor") {
              screen= const DoctorScreen();
            } else {
              toast('The Account is UnKnow', Colors.red);
            }
            ClinicCubit.get(context).getAppointmentsData();
            navigatFinish(context, screen);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "LOGIN",
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(color: Colors.black),
                        ),
                        Text(
                          "Login now",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        textField(
                          controller: emailController,
                          input: "Email",
                          icon: const Icon(Icons.email_outlined),
                          validate: (value) {
                            if (value == '') {
                              return "must have email";
                            }
                            return null;
                          },
                          focusNode: emailfocusNode,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        textField(
                          controller: passwordController,
                          input: "Password",
                          icon: const Icon(Icons.lock_outline),
                          validate: (value) {
                            if (value == '') {
                              return "password is short";
                            }
                            return null;
                          },
                          // onsubmit: (value) {
                          //   //عملتها هنا كمان عشان لما اضغط ينتقل مباشرة للي بعدها
                          //   if (formkey.currentState!.validate()) {
                          //     ClinicLoginCubit.get(context).userLogin(
                          //         email: emailController.text,
                          //         password: passwordController.text,
                          //         type:
                          //         );
                          //   }
                          // },
                          keytype: TextInputType.visiblePassword,
                          isPassword: ClinicLoginCubit.get(context).isPassword,
                          suffixIcons: IconButton(
                            onPressed:
                                ClinicLoginCubit.get(context).changeSuffixIcon,
                            icon: ClinicLoginCubit.get(context).suffixIcon,
                          ),
                          focusNode: passwordfocusNode,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ConditionalBuilder(
                          condition: state is! ClinicLoginLodingState,
                          builder: (context) {
                            return defaultButton(
                              function: () {
                                if (formkey.currentState!.validate()) {
                                  ClinicLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              text: "Login",
                              isuper: true,
                            );
                          },
                          fallback: (context) =>
                            loading()
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (userType == 'patient')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have account? "),
                              defaultTextButton(
                                function: () {
                                  navigatTo(context, const RegisterScreen());
                                },
                                text: "Register",
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
