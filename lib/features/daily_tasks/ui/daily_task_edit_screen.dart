import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../registration/logic/goalkeepers_controller.dart';
import '../logic/daily_tasks_logic.dart';
import '../models/built_in_daily_task.dart';
import 'daily_tasks_styles.dart';

class DailyTaskEditScreen extends ConsumerStatefulWidget {
  final DailyTask? task;
  const DailyTaskEditScreen({super.key, this.task});
  @override
  ConsumerState<DailyTaskEditScreen> createState() =>
      _DailyTaskEditScreenState();
}

class _DailyTaskEditScreenState extends ConsumerState<DailyTaskEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late bool _enabled;
  late final Goalkeeper? _owner;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _title = widget.task?.title ?? '';
    _description = widget.task?.description ?? '';
    _enabled = widget.task?.isEnabled ?? true;
    _owner = ref.read(currentGoalkeeperProvider);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    final l10n = AppLocalizations.of(context)!;
    if (!_hasValidOwner()) {
      _showOwnerChanged(l10n);
      return;
    }
    _formKey.currentState!.save();
    setState(() => _saving = true);
    try {
      final controller = ref.read(dailyTasksControllerProvider.notifier);
      final description = _description.trim().isEmpty
          ? null
          : _description.trim();
      if (widget.task == null) {
        await controller.createTask(
          title: _title.trim(),
          description: description,
          enabled: _enabled,
          expectedGoalkeeperId: _owner!.id,
        );
      } else {
        await controller.updateTask(
          widget.task!.id,
          title: _title.trim(),
          description: description,
          enabled: _enabled,
          expectedGoalkeeperId: _owner!.id,
        );
      }
      if (mounted) context.pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.dailyTasksSaveError)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.dailyTasksDelete),
            content: Text(l10n.dailyTasksDeleteConfirmation),
            actions: [
              TextButton(
                onPressed: () => context.pop(false),
                style: TextButton.styleFrom(
                  foregroundColor: DailyTasksStyles.dark,
                  textStyle: const TextStyle(
                    fontFamily: 'Unbounded',
                    fontSize: 12,
                  ),
                ),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () => context.pop(true),
                style: DailyTasksStyles.primaryButton,
                child: Text(l10n.delete),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed || !mounted) return;
    if (!_hasValidOwner()) {
      _showOwnerChanged(l10n);
      return;
    }
    try {
      await ref
          .read(dailyTasksControllerProvider.notifier)
          .deleteTask(widget.task!.id, expectedGoalkeeperId: _owner!.id);
      if (mounted) context.pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.dailyTasksSaveError)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final editing = widget.task != null;
    final readOnly = widget.task?.isSystem ?? false;
    ref.watch(currentGoalkeeperProvider);
    final hasValidOwner = _hasValidOwner();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: DailyTasksStyles.dark,
        elevation: 0,
        title: Text(editing ? l10n.dailyTasksEdit : l10n.dailyTasksAdd),
        titleTextStyle: DailyTasksStyles.screenTitle,
      ),
      body: !hasValidOwner
          ? _OwnerChangedMessage(l10n: l10n)
          : SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _OwnerHeader(
                      name: '${_owner!.firstName} ${_owner.lastName}',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: readOnly
                          ? builtInDailyTaskTitle(l10n, widget.task!.systemKey)
                          : _title,
                      readOnly: readOnly,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: DailyTasksStyles.inputDecoration.copyWith(
                        labelText: l10n.dailyTasksTaskTitle,
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? l10n.dailyTasksTitleRequired
                          : null,
                      onSaved: (value) => _title = value ?? '',
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: _description,
                      readOnly: readOnly,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      autocorrect: false,
                      enableSuggestions: false,
                      minLines: 3,
                      maxLines: 6,
                      decoration: DailyTasksStyles.inputDecoration.copyWith(
                        labelText: l10n.dailyTasksDescription,
                      ),
                      onSaved: (value) => _description = value ?? '',
                    ),
                    if (!readOnly)
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          l10n.dailyTasksActive,
                          style: DailyTasksStyles.body,
                        ),
                        value: _enabled,
                        activeThumbColor: DailyTasksStyles.dark,
                        activeTrackColor: DailyTasksStyles.accent,
                        inactiveThumbColor: DailyTasksStyles.secondaryText,
                        inactiveTrackColor: DailyTasksStyles.fieldBackground,
                        onChanged: (value) => setState(() => _enabled = value),
                      ),
                    if (!readOnly) const SizedBox(height: 16),
                    if (!readOnly)
                      FilledButton(
                        onPressed: _saving ? null : _save,
                        style: DailyTasksStyles.primaryButton,
                        child: _saving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: DailyTasksStyles.accent,
                                ),
                              )
                            : Text(l10n.save),
                      ),
                    TextButton(
                      onPressed: _saving ? null : () => context.pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: DailyTasksStyles.dark,
                        textStyle: const TextStyle(
                          fontFamily: 'Unbounded',
                          fontSize: 12,
                        ),
                      ),
                      child: Text(l10n.cancel),
                    ),
                    if (editing && !readOnly)
                      TextButton(
                        onPressed: _saving ? null : _delete,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          textStyle: const TextStyle(
                            fontFamily: 'Unbounded',
                            fontSize: 12,
                          ),
                        ),
                        child: Text(l10n.delete),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  bool _hasValidOwner() {
    final owner = _owner;
    final current = ref.read(currentGoalkeeperProvider);
    return owner != null &&
        current?.id == owner.id &&
        (widget.task == null || widget.task!.goalkeeperId == owner.id);
  }

  void _showOwnerChanged(AppLocalizations l10n) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.dailyTasksGoalkeeperChanged)));
  }
}

class _OwnerHeader extends StatelessWidget {
  final String name;
  const _OwnerHeader({required this.name});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: DailyTasksStyles.fieldBackground,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: DailyTasksStyles.accent.withValues(alpha: 0.3),
          child: Text(
            name
                .split(' ')
                .where((part) => part.isNotEmpty)
                .take(2)
                .map((part) => part[0])
                .join(),
            style: DailyTasksStyles.body,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            AppLocalizations.of(context)!.dailyTasksOwner(name),
            style: DailyTasksStyles.body,
          ),
        ),
      ],
    ),
  );
}

class _OwnerChangedMessage extends StatelessWidget {
  final AppLocalizations l10n;
  const _OwnerChangedMessage({required this.l10n});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.dailyTasksGoalkeeperChanged,
            textAlign: TextAlign.center,
            style: DailyTasksStyles.body,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.pop(),
            style: DailyTasksStyles.primaryButton,
            child: Text(l10n.dailyTasksReturnToList),
          ),
        ],
      ),
    ),
  );
}
