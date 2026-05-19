import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../logic/goalkeepers_controller.dart';
import 'widgets/goalkeeper_card.dart';
import 'onboarding_screen.dart';
import '../../../l10n/app_localizations.dart';

class RegistrationScreen extends ConsumerWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keepers = ref.watch(goalkeepersControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    // Если список пуст, показываем экран приветствия
    if (keepers.isEmpty) {
      return const OnboardingScreen();
    }

    // Иначе показываем список
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'ВРАТАРИ',
          style: const TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF121212),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: keepers.length,
        itemBuilder: (context, index) {
          final keeper = keepers[index];
          return GoalkeeperCard(
            keeper: keeper,
            isCurrent: keeper.isCurrent,
            onMakeCurrent: () => ref.read(goalkeepersControllerProvider.notifier).makeCurrent(keeper.id),
            onDelete: () => _confirmDelete(context, ref, keeper.id, keeper.isCurrent, '${keeper.lastName} ${keeper.firstName}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-goalkeeper'),
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'ДОБАВИТЬ',
          style: TextStyle(fontFamily: 'Unbounded', fontWeight: FontWeight.bold),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, int id, bool isCurrent, String name) {
    if (isCurrent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Сначала выберите другого текущего вратаря!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Удалить вратаря?', style: TextStyle(fontFamily: 'Unbounded')),
        content: Text('Вы уверены, что хотите удалить $name? Вся статистика будет потеряна.', style: const TextStyle(fontFamily: 'Lato')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          TextButton(
            onPressed: () {
              ref.read(goalkeepersControllerProvider.notifier).deleteGoalkeeper(id, isCurrent);
              Navigator.pop(ctx);
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}