import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pegawai_app/database/supabase_db.dart';
import 'package:pegawai_app/logic/member_logic.dart';
import 'package:pegawai_app/model/staff_member.dart';

class MemberDetailPage extends StatefulWidget {
  final String staffMemberId;

  MemberDetailPage({required this.staffMemberId});

  @override
  State<MemberDetailPage> createState() => _MemberDetailPageState();
}

class _MemberDetailPageState extends State<MemberDetailPage> {
  late StaffMember staffMember;

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
                  context.goNamed('member_edit',
                      extra: {'staff_member': staffMember});
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
                                  .deleteStaffMember(widget.staffMemberId)
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
              future: fetchMemberDetails(staffMemberId: widget.staffMemberId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                  staffMember = snapshot.data!;
                

                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: (staffMember.pictureUrl != null)
                                  ? Image.network(
                                      staffMember.pictureUrl!,
                                      width: 150,
                                      height: 200,
                                      fit: BoxFit.cover,
                                      isAntiAlias: true,
                                    )
                                  : Container(
                                      width: 150,
                                      height: 200,
                                      child: Center(
                                        child: Text('No Image'),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceVariant,
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      staffMember.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    SizedBox(height: 4),
                                    Text(staffMember.position,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge),
                                    SizedBox(height: 20),
                                    Text('Salary: ${staffMember.salary}'),
                                    SizedBox(height: 4),
                                    Text('Email: ${staffMember.email}'),
                                    SizedBox(height: 4),
                                    Text(
                                        'Phone Number: ${staffMember.phoneNumber}'),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
