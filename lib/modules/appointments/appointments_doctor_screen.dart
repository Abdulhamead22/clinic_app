import 'package:flutter/material.dart';
import 'package:flutter_application_1/cubit/clinic_cubit.dart';
import 'package:flutter_application_1/cubit/clinic_state.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/appointment_models.dart';
import 'package:flutter_application_1/shared/widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentsDoctorScreen extends StatelessWidget {
  const AppointmentsDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClinicCubit, ClinicState>(
      listener: (context, state) {
        // if (state is ClinicUpdateStatusSuccessState) {
        //   toast('Success', Colors.green);
        //   // ScaffoldMessenger.of(context).showSnackBar(
        //   //   SnackBar(
        //   //     content: Text("Appointment updated"),
        //   //     backgroundColor: Colors.green,
        //   //   ),
        //   // );
        // }
      },
      builder: (context, state) {
        var cubit = ClinicCubit.get(context);

        var filtered = cubit.appoin.where((a) {
          //رجع المواعيد حسب الدكتور
          return a.doctorId == uId;
        }).toList();
        List<AppointmentModels> upcoming =
            filtered.where((e) => e.status == 'upcoming').toList();

        List<AppointmentModels> completed =
            filtered.where((e) => e.status == 'complete').toList();

        List<AppointmentModels> cancel =
            filtered.where((e) => e.status == 'cancel').toList();
        return DefaultTabController(
          length: 3,
          child: Column(
            children: [
              const TabBar(
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Tab(text: "Upcoming"),
                    Tab(text: "Completed"),
                    Tab(text: "Cancel"),
                  ]),
              Expanded(
                  child: TabBarView(children: [
                buildAppointments(
                  upcoming,
                  type: 'doctor',
                ),
                buildAppointments(completed, type: 'doctor'),
                buildAppointments(
                  cancel,
                  type: 'doctor',
                ),
              ])),
            ],
          ),
        );
      },
    );
  }
}
// ConditionalBuilder(
//             condition: cubit.appoin.isNotEmpty,
//             builder: (context) {
//               return Scaffold(
//                 body: SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   child: Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                        
//                         ListView.separated(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemBuilder: (context, index) {
//                             // cubit.getAppointmentsDataDoctor(cubit.userId[index]);
//                             return appointmentCard(
//                                 context, 'doctor', cubit.appoin[index],
//                                 cancelAppointment: false);
//                           },
//                           separatorBuilder: (context, index) => myDrevider(),
//                           itemCount: cubit.appoin.length,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//             fallback: (context) => emptyState(context));
