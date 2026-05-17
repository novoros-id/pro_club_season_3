import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../logic/goalkeepers_controller.dart';
import '../../../l10n/app_localizations.dart';

class AddEditGoalkeeperScreen extends ConsumerStatefulWidget {
  const AddEditGoalkeeperScreen({super.key});

  @override
  ConsumerState<AddEditGoalkeeperScreen> createState() => _AddEditGoalkeeperScreenState();
}

class _AddEditGoalkeeperScreenState extends ConsumerState<AddEditGoalkeeperScreen> {
  final _formKey = GlobalKey<FormState>();
  String firstName = '';
  String lastName = '';
  String? email;
  DateTime? birthDate;
  String hand = 'right'; // По умолчанию правый

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != birthDate) {
      setState(() {
        birthDate = picked;
      });
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await ref.read(goalkeepersControllerProvider.notifier).addGoalkeeper(
          firstName: firstName,
          lastName: lastName,
          hand: hand,
          email: email,
          birthDate: birthDate,
        );
        if (mounted) context.pop(); // Возвращаемся назад
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const Color darkBg = Color(0xFF121212);
    const Color accentGreen = Color(0xFFBBF246);
    const Color fieldBg = Color(0xFFF2F2F7);
    const Color borderColor = Color(0xFFBBF246);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: darkBg),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'НОВЫЙ ВРАТАРЬ',
          style: const TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkBg,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                label: 'Фамилия',
                hint: 'Иванов',
                onSaved: (v) => lastName = v!,
                validator: (v) => v!.isEmpty ? 'Обязательно' : null,
                fieldBg: fieldBg,
                borderColor: borderColor,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Имя',
                hint: 'Иван',
                onSaved: (v) => firstName = v!,
                validator: (v) => v!.isEmpty ? 'Обязательно' : null,
                fieldBg: fieldBg,
                borderColor: borderColor,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Email (опционально)',
                hint: 'ivan@example.com',
                keyboardType: TextInputType.emailAddress,
                onSaved: (v) => email = v,
                fieldBg: fieldBg,
                borderColor: borderColor,
              ),
              const SizedBox(height: 16),

              // Выбор даты рождения
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    color: fieldBg,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        birthDate == null ? 'Дата рождения' : '${birthDate!.day}.${birthDate!.month}.${birthDate!.year}',
                        style: const TextStyle(fontFamily: 'Lato', fontSize: 16, color: darkBg),
                      ),
                      const Icon(Icons.calendar_today_outlined, color: darkBg),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Выбор хвата
              const Text(
                'ХВАТ',
                style: TextStyle(fontFamily: 'Unbounded', fontSize: 14, color: Color(0xFF9B9EA1)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _HandButton(
                      text: 'ЛЕВЫЙ',
                      icon: Icons.pan_tool_alt_outlined,
                      isSelected: hand == 'left',
                      onTap: () => setState(() => hand = 'left'),
                      accentColor: accentGreen,
                      darkBg: darkBg,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _HandButton(
                      text: 'ПРАВЫЙ',
                      icon: Icons.pan_tool_alt,
                      isSelected: hand == 'right',
                      onTap: () => setState(() => hand = 'right'),
                      accentColor: accentGreen,
                      darkBg: darkBg,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Кнопка сохранения
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBg,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  'СОХРАНИТЬ',
                  style: TextStyle(
                    fontFamily: 'Unbounded',
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required Function(String?) onSaved,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    required Color fieldBg,
    required Color borderColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontFamily: 'Unbounded', fontSize: 14, color: Color(0xFF9B9EA1)),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: fieldBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: const TextStyle(fontFamily: 'Lato', fontSize: 16, color: Color(0xFF121212)),
          onSaved: onSaved,
          validator: validator,
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}

class _HandButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color accentColor;
  final Color darkBg;

  const _HandButton({
    required this.text,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.accentColor,
    required this.darkBg,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? accentColor : const Color(0xFFF2F2F7),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? accentColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: isSelected ? darkBg : const Color(0xFF9B9EA1)),
            const SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Unbounded',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? darkBg : const Color(0xFF9B9EA1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}