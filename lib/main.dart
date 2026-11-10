import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/config/clinic_settings.dart';
import 'core/database/database_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/admin/presentation/admin_panel_screen.dart';
import 'features/encounter/presentation/doctor_workspace_screen.dart';
import 'features/reception/presentation/reception_screen.dart';

enum AppRole {
  reception,
  doctor,
  admin,
}

class ActiveRoleNotifier extends Notifier<AppRole> {
  @override
  AppRole build() => AppRole.reception;

  void setRole(AppRole role) => state = role;
}

final activeRoleProvider =
    NotifierProvider<ActiveRoleNotifier, AppRole>(ActiveRoleNotifier.new);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const JmcNexusApp(),
    ),
  );
}

class JmcNexusApp extends ConsumerStatefulWidget {
  const JmcNexusApp({super.key});

  @override
  ConsumerState<JmcNexusApp> createState() => _JmcNexusAppState();
}

class _JmcNexusAppState extends ConsumerState<JmcNexusApp> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    try {
      final db = ref.read(appDatabaseProvider);
      await db.ensureSeeded();
    } catch (e) {
      debugPrint('Database initialization notice: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeRole = ref.watch(activeRoleProvider);

    Widget homeWidget;
    switch (activeRole) {
      case AppRole.reception:
        homeWidget = ReceptionScreen(
          onSwitchToDoctor: () {
            ref.read(activeRoleProvider.notifier).setRole(AppRole.doctor);
          },
          onSwitchToAdmin: () {
            ref.read(activeRoleProvider.notifier).setRole(AppRole.admin);
          },
        );
        break;
      case AppRole.doctor:
        homeWidget = DoctorWorkspaceScreen(
          onSwitchToReception: () {
            ref.read(activeRoleProvider.notifier).setRole(AppRole.reception);
          },
          onSwitchToAdmin: () {
            ref.read(activeRoleProvider.notifier).setRole(AppRole.admin);
          },
        );
        break;
      case AppRole.admin:
        homeWidget = AdminPanelScreen(
          onSwitchToReception: () {
            ref.read(activeRoleProvider.notifier).setRole(AppRole.reception);
          },
          onSwitchToDoctor: () {
            ref.read(activeRoleProvider.notifier).setRole(AppRole.doctor);
          },
        );
        break;
    }

    return MaterialApp(
      title: 'JMC Nexus - Clinical Rx & Queue',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _isInitialized
          ? homeWidget
          : const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
