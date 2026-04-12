import 'package:flutter/material.dart';
import 'package:flutter_application_1/modules/login/login_screen.dart';
import 'package:flutter_application_1/shared/widget.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to Clinic",
                style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(
              height: 20,
            ),
            // Doctor Button
            buildCard(context, 'doctor', Colors.blue),

            buildCard(context, 'patient', Colors.green),
          ],
        ),
      ),
    );
  }

  InkWell buildCard(BuildContext context, String type, Color color) {
    return InkWell(
      onTap: () {
        navigatTo(
            context,
            LoginScreen(
              userType: type,
            ));
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.medical_services, color: Colors.white, size: 50),
            const SizedBox(height: 10),
            Text(type, style: const TextStyle(fontSize: 24, color: Colors.white)),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
