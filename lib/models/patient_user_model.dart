class PatientUserModel {
  final String name;
  final String email;
  final String phone;
  final String patientId;
  final String image;
  final String type;

  bool? isEmailVerified;
  PatientUserModel({
    required this.name,
    required this.phone,
    required this.image,
    required this.email,
    required this.patientId,
    required this.type,

    this.isEmailVerified,
  });

//بستقبل المعلومات
  factory PatientUserModel.fromJson(Map<String, dynamic>? json) {
    return PatientUserModel(
      patientId: json?['patientId'] ?? '',
      name: json?['name'] ?? '',
      email: json?['email'] ?? '',
      phone: json?['phone'] ?? '',
      image: json?['image'] ?? '',
      type: json?['type'] ?? '',

      isEmailVerified: json?['isEmailVerified'] ?? false,
    );
  }

//بعطي المعلومات
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'patientId': patientId,
      'image': image,
      'type': type,

      'isEmailVerified': isEmailVerified,
    };
  }
}
