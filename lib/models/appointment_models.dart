class AppointmentModels {
  final String doctorName;
    final String patientName;

final String patientId;
final String doctorId;

final String appointmentId;

  final String date;
  final String time;
  final String status;

  AppointmentModels({
    required this.doctorName,
    required this.date,
    required this.time,
    required this.status,
    required this.patientId,
    required this.doctorId,
    required this.patientName,
    required this.appointmentId,


  });

  
//بستقبل المعلومات
  factory AppointmentModels.fromJson(Map<String, dynamic>? json) {
    return AppointmentModels(
      doctorName: json?['doctorName'] ?? '',
      date: json?['date'] ?? '',
      time: json?['time'] ?? '',
      status: json?['status'] ?? '',
      patientId: json?['patientId'] ?? '',
      patientName: json?['patientName'] ?? '',
      appointmentId: json?['appointmentId'] ?? '',
      doctorId: json?['doctorId'] ?? '',

    );
  }

//بعطي المعلومات
  Map<String, dynamic> toMap() {
    return {
      'doctorName': doctorName,
      'date': date,
      'time': time,
      'status': status,
      'patientId': patientId,
      'patientName': patientName,
      'appointmentId': appointmentId,
      'doctorId': doctorId,

    };
  }

}
