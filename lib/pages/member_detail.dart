import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pegawai_app/database/supabase_db.dart';
import 'package:pegawai_app/logic/member_logic.dart';
import 'package:pegawai_app/model/staff_member.dart';

class MemberDetailPage extends StatelessWidget {
  final String staffMemberId;

  MemberDetailPage({required this.staffMemberId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('Staff Member Details'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                context.go('/');
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  context.goNamed(
                    'member_edit',
                    pathParameters: {
                      'staff_member_id': staffMemberId,
                    },
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Remove Member'),
                        content: Text(
                            'Are you sure you want to remove this member?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await SupabaseDatabase()
                                  .deleteStaffMember(staffMemberId)
                                  .then((value) {
                                context.go('/');
                              });
                            },
                            child: Text('Remove'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: FutureBuilder<StaffMember>(
              future: fetchMemberDetails(staffMemberId: staffMemberId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final staffMember = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        staffMember.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8),
                      Card(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(staffMember.position,
                                  style:
                                      Theme.of(context).textTheme.labelLarge),
                              SizedBox(height: 20),
                              Text('Salary: ${staffMember.salary}'),
                              SizedBox(height: 4),
                              Text('Email: ${staffMember.email}'),
                              SizedBox(height: 4),
                              Text('Phone Number: ${staffMember.phoneNumber}'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
