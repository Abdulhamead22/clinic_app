import 'package:flutter/material.dart';
import 'package:flutter_application_1/cubit/clinic_cubit.dart';
import 'package:flutter_application_1/cubit/clinic_state.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/modules/settings/edit_name.dart';
import 'package:flutter_application_1/shared/widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = ClinicCubit.get(context);
    // ignore: prefer_typing_uninitialized_variables
    var model;
    return BlocConsumer<ClinicCubit, ClinicState>(
      listener: (context, state) {},
      builder: (context, state) {
        model = userType == 'patient' ? cubit.patientModel : cubit.doctorModel;
        if (model == null) {
          loading();
        }
        return Scaffold(
          backgroundColor: Colors.grey[200],
          body: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 64,
                    backgroundColor: Colors.grey[200],
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                        model.image,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    model!.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  buildCard(
                      Icons.person,
                      'Edit Name',
                      const Icon(
                        Icons.arrow_forward_ios,
                      ),
                      () => navigatTo(context, const EditName())),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 2,
                    child: SwitchListTile(
                      value: cubit.isDark,
                      onChanged: (value) {
                          cubit.changeTheme();

                      },
                      title: const Text('Dark Mode'),
                      secondary: const Icon(Icons.dark_mode),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildCard(
    IconData? icon,
    String title,
    Widget iconTrailing,
    dynamic onPressed,
  ) {
    Widget? child;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      child: child ??
          Column(
            children: [
              ListTile(
                leading: Icon(icon),
                title: Text(title),
                trailing: IconButton(onPressed: onPressed, icon: iconTrailing),
              ),
            ],
          ),
    );
  }
}
