import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pegawai_app/database/supabase_db.dart';
import 'package:pegawai_app/logic/member_logic.dart';
import 'package:pegawai_app/model/staff_member.dart';

class MemberDetailPage extends StatefulWidget {
  final String staffMemberId;

  const MemberDetailPage({super.key, required this.staffMemberId});

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
            title: const Text('Staff Member Details'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.go('/');
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  context.goNamed('member_edit',
                      extra: {'staff_member': staffMember});
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Remove Member'),
                        content: const Text(
                            'Are you sure you want to remove this member?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await SupabaseDatabase()
                                  .deleteStaffMember(widget.staffMemberId)
                                  .then((value) {
                                context.go('/');
                              });
                            },
                            child: const Text('Remove'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          SliverFillRemaining(
            child: FutureBuilder<StaffMember>(
              future: fetchMemberDetails(staffMemberId: widget.staffMemberId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                staffMember = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
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
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Container(
                                          width: 150,
                                          height: 200,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceVariant,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      width: 150,
                                      height: 200,
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
                                      child: const Center(
                                        child: Text('No Image'),
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
                                    const SizedBox(height: 4),
                                    Text(staffMember.position,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge),
                                    const SizedBox(height: 20),
                                    Text('Salary: ${staffMember.salary}'),
                                    const SizedBox(height: 4),
                                    Text('Email: ${staffMember.email}'),
                                    const SizedBox(height: 4),
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
