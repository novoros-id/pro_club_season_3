import 'package:flutter/material.dart';
// ✅ ИМПОРТИРУЕМ МОДЕЛЬ ИЗ БАЗЫ ДАННЫХ, А НЕ ОТДЕЛЬНЫЙ ФАЙЛ
import '../../../../core/database/app_database.dart';

class GoalkeeperCard extends StatelessWidget {
  final Goalkeeper keeper; // ✅ Используем строгий тип Goalkeeper вместо dynamic
  final VoidCallback onMakeCurrent;
  final VoidCallback onDelete;
  final bool isCurrent;

  const GoalkeeperCard({
    super.key,
    required this.keeper,
    required this.onMakeCurrent,
    required this.onDelete,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    // Цвета из гайда
    const accentColor = Color(0xFFBBF246);
    const textColor = Color(0xFF121212);
    const secondaryText = Color(0xFF9B9EA1);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            // ✅ ИСПРАВЛЕНО: withOpacity заменен на withValues
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Аватар с инициалами
          CircleAvatar(
            radius: 24,
            // ✅ ИСПРАВЛЕНО: withOpacity заменен на withValues
            backgroundColor: accentColor.withValues(alpha: 0.2),
            child: Text(
              '${keeper.firstName[0]}${keeper.lastName[0]}',
              style: const TextStyle(
                fontFamily: 'Unbounded',
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Информация
          Expanded(
            child: Column( // ✅ Здесь Column из Flutter, так как мы не импортировали drift/dsl напрямую в UI
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${keeper.lastName} ${keeper.firstName}',
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      keeper.hand == 'left' ? Icons.pan_tool_alt_outlined : Icons.pan_tool_alt,
                      size: 14,
                      color: secondaryText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      keeper.hand == 'left' ? 'Левый хват' : 'Правый хват',
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                        color: secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Кнопки действий
          if (isCurrent)
            const Icon(Icons.star, color: accentColor, size: 28)
          else
            IconButton(
              icon: const Icon(Icons.star_border, color: secondaryText),
              onPressed: onMakeCurrent,
            ),

          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: isCurrent ? null : onDelete, // Блокируем удаление текущего
          ),
        ],
      ),
    );
  }
}