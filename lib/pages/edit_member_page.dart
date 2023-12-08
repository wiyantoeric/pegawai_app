import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pegawai_app/database/supabase_db.dart';
import 'package:pegawai_app/logic/member_logic.dart';
import 'package:pegawai_app/model/staff_member.dart';

class EditMemberPage extends StatefulWidget {
  final String staffMemberId;

  const EditMemberPage({super.key, required this.staffMemberId});

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
        child: FutureBuilder<StaffMember>(
          future: fetchMemberDetails(staffMemberId: widget.staffMemberId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final member = snapshot.data!;

            return ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nameController..text = member.name,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _positionController..text = member.position,
                      decoration: const InputDecoration(
                        labelText: 'Position',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _salaryController
                        ..text = member.salary.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Salary',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _emailController..text = member.email,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _phoneNumberController
                        ..text = member.phoneNumber,
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
                            staff_member_id: member.staff_member_id,
                            name: _nameController.text,
                            position: _positionController.text,
                            salary: int.parse(_salaryController.text),
                            email: _emailController.text,
                            phoneNumber: _phoneNumberController.text,
                          );

                          // Update the member in the database
                          await supabaseDatabase.updateStaffMember(
                              widget.staffMemberId, updatedMember);

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
            );
          },
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
