class DoctorUserModel {
   String name;
  final String email;
  final String phone;
  final String doctorId;
  final String image;
  final String type;

  DoctorUserModel({
    required this.name,
    required this.phone,
    required this.image,
    required this.email,
    required this.doctorId,
    required this.type,

  });

//بستقبل المعلومات
  factory DoctorUserModel.fromJson(Map<String, dynamic>? json) {
    return DoctorUserModel(
      doctorId: json?['doctorId'] ?? '',
      name: json?['name'] ?? '',
      email: json?['email'] ?? '',
      phone: json?['phone'] ?? '',
      image: json?['image'] ?? '',
      type: json?['type'] ?? '',

    );
  }

//بعطي المعلومات
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'doctorId': doctorId,
      'image': image,
      'type': type,

    };
  }
}
