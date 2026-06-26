import 'package:educational_products_app/features/student/presentation/pages/student_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/educational_product/presentation/pages/educational_product_list_page.dart';
import 'features/course/presentation/pages/course_list_page.dart';
import 'features/enrollment/presentation/pages/enrollment_list_page.dart';
import 'core/supabase/supabase_config.dart';
import 'core/sync/sync_service.dart';
import 'core/database/app_database.dart';
import 'features/course/data/datasources/course_remote_datasource.dart';
import 'features/educational_product/data/datasources/educational_product_remote_datasource.dart';
import 'features/student/data/datasources/student_remote_datasource.dart';
import 'features/enrollment/data/datasources/enrollment_remote_datasource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await SupabaseConfig.initialize();

  final client = SupabaseConfig.client;
  final appDatabase = AppDatabase();

  SyncService(
    database: appDatabase,
    courseRemote: CourseRemoteDataSource(client),
    productRemote: EducationalProductRemoteDataSource(client),
    studentRemote: StudentRemoteDataSource(client),
    enrollmentRemote: EnrollmentRemoteDataSource(client),
  ).syncAll();

  runApp(const EducationalProductApp());
}

class EducationalProductApp extends StatelessWidget {
  const EducationalProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Educational Products',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF534AB7),
          primary: const Color(0xFF534AB7),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  static const _purple = Color(0xFF534AB7);

  final List<Widget> _pages = const [
    EducationalProductListPage(),
    CourseListPage(),
    StudentListPage(),
    EnrollmentListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _purple,
        unselectedItemColor: Colors.black38,
        backgroundColor: Colors.white,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Produtos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Cursos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Alunos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Matrículas',
          ),
        ],
      ),
    );
  }
}
