import 'package:flutter/material.dart';
import 'package:flutter_application_1/cubit/clinic_cubit.dart';
import 'package:flutter_application_1/cubit/clinic_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  @override
  void initState() {
    super.initState();
    ClinicCubit.get(context).getUserDoctorAllData();
    ClinicCubit.get(context).getAllPatientsData();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = ClinicCubit.get(context);
    // cubit.getUserDoctorAllData();
    return BlocConsumer<ClinicCubit, ClinicState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF2F80ED),
            title: const Text(
              "Wellcome Doctor ",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  cubit.signOut(context);
                },
                icon: const Icon(Icons.logout_outlined, color: Colors.white),
              )
            ],
          ),
          body: cubit.pageDoctor[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (value) {
              cubit.changIndexNavBar(
                value,
              );
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month), label: 'Appointments'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Setting'),
            ],
          ),
        );
      },
    );
  }
}
