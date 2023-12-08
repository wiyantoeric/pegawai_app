import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pegawai_app/database/supabase_db.dart';
import 'package:pegawai_app/model/staff_member.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabaseDatabase = SupabaseDatabase();
  late List<StaffMember> staffMembers;
  late ConnectivityResult _connectivityResult;

  @override
  void initState() {
    super.initState();

    _connectivityResult = ConnectivityResult.none;

    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectivityResult = result;
      });
    });

    // Check the initial connectivity state
    Connectivity().checkConnectivity().then((result) {
      setState(() {
        _connectivityResult = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Staff Members'),
            actions: [
              if (_connectivityResult != ConnectivityResult.none)
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    context.go('/member/add');
                  },
                ),
            ],
          ),
          _connectivityResult == ConnectivityResult.none
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Text('There is no internet connection'),
                  ),
                )
              : FutureBuilder<List<StaffMember?>?>(
                  future: supabaseDatabase.readAllStaffMembers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()));
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      if (snapshot.data == null) {
                        return SliverToBoxAdapter(
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to add member page or show a dialog to add member
                                context.go('/member/add');
                              },
                              child: const Text('Add Member'),
                            ),
                          ),
                        );
                      }

                      final fetchedStaffMembers =
                          snapshot.data as List<StaffMember>;
                      staffMembers = fetchedStaffMembers;

                      return staffMembers.isEmpty
                          ? SliverToBoxAdapter(
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigate to add member page or show a dialog to add member
                                    context.go('/member/add');
                                  },
                                  child: const Text('Add Member'),
                                ),
                              ),
                            )
                          : SliverList.builder(
                              itemCount: staffMembers.length,
                              itemBuilder: (context, index) {
                                final staffMember = staffMembers[index];

                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: InkWell(
                                    onTap: () {
                                      // Navigate to member detail page
                                      context.goNamed(
                                        'member_detail',
                                        pathParameters: {
                                          'staff_member_id': staffMembers[index]
                                              .staff_member_id
                                        },
                                      );
                                    },
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  staffMember.name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium,
                                                ),
                                                Text(
                                                  staffMember.position,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium,
                                                ),
                                                Text(
                                                    'Rp. ${staffMember.salary.toString()}'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                    }
                  },
                ),
        ],
      ),
    );
  }
}
