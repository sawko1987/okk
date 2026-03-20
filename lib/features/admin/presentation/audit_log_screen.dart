import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/admin_repositories.dart';

class AuditLogScreen extends ConsumerWidget {
  const AuditLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(auditEntriesProvider);

    return entriesAsync.when(
      data: (entries) => ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Журнал действий',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          if (entries.isEmpty)
            const Text('Записей в журнале пока нет.')
          else
            for (final entry in entries)
              Card(
                child: ListTile(
                  title: Text(_actionLabel(entry.entry.actionType)),
                  subtitle: Text(
                    '${entry.entry.happenedAt}\n'
                    'Сущность: ${entry.entry.entityType ?? '-'} ${entry.entry.entityId ?? '-'}\n'
                    'Пользователь: ${entry.userName ?? '-'}\n'
                    'Комментарий: ${entry.entry.message ?? '-'}',
                  ),
                  isThreeLine: true,
                  trailing: Text(_resultLabel(entry.entry.resultStatus)),
                ),
              ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          Center(child: Text('Не удалось загрузить журнал действий: $error')),
    );
  }
}

String _actionLabel(String value) {
  return switch (value) {
    'user.create' => 'Создание пользователя',
    'user.update' => 'Изменение пользователя',
    'user.delete' => 'Удаление пользователя',
    'trash.restore' => 'Восстановление из корзины',
    'reference_package.export' => 'Экспорт пакета справочников',
    'sync.run.start' => 'Запуск синхронизации',
    'sync.run.finish' => 'Завершение синхронизации',
    'sync.retry.run' => 'Повторная синхронизация',
    'sync.lock.acquire' => 'Установка блокировки',
    'sync.lock.release' => 'Снятие блокировки',
    'sync.result.conflict' => 'Конфликт синхронизации',
    'inspection.start' => 'Старт проверки',
    'inspection.complete' => 'Завершение проверки',
    'inspection.signature.add' => 'Добавление подписи',
    'inspection.pdf.generate' => 'Создание PDF',
    'department.create' => 'Создание подразделения',
    'department.update' => 'Изменение подразделения',
    'department.delete' => 'Удаление подразделения',
    'workshop.create' => 'Создание цеха',
    'workshop.update' => 'Изменение цеха',
    'workshop.delete' => 'Удаление цеха',
    'section.create' => 'Создание участка',
    'section.update' => 'Изменение участка',
    'section.delete' => 'Удаление участка',
    'object.create' => 'Создание объекта',
    'object.update' => 'Изменение объекта',
    'object.delete' => 'Удаление объекта',
    'component.create' => 'Создание компонента',
    'component.update' => 'Изменение компонента',
    'component.delete' => 'Удаление компонента',
    'component_image.import' => 'Импорт изображений компонента',
    'component_image.delete' => 'Удаление изображения компонента',
    'checklist.create' => 'Создание чек-листа',
    'checklist.update' => 'Изменение чек-листа',
    'checklist.delete' => 'Удаление чек-листа',
    'checklist_item.create' => 'Создание пункта чек-листа',
    'checklist_item.update' => 'Изменение пункта чек-листа',
    'checklist_item.delete' => 'Удаление пункта чек-листа',
    'checklist_binding.create' => 'Создание привязки чек-листа',
    'checklist_binding.update' => 'Изменение привязки чек-листа',
    'checklist_binding.delete' => 'Удаление привязки чек-листа',
    _ => value,
  };
}

String _resultLabel(String value) {
  return switch (value) {
    'success' => 'Успешно',
    'pending' => 'В процессе',
    'partial' => 'Частично',
    'error' => 'Ошибка',
    'conflict' => 'Конфликт',
    'noop' => 'Без изменений',
    _ => value,
  };
}
