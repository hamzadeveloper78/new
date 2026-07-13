class Student {
  final int? id;
  final String name;
  final String idType;
  final String idNumber;
  final String governorate;
  final String district;
  final String village;
  final String isolation;
  final String specialization;
  final String level;
  final String phone;
  final String createdAt;

  Student({
    this.id,
    required this.name,
    required this.idType,
    required this.idNumber,
    required this.governorate,
    required this.district,
    required this.village,
    required this.isolation,
    required this.specialization,
    required this.level,
    required this.phone,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'idType': idType,
      'idNumber': idNumber,
      'governorate': governorate,
      'district': district,
      'village': village,
      'isolation': isolation,
      'specialization': specialization,
      'level': level,
      'phone': phone,
      'createdAt': createdAt,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      idType: map['idType'],
      idNumber: map['idNumber'],
      governorate: map['governorate'],
      district: map['district'],
      village: map['village'],
      isolation: map['isolation'],
      specialization: map['specialization'],
      level: map['level'],
      phone: map['phone'],
      createdAt: map['createdAt'],
    );
  }
}
