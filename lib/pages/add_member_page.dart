import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pegawai_app/database/supabase_db.dart';
import 'package:pegawai_app/model/staff_member.dart';
import 'package:uuid/uuid.dart';

class AddMemberPage extends StatefulWidget {
  const AddMemberPage({super.key});

  @override
  _AddMemberPageState createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final SupabaseDatabase supabaseDatabase = SupabaseDatabase();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  String? staffPicturePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Add Member'),
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned(
            right: -150,
            top: -150,
            child: Container(
              child: Image.asset(
                'assets/images/blue-circle.png',
                width: 300,
                height: 300,
              ),
            ),
          ),
          Padding(
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
                          } catch (e) {
                            print(e);
                          }
                        });
                      },
                      child: (staffPicturePath == null)
                          ? Container(
                              width: 200,
                              height: 200,
                              padding: const EdgeInsets.all(32.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                // color: Theme.of(context).colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(4.0),
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
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
                              child: Image.file(
                                // Display the selected image
                                File(staffPicturePath!),
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: positionController,
                      decoration: const InputDecoration(
                        labelText: 'Position',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: salaryController,
                      decoration: const InputDecoration(
                        labelText: 'Salary',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: phoneNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          if (nameController.text.isEmpty ||
                              positionController.text.isEmpty ||
                              salaryController.text.isEmpty) {
                            // Show an error message or snackbar indicating the fields are required
                            return;
                          }

                          File? image;
                          if (staffPicturePath != null) {
                            image = File(staffPicturePath!);
                          }

                          // Create a new staff member
                          final newMember = StaffMember(
                            staffMemberId: const Uuid().v1(),
                            name: nameController.text,
                            position: positionController.text,
                            salary: int.parse(salaryController.text),
                            email: emailController.text,
                            phoneNumber: phoneNumberController.text,
                          );

                          // Insert the new member into the database
                          await supabaseDatabase.createStaffMember(newMember,
                              staffPicture: image);
                        } catch (e) {
                          print(e);
                        }

                        // Navigate back to the home page
                        context.go('/');
                      },
                      child: const Text('Add Member'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
