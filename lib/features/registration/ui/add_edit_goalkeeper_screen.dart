import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../logic/goalkeepers_controller.dart';

const Color _darkBg = Color(0xFF121A1F);
const Color _accentGreen = Color(0xFFBBF246);
const Color _fieldBg = Color(0xFFF2F2F7);
const Color _borderGrey = Color(0xFFD8DADF);
const Color _greyText = Color(0xFF9B9EA1);
const Color _errorColor = Colors.redAccent;

class AddEditGoalkeeperScreen extends ConsumerStatefulWidget {
  const AddEditGoalkeeperScreen({super.key});

  @override
  ConsumerState<AddEditGoalkeeperScreen> createState() =>
      _AddEditGoalkeeperScreenState();
}

class _AddEditGoalkeeperScreenState
    extends ConsumerState<AddEditGoalkeeperScreen> {
  final _formKey = GlobalKey<FormState>();

  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _emailController = TextEditingController();

  final _lastNameFocus = FocusNode();
  final _firstNameFocus = FocusNode();
  final _emailFocus = FocusNode();

  bool _isButtonPressed = false;

  String firstName = '';
  String lastName = '';
  String? email;
  DateTime? birthDate;
  String hand = 'right';

  String? _lastNameError;
  String? _firstNameError;

  @override
  void initState() {
    super.initState();

    _lastNameController.addListener(_updateFields);
    _firstNameController.addListener(_updateFields);
    _emailController.addListener(_updateFields);

    _lastNameFocus.addListener(_updateFields);
    _firstNameFocus.addListener(_updateFields);
    _emailFocus.addListener(_updateFields);
  }

  void _updateFields() {
    if (!mounted) return;

    setState(() {
      if (_lastNameController.text.trim().isNotEmpty) {
        _lastNameError = null;
      }

      if (_firstNameController.text.trim().isNotEmpty) {
        _firstNameError = null;
      }
    });
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();

    _lastNameFocus.dispose();
    _firstNameFocus.dispose();
    _emailFocus.dispose();

    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDate ??
          DateTime.now().subtract(
            const Duration(days: 365 * 10),
          ),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      locale: const Locale('ru', 'RU'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _accentGreen,
              onPrimary: _darkBg,
              surface: Colors.white,
              onSurface: _darkBg,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,
              headerBackgroundColor: Colors.white,
              headerForegroundColor: _darkBg,
              todayForegroundColor:
              const WidgetStatePropertyAll<Color>(_darkBg),
              todayBackgroundColor:
              const WidgetStatePropertyAll<Color>(
                Color(0x33BBF246),
              ),
              todayBorder: BorderSide.none,
              headerHeadlineStyle: const TextStyle(
                fontFamily: 'Unbounded',
                fontSize: 18,
                height: 1.2,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
              ),
              cancelButtonStyle: const ButtonStyle(
                minimumSize: WidgetStatePropertyAll<Size>(
                  Size(0, 38),
                ),
                padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                backgroundColor: WidgetStatePropertyAll<Color>(
                  Colors.transparent,
                ),
                foregroundColor: WidgetStatePropertyAll<Color>(
                  _greyText,
                ),
                overlayColor: WidgetStatePropertyAll<Color>(
                  Color(0x0D121A1F),
                ),
                textStyle: WidgetStatePropertyAll<TextStyle>(
                  TextStyle(
                    fontFamily: 'Unbounded',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              confirmButtonStyle: ButtonStyle(
                minimumSize: const WidgetStatePropertyAll<Size>(
                  Size(0, 38),
                ),
                padding:
                const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                shape:
                const WidgetStatePropertyAll<OutlinedBorder>(
                  StadiumBorder(),
                ),
                elevation: const WidgetStatePropertyAll<double>(0),
                overlayColor:
                const WidgetStatePropertyAll<Color>(
                  _accentGreen,
                ),
                textStyle:
                const WidgetStatePropertyAll<TextStyle>(
                  TextStyle(
                    fontFamily: 'Unbounded',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                backgroundColor:
                WidgetStateProperty.resolveWith<Color?>(
                      (states) {
                    if (states.contains(WidgetState.disabled)) {
                      return const Color(0xFFE3E4E8);
                    }

                    if (states.contains(WidgetState.pressed) ||
                        states.contains(WidgetState.focused)) {
                      return _accentGreen;
                    }

                    return _darkBg;
                  },
                ),
                foregroundColor:
                WidgetStateProperty.resolveWith<Color?>(
                      (states) {
                    if (states.contains(WidgetState.disabled)) {
                      return _greyText;
                    }

                    if (states.contains(WidgetState.pressed) ||
                        states.contains(WidgetState.focused)) {
                      return _darkBg;
                    }

                    return Colors.white;
                  },
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationThemeData(
              isDense: true,
              filled: true,
              fillColor: _fieldBg,
              constraints: const BoxConstraints(
                minHeight: 56,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 13,
              ),
              labelStyle: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 14,
                color: _greyText,
              ),
              floatingLabelStyle: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 14,
                color: _greyText,
              ),
              hintStyle: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 16,
                color: _greyText,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: _borderGrey,
                  width: 1.4,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: _borderGrey,
                  width: 1.4,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: _accentGreen,
                  width: 2,
                ),
              ),
            ),
            textTheme: const TextTheme(
              headlineSmall: TextStyle(
                fontFamily: 'Unbounded',
                fontWeight: FontWeight.bold,
                color: _darkBg,
              ),
              bodyLarge: TextStyle(
                fontFamily: 'Lato',
                color: _darkBg,
              ),
              labelLarge: TextStyle(
                fontFamily: 'Unbounded',
                fontWeight: FontWeight.bold,
                color: _darkBg,
              ),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != birthDate) {
      setState(() {
        birthDate = picked;
      });
    }
  }

  Future<bool> _save() async {
    FocusScope.of(context).unfocus();

    final formState = _formKey.currentState;

    if (formState == null) {
      return false;
    }

    final String lastNameValue =
    _lastNameController.text.trim();
    final String firstNameValue =
    _firstNameController.text.trim();

    setState(() {
      _lastNameError =
      lastNameValue.isEmpty ? 'Обязательно' : null;

      _firstNameError =
      firstNameValue.isEmpty ? 'Обязательно' : null;
    });

    if (_lastNameError != null || _firstNameError != null) {
      return false;
    }

    formState.save();

    try {
      await ref
          .read(goalkeepersControllerProvider.notifier)
          .addGoalkeeper(
        firstName: firstName,
        lastName: lastName,
        hand: hand,
        email: email,
        birthDate: birthDate,
      );

      if (!mounted) {
        return true;
      }

      context.go('/');
      return true;
    } catch (e) {
      if (!mounted) {
        return false;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $e'),
        ),
      );

      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: _darkBg,
          selectionColor: Color(0x55BBF246),
          selectionHandleColor: _accentGreen,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: _darkBg,
            ),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/onboarding');
              }
            },
          ),
          title: const Text(
            'НОВЫЙ ВРАТАРЬ',
            style: TextStyle(
              fontFamily: 'Unbounded',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _darkBg,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 14),

                _buildTextField(
                  label: 'Фамилия',
                  hint: 'Иванов',
                  controller: _lastNameController,
                  focusNode: _lastNameFocus,
                  errorText: _lastNameError,
                  onSaved: (value) {
                    lastName = value?.trim() ?? '';
                  },
                ),

                _buildTextField(
                  label: 'Имя',
                  hint: 'Иван',
                  controller: _firstNameController,
                  focusNode: _firstNameFocus,
                  errorText: _firstNameError,
                  onSaved: (value) {
                    firstName = value?.trim() ?? '';
                  },
                ),

                _buildTextField(
                  label: 'Email (опционально)',
                  hint: 'ivan@example.com',
                  controller: _emailController,
                  focusNode: _emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) {
                    final trimmedValue = value?.trim();

                    email = trimmedValue == null ||
                        trimmedValue.isEmpty
                        ? null
                        : trimmedValue;
                  },
                ),

                _DateField(
                  birthDate: birthDate,
                  onTap: () => _selectDate(context),
                  isActive: birthDate != null,
                ),

                const SizedBox(height: 18),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ХВАТ',
                    style: TextStyle(
                      fontFamily: 'Unbounded',
                      fontSize: 13,
                      color: _greyText,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _HandButton(
                        text: 'ЛЕВЫЙ',
                        iconAsset: 'assets/images/catch_left.svg',
                        isSelected: hand == 'left',
                        onTap: () {
                          setState(() {
                            hand = 'left';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _HandButton(
                        text: 'ПРАВЫЙ',
                        iconAsset: 'assets/images/catch_right.svg',
                        isSelected: hand == 'right',
                        onTap: () {
                          setState(() {
                            hand = 'right';
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                const _LoadingDecoration(),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _isButtonPressed = true;
                      });
                    },
                    onTapCancel: () {
                      setState(() {
                        _isButtonPressed = false;
                      });
                    },
                    onTap: () async {
                      final bool isSaved = await _save();

                      if (!mounted || isSaved) {
                        return;
                      }

                      setState(() {
                        _isButtonPressed = false;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      curve: Curves.easeOut,
                      decoration: BoxDecoration(
                        color: _isButtonPressed
                            ? _accentGreen
                            : _darkBg,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Center(
                        child: _ButtonText(
                          text: 'Зарегистрироваться',
                          textColor: _isButtonPressed
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 28 +
                      MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required FocusNode focusNode,
    required FormFieldSetter<String> onSaved,
    String? errorText,
    TextInputType? keyboardType,
  }) {
    final bool isActive =
        focusNode.hasFocus || controller.text.trim().isNotEmpty;

    final bool hasError =
        errorText != null && errorText.isNotEmpty;

    final Color currentBorderColor = hasError
        ? _errorColor
        : isActive
        ? _accentGreen
        : _borderGrey;

    final double borderWidth = hasError || isActive ? 2 : 1.4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 13,
            color: _greyText,
          ),
        ),

        const SizedBox(height: 6),

        SizedBox(
          height: 56,
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            onSaved: onSaved,
            cursorColor: _darkBg,
            style: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 16,
              color: Color(0xFF121212),
            ),
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: _fieldBg,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 17,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: currentBorderColor,
                  width: borderWidth,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: currentBorderColor,
                  width: borderWidth,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: currentBorderColor,
                  width: borderWidth,
                ),
              ),
            ),
          ),
        ),

        SizedBox(
          height: 13,
          child: Align(
            alignment: Alignment.centerLeft,
            child: hasError
                ? Text(
              errorText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 10,
                height: 1,
                color: _errorColor,
              ),
            )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  final DateTime? birthDate;
  final VoidCallback onTap;
  final bool isActive;

  const _DateField({
    required this.birthDate,
    required this.onTap,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor =
    isActive ? _accentGreen : _borderGrey;

    String dateText = 'Дата рождения';

    if (birthDate != null) {
      dateText =
      '${birthDate!.day.toString().padLeft(2, '0')}.'
          '${birthDate!.month.toString().padLeft(2, '0')}.'
          '${birthDate!.year}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Дата рождения',
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 13,
            color: _greyText,
          ),
        ),

        const SizedBox(height: 6),

        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: _fieldBg,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: borderColor,
                width: isActive ? 2 : 1.4,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateText,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16,
                    color: _darkBg,
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  color: _darkBg,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HandButton extends StatelessWidget {
  final String text;
  final String iconAsset;
  final bool isSelected;
  final VoidCallback onTap;

  const _HandButton({
    required this.text,
    required this.iconAsset,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 94,
        decoration: BoxDecoration(
          color: isSelected ? _accentGreen : _fieldBg,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? _accentGreen : _borderGrey,
            width: isSelected ? 2 : 1.4,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconAsset,
              width: 34,
              height: 34,
              colorFilter: ColorFilter.mode(
                isSelected ? _darkBg : _greyText,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Unbounded',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? _darkBg : _greyText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingDecoration extends StatefulWidget {
  const _LoadingDecoration();

  @override
  State<_LoadingDecoration> createState() =>
      _LoadingDecorationState();
}

class _LoadingDecorationState
    extends State<_LoadingDecoration> {
  Alignment _progressAlignment = Alignment.centerLeft;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      setState(() {
        _progressAlignment = Alignment.centerRight;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 70,
        height: 9,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: _darkBg,
          borderRadius: BorderRadius.circular(15),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOutCubic,
          alignment: _progressAlignment,
          child: Container(
            width: 35,
            height: 4,
            decoration: BoxDecoration(
              color: _accentGreen,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonText extends StatelessWidget {
  final String text;
  final Color textColor;

  const _ButtonText({
    required this.text,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Unbounded',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }
}