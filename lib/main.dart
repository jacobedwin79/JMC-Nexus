import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/database_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/encounter/presentation/doctor_workspace_screen.dart';
import 'features/reception/presentation/reception_screen.dart';

enum AppRole {
  reception,
  doctor,
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
  runApp(const ProviderScope(child: JmcNexusApp()));
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
    final db = ref.read(appDatabaseProvider);
    await db.ensureSeeded();
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeRole = ref.watch(activeRoleProvider);

    return MaterialApp(
      title: 'JMC Nexus - Clinical Rx & Queue',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _isInitialized
          ? (activeRole == AppRole.reception
              ? ReceptionScreen(
                  onSwitchToDoctor: () {
                    ref.read(activeRoleProvider.notifier).setRole(AppRole.doctor);
                  },
                )
              : DoctorWorkspaceScreen(
                  onSwitchToReception: () {
                    ref.read(activeRoleProvider.notifier).setRole(AppRole.reception);
                  },
                ))
          : const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
