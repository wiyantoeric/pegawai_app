import 'package:pegawai_app/database/supabase_db.dart';
import 'package:pegawai_app/model/staff_member.dart';

Future<StaffMember> fetchMemberDetails({required String staffMemberId}) async {
  final List<StaffMember> staffMembers =
      await SupabaseDatabase().readAllStaffMembers() as List<StaffMember>;

  final StaffMember foundMember = staffMembers
      .firstWhere((member) => member.staff_member_id == staffMemberId);

  return foundMember;
}
