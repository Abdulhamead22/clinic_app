import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/cubit/clinic_cubit.dart';
import 'package:flutter_application_1/cubit/clinic_state.dart';
import 'package:flutter_application_1/shared/widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentsDoctorScreen extends StatelessWidget {
  const AppointmentsDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = ClinicCubit.get(context);

    return BlocConsumer<ClinicCubit, ClinicState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
            condition: cubit.appoin.isNotEmpty,
            builder: (context) {
              return Scaffold(
                body: SingleChildScrollView(
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
                            // cubit.getAppointmentsDataDoctor(cubit.userId[index]);
                            return appointmentCard(
                                context, 'doctor', cubit.appoin[index],
                                cancelAppointment: false);
                          },
                          separatorBuilder: (context, index) => myDrevider(),
                          itemCount: cubit.appoin.length,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            fallback: (context) => emptyState(context));
      },
    );
  }
}
