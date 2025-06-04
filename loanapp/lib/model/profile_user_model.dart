class ProfileUserModel {
  final String name;
  final String phoneNumber;
  final int age;
  final String profileImage;
  final String? salarySlip;
  final String? document;
  final String? passport;

  ProfileUserModel({
    required this.name,
    required this.phoneNumber,
    required this.age,
    required this.profileImage,
    this.salarySlip,
    this.document,
    this.passport,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'age': age,
      'profileImage': profileImage,
      'salarySlip': salarySlip,
      'document': document,
      'passport': passport,
    };
  }

  factory ProfileUserModel.fromMap(Map<String, dynamic> map) {
    return ProfileUserModel(
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      age: map['age'] ?? 0,
      profileImage: map['profileImage'] ?? '',
      salarySlip: map['salarySlip'],
      document: map['document'],
      passport: map['passport'],
    );
  }
}
