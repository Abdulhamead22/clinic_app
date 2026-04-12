class AppointmentModels {

final String patientId;
final String doctorId;

final String appointmentId;

  final String date;
  final String time;
  final String status;

  AppointmentModels({
    required this.date,
    required this.time,
    required this.status,
    required this.patientId,
    required this.doctorId,
    required this.appointmentId,


  });

  
//بستقبل المعلومات
  factory AppointmentModels.fromJson(Map<String, dynamic>? json) {
    return AppointmentModels(
      date: json?['date'] ?? '',
      time: json?['time'] ?? '',
      status: json?['status'] ?? '',
      patientId: json?['patientId'] ?? '',
      appointmentId: json?['appointmentId'] ?? '',
      doctorId: json?['doctorId'] ?? '',

    );
  }

//بعطي المعلومات
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'time': time,
      'status': status,
      'patientId': patientId,
      'appointmentId': appointmentId,
      'doctorId': doctorId,

    };
  }

}
