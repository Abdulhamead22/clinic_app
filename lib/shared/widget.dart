import 'dart:async';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/cubit/clinic_cubit.dart';
import 'package:flutter_application_1/models/appointment_models.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget myDrevider() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Container(
      width: double.infinity,
      height: 1,
      color: Colors.grey[300],
    ),
  );
}

TextFormField textField({
  required TextEditingController controller,
  String? input,
  TextInputType keytype = TextInputType.emailAddress,
  Icon? icon,
  Widget? suffixIcons,
  required FormFieldValidator<String> validate,
  GestureTapCallback? ontap,
  var onchange,
  FocusNode? focusNode,
  ValueChanged<String>? onsubmit,
  bool isPassword = false,
}) {
  return TextFormField(
    style: const TextStyle(color: Colors.black),
    focusNode: focusNode,
    onEditingComplete: () {
      focusNode?.unfocus();
      scheduleMicrotask(focusNode!.requestFocus);
    },
    decoration: InputDecoration(
      labelText: input,
      hintText: "Enter $input",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      prefixIcon: icon,
      suffixIcon: suffixIcons,
    ),
    obscureText: isPassword, //للنص مخفي ولا لا
    keyboardType: keytype,
    onFieldSubmitted: onsubmit,
    onTap: ontap,
    onChanged: onchange,
    controller: controller,
    validator: validate,
  );
}

Widget defaultButton({
  double width = double.infinity,
  Color backgraund = Colors.blue,
  Color textColor = Colors.white,
  bool isuper = true,
  double radies = 3.0,
  required VoidCallback? function,
  required String text,
  double fontsize = 30,
}) {
  return Container(
    width: width,
    height: 40,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radies),
      color: backgraund,
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    child: MaterialButton(
      onPressed: function,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontsize,
          color: textColor,
        ),
      ),
    ),
  );
}

PreferredSizeWidget? defaultAppBar(
  BuildContext context,
  String title,
  List<Widget> actions,
) {
  return AppBar(
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back_ios_new),
    ),
    titleSpacing: 5.0,
    title: Text(
      title,
    ),
    actions: actions,
  );
}

Widget defaultTextButton({
  required VoidCallback? function,
  required String text,
}) {
  return TextButton(
    onPressed: function,
    child: Text(text),
  );
}

Future<dynamic> navigatFinish(context, builder) {
  return Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) {
        return builder;
      },
    ),
    (route) {
      return false;
    },
  );
}

Future<dynamic> navigatTo(context, builder) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return builder;
      },
    ),
  );
}

Future<bool?> toast(String text, Color color) {
  return Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: color,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

// Container emailVerified() {
//   return Container(
//     height: 50,
//     color: Colors.amber.withOpacity(0.65),
//     child: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       child: Row(
//         children: [
//           const Icon(Icons.info_outline),
//           const SizedBox(
//             width: 10,
//           ),
//           const Expanded(
//             child: Text("Please verify email"),
//           ),
//           const SizedBox(
//             width: 20,
//           ),
//           defaultTextButton(
//             function: () {
//               FirebaseAuth.instance.currentUser?.sendEmailVerification().then(
//                 (value) {
//                   toast("check your email", Colors.green);
//                 },
//               ).catchError((error) {});
//             },
//             text: "Send",
//           ),
//         ],
//       ),
//     ),
//   );
// }

Card appointmentCard(
  context,
  String type,
  AppointmentModels model,
) {
  Color? statusColor;

  switch (model.status) {
    case 'complete':
      statusColor = Colors.green.shade50;
      break;
    case 'upcoming':
      statusColor = Colors.yellow.shade50;
      break;
    case 'cancel':
      statusColor = Colors.red.shade50;
      break;
  }
  return Card(
    elevation: 5,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                type == 'patient' ? model.doctorName : model.patientName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (type != 'doctor' && model.status == 'upcoming')
                IconButton(
                  onPressed: () {
                    alertDialog1(context, model, 'cancel');
                  },
                  icon: const Icon(Icons.cancel_outlined),
                  color: Colors.red,
                ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text("${model.date} - ${model.time}"),
          const SizedBox(
            height: 10,
          ),
          Chip(
            label: Text(model.status.toUpperCase()),
            backgroundColor: statusColor,
            avatar: Icon(
              model.status == 'complete'
                  ? Icons.check
                  : model.status == 'upcoming'
                      ? Icons.access_time
                      : Icons.cancel,
              size: 16,
              color: model.status == 'complete'
                  ? Colors.green
                  : model.status == 'upcoming'
                      ? Colors.orange
                      : Colors.red,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (type == 'doctor' && model.status == 'upcoming')
            Row(
              children: [
                Expanded(
                  child: defaultButton(
                    function: () {
                      alertDialog1(context, model,'complete');
                      // ClinicCubit.get(context).updateStatusAppointment(
                      // model.appointmentId, 'complete');
                    },
                    fontsize: 12,
                    radies: 8,
                    backgraund: Colors.green,
                    text: "Complete",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: defaultButton(
                    function: () {
                      alertDialog1(context, model, 'cancel');

                      // ClinicCubit.get(context).updateStatusAppointment(
                      // model.appointmentId, 'cancel');
                    },
                    fontsize: 12,
                    radies: 8,
                    backgraund: Colors.red,
                    text: "Cancel",
                  ),
                ),
              ],
            ),
          if (type == 'doctor')
            const SizedBox(
              height: 10,
            ),
        ],
      ),
    ),
  );
}

void alertDialog1(context, AppointmentModels model,String state ) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'Are you sure want to $state this appointment?',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(
              color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            state == 'complete' ? Colors.green : Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text("Sure!"),
                      onPressed: () {
                        ClinicCubit.get(context)
                            .updateStatusAppointment(model.appointmentId, state);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
    barrierDismissible:
        false, //مسؤولة عن امكانية غلق الشاشة عند الضغط على اي مكان بالصفحة
  );
}

ConditionalBuilder buildAppointments(List<AppointmentModels> appointment,
    {required String type}) {
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
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      appointmentCard(
                        context,
                        type,
                        appointment[index],
                      ),
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
    fallback: (context) => emptyState(context),
  );
}

emptyState(context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.calendar_month,
          size: 60,
          color: Colors.grey[400],
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          'No Appointments',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey[700],
              ),
          // style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          'Not have booked any appointments yet ',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[500],
              ),
          // style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    ),
  );
}
