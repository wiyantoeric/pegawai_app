import 'package:pegawai_app/model/payroll.dart';
import 'package:pegawai_app/model/staff_member.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDatabase {
  final supabase = Supabase.instance.client;
  // Private constructor to prevent instantiation from outside the class.
  SupabaseDatabase._();

  // Singleton instance
  static SupabaseDatabase? _instance;

  // Factory method to provide the singleton instance
  factory SupabaseDatabase() {
    _instance ??= SupabaseDatabase._(); // Instantiate only if null

    return _instance!;
  }

  // Staff CRUD methods
  Future<void> createStaffMember(StaffMember staffMember) async {
    try {
      await supabase.from('staff_members').insert({
        'staff_member_id': staffMember.staff_member_id,
        'name': staffMember.name,
        'position': staffMember.position,
        'salary': staffMember.salary,
        'email': staffMember.email,
        'phone_number': staffMember.phoneNumber,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<StaffMember?>?> readAllStaffMembers() async {
    final data = await supabase.from('staff_members').select();

    if ((data as List).isEmpty) return null;

    return data.map((json) => StaffMember.fromJson(json)).toList();
  }

  Future<void> updateStaffMember(
      String staffMemberId, StaffMember staffMember) async {
    await supabase
        .from('staff_members')
        .update(staffMember.toJson())
        .match({'staff_member_id': staffMemberId});
  }

  Future<void> deleteStaffMember(String staffMemberId) async {
    await supabase
        .from('staff_members')
        .delete()
        .match({'staff_member_id': staffMemberId});
  }
}
