import 'package:flutter/material.dart';
import 'package:flutter_application_1/cubit/clinic_cubit.dart';
import 'package:flutter_application_1/cubit/clinic_state.dart';
import 'package:flutter_application_1/modules/doctor/doctor_screen.dart';
import 'package:flutter_application_1/modules/patient/patient_screen.dart';
import 'package:flutter_application_1/role_selection_screen.dart';
import 'package:flutter_application_1/shared/cache_helper.dart';
import 'package:flutter_application_1/shared/theam.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String? uId;
bool? isDark = CacheHelper.getData(key: 'isDark');  

String? userType;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Firebase.initializeApp();

  uId = CacheHelper.getData(key: 'uId');
  userType = CacheHelper.getData(key: 'userType');

  Widget? widget;
  if (uId != null && userType == 'patient') {
    widget = const PatientScreen();
    
  } else if (uId != null && userType == 'doctor') {
    widget = const DoctorScreen();
  } else {
    widget = const RoleSelectionScreen();
  }

  runApp(MyApp(
    startpage: widget,
  ));
}
class MyApp extends StatelessWidget {
  final Widget? startpage;
  const MyApp({super.key, this.startpage});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClinicCubit()
        ..isDark = isDark ?? false

        ..getUserPatientData()
        ..getAppointmentsData()
        ..getUserDoctorData(),
      child: BlocBuilder<ClinicCubit, ClinicState>(
        builder: (context, state) {
          var cubit = ClinicCubit.get(context);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ligthTheam,
            darkTheme: darkTheam,
            themeMode: cubit.isDark
                ? ThemeMode.dark
                : ThemeMode.light,
            home: startpage,
          );
        },
      ),
    );
  }
}
// class MyApp extends StatelessWidget {
//   final Widget? startpage;
//   const MyApp({super.key, this.startpage});
//   @override
//   Widget build(BuildContext context) {
//         var cubit=ClinicCubit.get(context);
//     return BlocProvider(
  
//       create: (context) => ClinicCubit()
//         ..getUserPatientData()
//         ..getAppointmentsData()
//         ..getUserDoctorData(),
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Flutter Demo',
//         theme: ligthTheam,
//         darkTheme: darkTheam,
// themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light, 
//        home: startpage,
//       ),
//     );
//   }
// }
