String userMessageFromError(
  Object error, {
  String fallback = 'Не удалось выполнить действие.',
}) {
  return userMessageFromText(error.toString(), fallback: fallback);
}

String userMessageFromText(
  String? message, {
  String fallback = 'Не удалось выполнить действие.',
}) {
  var normalized = (message ?? '').trim();
  if (normalized.isEmpty) {
    return fallback;
  }

  const prefixes = <String>[
    'StateError: Bad state: ',
    'Bad state: ',
    'StateError: ',
    'Exception: ',
    'SyncTransportException: ',
  ];
  for (final prefix in prefixes) {
    if (normalized.startsWith(prefix)) {
      normalized = normalized.substring(prefix.length).trim();
      break;
    }
  }

  const exactMessages = <String, String>{
    'Selected user is unavailable.': 'Выбранный пользователь недоступен.',
    'Invalid PIN.': 'Неверный PIN-код.',
    'Inspection draft not found.': 'Черновик проверки не найден.',
    'Inspection answer not found.': 'Ответ по пункту проверки не найден.',
    'Inspection not found.': 'Проверка не найдена.',
    'Signature not found.': 'Подпись не найдена.',
    'Selected product is unavailable.': 'Выбранное изделие недоступно.',
    'Selected inspection target is unavailable.':
        'Выбранный объект проверки недоступен.',
    'Selected target does not belong to the selected product.':
        'Выбранный объект проверки не относится к выбранному изделию.',
    'No checklist is assigned to the selected target.':
        'Для выбранного объекта проверки не назначен чек-лист.',
    'Signer name and role are required.': 'Укажите ФИО и роль подписанта.',
    'Signature image is empty.':
        'Подпись не сохранена. Повторите ввод подписи.',
    'Complete all required checklist items before finishing the inspection.':
        'Перед завершением проверки заполните все обязательные пункты.',
    'At least one signature is required before completion.':
        'Перед завершением проверки нужна хотя бы одна подпись.',
    'Completed inspections are read-only.':
        'Завершённые проверки доступны только для просмотра.',
    'User created': 'Пользователь создан.',
    'User updated': 'Пользователь обновлен.',
    'User moved to trash': 'Пользователь перемещен в корзину.',
    'Component images imported': 'Изображения компонента импортированы.',
    'Component image moved to trash':
        'Изображение компонента перемещено в корзину.',
    'Entity restored from trash': 'Запись восстановлена из корзины.',
    'Reference package exported to local sync/outgoing':
        'Пакет справочников экспортирован в локальную очередь синхронизации.',
  };
  final mapped = exactMessages[normalized];
  if (mapped != null) {
    return mapped;
  }

  if (normalized.startsWith('Source file does not exist: ')) {
    return 'Не удалось найти исходный файл для импорта.';
  }

  if (normalized.startsWith('Source directory does not exist: ')) {
    return 'Не удалось найти локальный каталог с данными.';
  }

  if (normalized.startsWith('Archive does not exist: ')) {
    return 'Не удалось найти архив.';
  }

  if (normalized.startsWith('Restore is not supported for ')) {
    return 'Восстановление для этого типа записи пока не поддерживается.';
  }

  if (normalized.startsWith('SocketException') ||
      normalized.startsWith('HttpException') ||
      normalized.startsWith('HandshakeException') ||
      normalized.contains('Connection reset') ||
      normalized.contains('Connection refused') ||
      normalized.contains('Failed host lookup')) {
    return 'Не удалось подключиться к Яндекс.Диску. Проверьте сеть и токен.';
  }

  if (normalized.startsWith('PathAccessException') ||
      normalized.startsWith('FileSystemException')) {
    return 'Не удалось получить доступ к локальным файлам.';
  }

  if (normalized.startsWith('FormatException')) {
    return 'Получены повреждённые или неверные данные.';
  }

  final hasCyrillic = RegExp(r'[А-Яа-яЁё]').hasMatch(normalized);
  final hasLatin = RegExp(r'[A-Za-z]').hasMatch(normalized);
  if (!hasCyrillic && hasLatin) {
    return fallback;
  }

  return normalized;
}
