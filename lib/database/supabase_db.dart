import 'dart:io';

import 'package:flutter/widgets.dart';
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
  Future<void> createStaffMember(StaffMember staffMember,
      {File? staffPicture}) async {
    try {
      String? pictureUrl;
      if (staffPicture != null) {
        pictureUrl = await uploadStaffMemberPicture(
            staffMember.staffMemberId, staffPicture);
      }

      await supabase.from('staff_members').insert({
        'staff_member_id': staffMember.staffMemberId,
        'name': staffMember.name,
        'position': staffMember.position,
        'salary': staffMember.salary,
        'email': staffMember.email,
        'phone_number': staffMember.phoneNumber,
        'picture_url': pictureUrl,
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

  Future<void> updateStaffMember(String staffMemberId, StaffMember staffMember,
      {File? staffPicture}) async {
    String? pictureUrl;

    if (staffPicture != null) {
      pictureUrl = await uploadStaffMemberPicture(
          staffMember.staffMemberId, staffPicture);
    }

    staffMember.pictureUrl = pictureUrl;

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

    await supabase.storage.from('staff_picture').remove([staffMemberId]);
  }

  Future<String?> uploadStaffMemberPicture(
      String staffMemberId, File image) async {
    try {
      await supabase.storage
          .from('staff_picture')
          .upload(staffMemberId, image, fileOptions: FileOptions(upsert: true));
      final publicUrl = await supabase.storage
          .from('staff_picture')
          .getPublicUrl(staffMemberId);
      return publicUrl;
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<File?> getStaffMemberPicture(String staffMemberId) async {
    try {
      final publicUrl = await supabase.storage
          .from('staff_picture')
          .getPublicUrl(staffMemberId);
      return File.fromUri(Uri.parse(publicUrl));
    } catch (e) {
      print(e);
    }
    return null;
  }
}
