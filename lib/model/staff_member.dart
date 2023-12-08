class StaffMember {
  late String staff_member_id; // Assuming you have an ID field in your table
  late String name;
  late String position;
  late int salary;
  late String email;
  late String phoneNumber;

  StaffMember({
    required this.staff_member_id,
    required this.name,
    required this.position,
    required this.salary,
    required this.email,
    required this.phoneNumber,
  });

  factory StaffMember.fromJson(Map<String, dynamic> json) {
    return StaffMember(
      staff_member_id: json['staff_member_id'] as String,
      name: json['name'] as String,
      position: json['position'] as String,
      salary: json['salary'] as int,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'staff_member_id': staff_member_id,
      'name': name,
      'position': position,
      'salary': salary,
      'email': email,
      'phone_number': phoneNumber,
    };
  }
}

