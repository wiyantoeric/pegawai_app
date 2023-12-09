class StaffMember {
  late String staffMemberId;
  late String name;
  late String position;
  late int salary;
  late String email;
  late String phoneNumber;
  late String? pictureUrl;

  StaffMember({
    required this.staffMemberId,
    required this.name,
    required this.position,
    required this.salary,
    required this.email,
    required this.phoneNumber,
    this.pictureUrl,
  });

  factory StaffMember.fromJson(Map<String, dynamic> json) {
    return StaffMember(
      staffMemberId: json['staff_member_id'] as String,
      name: json['name'] as String,
      position: json['position'] as String,
      salary: json['salary'] as int,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      pictureUrl:
          (json['picture_url'] == null) ? null : json['picture_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'staff_member_id': staffMemberId,
      'name': name,
      'position': position,
      'salary': salary,
      'email': email,
      'phone_number': phoneNumber,
      'picture_url': (pictureUrl == '') ? null : pictureUrl,
    };
  }
}
