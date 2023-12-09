import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pegawai_app/database/supabase_db.dart';
import 'package:pegawai_app/model/staff_member.dart';

class EditMemberPage extends StatefulWidget {
  final StaffMember staffMember;

  const EditMemberPage({super.key, required this.staffMember});

  @override
  _EditMemberPageState createState() => _EditMemberPageState();
}

class _EditMemberPageState extends State<EditMemberPage> {
  final SupabaseDatabase supabaseDatabase = SupabaseDatabase();

  final _nameController = TextEditingController();
  final _positionController = TextEditingController();
  final _salaryController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  String? staffPicturePath;
  bool isPictureSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Edit Member'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();

                    setState(() {
                      try {
                        staffPicturePath = result!.files.single.path!;
                        isPictureSelected = true;
                        print(staffPicturePath);
                        print('staffPicturePath');
                      } catch (e) {
                        print(e);
                      }
                    });
                  },
                  child: (widget.staffMember.pictureUrl == null &&
                          !isPictureSelected)
                      ? Container(
                          width: 200,
                          height: 200,
                          padding: const EdgeInsets.all(32.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            // color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: const Center(
                            child: Text('Upload Image'),
                          ),
                        )
                      : Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            // color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: isPictureSelected
                              ? Image.file(
                                  // Display the selected image
                                  File(staffPicturePath!),
                                  height: 200,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  // Display the selected image
                                  widget.staffMember.pictureUrl!,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                        ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _nameController..text = widget.staffMember.name,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _positionController
                    ..text = widget.staffMember.position,
                  decoration: const InputDecoration(
                    labelText: 'Position',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _salaryController
                    ..text = widget.staffMember.salary.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Salary',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _emailController..text = widget.staffMember.email,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _phoneNumberController
                    ..text = widget.staffMember.phoneNumber,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final updatedMember = StaffMember(
                        staffMemberId: widget.staffMember.staffMemberId,
                        name: _nameController.text,
                        position: _positionController.text,
                        salary: int.parse(_salaryController.text),
                        email: _emailController.text,
                        phoneNumber: _phoneNumberController.text,
                      );

                      File? image;
                      if (staffPicturePath != null) {
                        image = File(staffPicturePath!);
                      }

                      // Update the member in the database
                      await supabaseDatabase.updateStaffMember(
                          widget.staffMember.staffMemberId, updatedMember, staffPicture: image);

                      // Navigate back to the home page
                      context.go('/');
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Text('Update Member'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    _salaryController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();

    super.dispose();
  }
}
