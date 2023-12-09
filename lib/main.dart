import 'package:flutter/material.dart';
import 'package:pegawai_app/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  final supabaseUrl = dotenv.get('SUPABASE_URL');
  final supabaseKey = dotenv.get('SUPABASE_KEY');

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const PegawaiApp());
}

class PegawaiApp extends StatelessWidget {
  const PegawaiApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Pegawai App',
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
    );
  }
}
