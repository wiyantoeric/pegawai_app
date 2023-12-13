import 'package:go_router/go_router.dart';
import 'package:pegawai_app/model/staff_member.dart';
import 'package:pegawai_app/pages/add_member_page.dart';
import 'package:pegawai_app/pages/edit_member_page.dart';
import 'package:pegawai_app/pages/home_page.dart';
import 'package:pegawai_app/pages/detail_member_page.dart';
import 'package:pegawai_app/pages/not_found_page.dart';
import 'package:pegawai_app/pages/splash_page.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: <GoRoute>[
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/member/add',
      builder: (context, state) => const AddMemberPage(),
    ),
    GoRoute(
      path: '/404',
      builder: (context, state) => const NotFoundPage(),
    ),
    GoRoute(
      path: '/member/edit',
      name: 'member_edit',
      builder: (context, state) {
        final map = state.extra as Map<String, dynamic>;
        StaffMember? staffMember = map['staff_member'];

        print(staffMember?.toJson());

        if (staffMember.runtimeType != StaffMember) {
          return const NotFoundPage();
        }

        return EditMemberPage(staffMember: staffMember!);
      },
    ),
    GoRoute(
      path: '/member/:staff_member_id',
      name: 'member_detail',
      builder: (context, state) {
        String? staffMemberId = state.pathParameters['staff_member_id'];

        if (staffMemberId == null) {
          return const NotFoundPage();
        }

        return MemberDetailPage(
            staffMemberId: state.pathParameters['staff_member_id']!);
      },
    ),
  ],
);
