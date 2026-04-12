import 'package:flutter/material.dart';
import 'package:flutter_application_1/cubit/clinic_cubit.dart';
import 'package:flutter_application_1/cubit/clinic_state.dart';
import 'package:flutter_application_1/shared/widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditName extends StatelessWidget {
  const EditName({super.key});
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    ClinicCubit cubit = ClinicCubit.get(context);
    return BlocConsumer<ClinicCubit,ClinicState>(
      listener: (context, state) {
      
    },
    builder:(context, state) {
      return  Scaffold(
      appBar: AppBar(
        title: const Text('Edit Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            textField(
                controller: nameController,
                validate:(value) {
                                if (value == null || value.isEmpty) {
                                  return "must have date";
                                }
                                return null;
                              },
                input: 'New Name'),
            const SizedBox(
              height: 15,
            ),
            defaultButton(
                function: () {
                  cubit.changeName(nameController.text);
                  Navigator.pop(context);
                  toast('Success', Colors.green);
                },
                text: 'Submit')
          ],
        ),
      ),
    );
    } ,);
  }
}
