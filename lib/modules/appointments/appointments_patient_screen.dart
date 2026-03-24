import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/cubit/clinic_cubit.dart';
import 'package:flutter_application_1/cubit/clinic_state.dart';
import 'package:flutter_application_1/models/appointment_models.dart';
import 'package:flutter_application_1/modules/appointments/add_appointment_screen.dart';
import 'package:flutter_application_1/shared/widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentsPatientScreen extends StatelessWidget {
  const AppointmentsPatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClinicCubit, ClinicState>(
      listener: (context, state) {
        if (state is ClinicUpdateStatusSuccessState) {
          toast("Appointment cancelled successfully", Colors.green);
        }
      },
      builder: (context, state) {
        var cubit = ClinicCubit.get(context);
        List<AppointmentModels> upcoming =
            cubit.appoin.where((e) => e.status == 'upcoming').toList();

        List<AppointmentModels> completed =
            cubit.appoin.where((e) => e.status == 'complete').toList();

        List<AppointmentModels> cancel =
            cubit.appoin.where((e) => e.status == 'cancel').toList();
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("My Appointments"),
              bottom: const TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(text: "Upcoming"),
                  Tab(text: "Completed"),
                  Tab(text: "Cancel"),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await navigatTo(context, const AddAppointmentScreen());
              },
              backgroundColor: const Color(0xFF2F80ED),
              child: const Icon(
                Icons.add,
              ),
            ),
            body: TabBarView(
              children: [
                buildAppointments(upcoming, cancelAppointment: true),
                buildAppointments(completed, cancelAppointment: false),
                buildAppointments(cancel, cancelAppointment: false),
              ],
            ),
          ),
        );
      },
    );
  }

  ConditionalBuilder buildAppointments(List<AppointmentModels> appointment,
      {required cancelAppointment}) {
    return ConditionalBuilder(
      condition: appointment.isNotEmpty,
      builder: (context) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Appointments',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: 15,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        appointmentCard(context, 'patient', appointment[index],
                            cancelAppointment: cancelAppointment),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => myDrevider(),
                  itemCount: appointment.length,
                ),
              ],
            ),
          ),
        );
      },
      fallback: (context) => Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     await navigatTo(context, const AddAppointmentScreen());
        //   },
        //   backgroundColor: const Color(0xFF2F80ED),
        //   child: const Icon(
        //     Icons.add,
        //   ),
        // ),
        body: emptyState(context),
      ),
    );
  }
}
