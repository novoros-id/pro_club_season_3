import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../logic/daily_tasks_logic.dart';
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
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _title = widget.task?.title ?? '';
    _description = widget.task?.description ?? '';
    _enabled = widget.task?.isEnabled ?? true;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    _formKey.currentState!.save();
    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context)!;
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
        );
      } else {
        await controller.updateTask(
          widget.task!.id,
          title: _title.trim(),
          description: description,
          enabled: _enabled,
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
    try {
      await ref
          .read(dailyTasksControllerProvider.notifier)
          .deleteTask(widget.task!.id);
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: DailyTasksStyles.dark,
        elevation: 0,
        title: Text(editing ? l10n.dailyTasksEdit : l10n.dailyTasksAdd),
        titleTextStyle: DailyTasksStyles.screenTitle,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                initialValue: _title,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                enableSuggestions: false,
                decoration: DailyTasksStyles.inputDecoration.copyWith(
                  labelText: l10n.dailyTasksTaskTitle,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? l10n.dailyTasksTitleRequired
                    : null,
                onSaved: (value) => _title = value ?? '',
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _description,
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
              const SizedBox(height: 16),
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
              if (editing)
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
}
