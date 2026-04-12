import 'package:flutter/material.dart';
import 'package:flutter_application_1/cubit/clinic_cubit.dart';
import 'package:flutter_application_1/cubit/clinic_state.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/appointment_models.dart';
import 'package:flutter_application_1/models/doctor_user_model.dart';
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
        
      
        var filtered = cubit.appoin.where((a) {
  if (a.patientId != uId) {
    return false;
  }
  if (cubit.selectedDocotrFilter == null) {
            return true; // رجع كل شيء
  }
            //رجع المواعيد حسب الدكتور

  return a.doctorId == cubit.selectedDocotrFilter!.doctorId;
}).toList();
        List<AppointmentModels> upcoming =
            filtered.where((e) => e.status == 'upcoming').toList();

        List<AppointmentModels> completed =
            filtered.where((e) => e.status == 'complete').toList();

        List<AppointmentModels> cancel =
            filtered.where((e) => e.status == 'cancel').toList();
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                // print(cubit.selectedDoctor);
                await navigatTo(context, const AddAppointmentScreen());
              },
              backgroundColor: const Color(0xFF2F80ED),
              child: const Icon(
                Icons.add,
              ),
            ),
            body: Column(
              children: [
                DropdownButtonFormField<DoctorUserModel>(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      fillColor: Colors.black
                      // filled: true,
                      ),
                  value: cubit.selectedDocotrFilter,
                  items: [
                    const DropdownMenuItem<DoctorUserModel>(
                      value: null,
                      child: Text("All Doctors"),
                    ),
                    //... : فك العناصر من List وحطهم مباشرة داخل List ثانية
                    ...cubit.doctorsList.map((doctor) {
                      return DropdownMenuItem<DoctorUserModel>(
                        value: doctor,
                        child: Text(doctor.name),
                      );
                    })
                  ],
                  onChanged: (value) {
                    cubit.changeFilterDoctor(value);
                  },
                  hint: const Text('Choose Doctor'),
                ),
                const SizedBox(
                  height: 10,
                ),
                const TabBar(
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Tab(text: "Upcoming"),
                    Tab(text: "Completed"),
                    Tab(text: "Cancel"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      buildAppointments(
                        upcoming,
                        type: 'patient',
                      ),
                      buildAppointments(
                        completed,
                        type: 'patient',
                      ),
                      buildAppointments(
                        cancel,
                        type: 'patient',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
