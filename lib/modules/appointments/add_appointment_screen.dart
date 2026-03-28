import 'package:flutter/material.dart';
import 'package:flutter_application_1/cubit/clinic_cubit.dart';
import 'package:flutter_application_1/cubit/clinic_state.dart';
import 'package:flutter_application_1/models/doctor_user_model.dart';
import 'package:flutter_application_1/modules/patient/patient_screen.dart';
import 'package:flutter_application_1/shared/widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAppointmentScreen extends StatelessWidget {
  const AddAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var formkey = GlobalKey<FormState>();
    var cubit = ClinicCubit.get(context);
    TextEditingController dateController = TextEditingController();
    TextEditingController noteController = TextEditingController();
    List<TimeOfDay> availableTimes = [
      const TimeOfDay(hour: 9, minute: 0),
      const TimeOfDay(hour: 10, minute: 0),
      const TimeOfDay(hour: 11, minute: 0),
      const TimeOfDay(hour: 12, minute: 0),
      const TimeOfDay(hour: 13, minute: 0),
      const TimeOfDay(hour: 14, minute: 0),
      const TimeOfDay(hour: 15, minute: 0),
    ];

    cubit.getUserDoctorData();
    return BlocConsumer<ClinicCubit, ClinicState>(
      listener: (context, state) {
        if (state is ClinicChangeDateState) {
          dateController.text =
              '${cubit.selectedDate!.day}/${cubit.selectedDate!.month}/${cubit.selectedDate!.year}';
        }

        if (state is ClinicCheckAppointmentsSuccessState) {
          navigatFinish(context, const PatientScreen());
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text(
              'Book Appointment',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Form(
                        key: formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Select Doctor',
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            state is ClinicGetDoctorDataLoadingState
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : DropdownButtonFormField<DoctorUserModel>(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      // filled: true,
                                    ),
                                    value: cubit.selectedDoctor,
                                    items: cubit.doctors.map((doctor) {
                                      return DropdownMenuItem<DoctorUserModel>(
                                        value: doctor,
                                        child: Text(doctor.name),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        cubit.changSelectedDoctor(value);
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return "Please select a doctor";
                                      }
                                      return null;
                                    },
                                    hint: const Text('Choose Doctor'),
                                  ),
                            const SizedBox(
                              height: 15,
                            ),
                            myDrevider(),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              'Select Date',
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              readOnly: true,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: 'Choose Date',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                suffixIcon: const Icon(
                                  Icons.calendar_month,
                                  color: Colors.blue,
                                ),
                              ),
                              onTap: () => datepicker(context),
                              controller: dateController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "must have date";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            myDrevider(),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              'Select Time',
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            DropdownButtonFormField<TimeOfDay>(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              value: cubit.selectedTime,
                              items: availableTimes.map((time) {
                                return DropdownMenuItem(
                                  value: time,
                                  child: Text(
                                      '${time.hour}:${time.minute.toString().padLeft(2, '0')}'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  cubit.changeTimePicker(
                                      value); // تستخدم نفس الدالة لتخزين الوقت
                                }
                              },
                              validator: (value) {
                                if (value == null)
                                  return "Please select a time";
                                return null;
                              },
                              hint: const Text('Choose Time'),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            myDrevider(),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              'Notes (Optional)',
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: noteController,
                              maxLines: 3,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                // labelText: 'Notes',
                                hintText: "Add any notes here... ",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: state is ClinicCheckAppointmentsLoadingState
                              ? const Center(child: CircularProgressIndicator())
                              : defaultButton(
                                  function: () {
                                    print(
                                        'PatientId: ${cubit.patientModel?.patientId}');

                                    if (formkey.currentState!.validate()) {
                                      cubit.checkAndAddAppointment(
                                        time: cubit.selectedTime!.format(context),
                                        date: dateController.text,
                                        doctorId:
                                            cubit.selectedDoctor!.doctorId,
                                      );
                                    }
                                  },
                                  text: 'Confirm',
                                  backgraund: Colors.green,
                                  fontsize: 18,
                                ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: defaultButton(
                            function: () {
                              Navigator.pop(context);
                            },
                            text: 'Cancel',
                            backgraund: Colors.white,
                            textColor: Colors.green,
                            fontsize: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void datepicker(context) {
    showDatePicker(
      //DateTime.utc: تستخدم لتحديد التاريخ كما أريد سواء باليوم أو الشهر أو السنة
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      selectableDayPredicate: (day) {
        // if (day.weekday == DateTime.friday) {
        //   return false;
        // }if (day.weekday == DateTime.saturday) {
        //   return false;
        // }
         return true;
      },
    ).then((value) {
      if (value == null) {
        return "Null";
      } else {
        // لأنه تتغير القيمة فيجب استخدامها
        ClinicCubit.get(context).changeDatePicker(value);
      }
    });
  }

  void timepicker(context) {
    showTimePicker(
      //DateTime.utc: تستخدم لتحديد التاريخ كما أريد سواء باليوم أو الشهر أو السنة
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value == null) {
        return "Null";
      } else {
        ClinicCubit.get(context).changeTimePicker(value);
      }
    });
  }
}
