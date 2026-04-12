import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/modules/login/login_screen.dart';
import 'package:flutter_application_1/modules/register/cubit_register/register_cubit.dart';
import 'package:flutter_application_1/modules/register/cubit_register/register_state.dart';
import 'package:flutter_application_1/shared/widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    var formkey = GlobalKey<FormState>();
    final FocusNode emailfocusNode = FocusNode();
    final FocusNode namefocusNode = FocusNode();
    final FocusNode passwordfocusNode = FocusNode();
    final FocusNode phonefocusNode = FocusNode();

    return BlocProvider(
      create: (context) => ClinicRegisterCubit(),
      child: BlocConsumer<ClinicRegisterCubit, ClinicRegisterState>(
        listener: (context, state) {
          if (state is ClinicCreateUserSuccesState) {
            //  navigatFinish(context, const ClinicLayout());
          } else {}
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
                          "Register",
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(color: Colors.black),
                        ),
                        Text(
                          "Register now ",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        textField(
                          controller: nameController,
                          input: "Name",
                          icon: const Icon(Icons.person),
                          validate: (value) {
                            if (value == '') {
                              return "must have name";
                            }
                            return null;
                          },
                          focusNode: namefocusNode,
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
                          onsubmit: (value) {},
                          keytype: TextInputType.visiblePassword,
                          isPassword:
                              ClinicRegisterCubit.get(context).isPassword,
                          suffixIcons: IconButton(
                            onPressed: ClinicRegisterCubit.get(context)
                                .changeSuffixIcon,
                            icon: ClinicRegisterCubit.get(context).suffixIcon,
                          ),
                          focusNode: passwordfocusNode,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        textField(
                          controller: phoneController,
                          input: "Phonee",
                          icon: const Icon(Icons.phone),
                          validate: (value) {
                            if (value == '') {
                              return "must have phone";
                            }
                            return null;
                          },
                          focusNode: phonefocusNode,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ConditionalBuilder(
                          builder: (context) {
                            return defaultButton(
                              function: () {
                                if (formkey.currentState!.validate()) {
                                  ClinicRegisterCubit.get(context).userRegister(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    name: nameController.text,
                                    phone: phoneController.text,
                                  );
                                  navigatTo(context, LoginScreen( userType: 'patient',));
                                }
                              },
                              text: "Register",
                              isuper: true,
                            );
                          },
                          condition: state is! ClinicRegisterLodingState,
                          fallback: (context) =>
                            loading()
                        ),
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
