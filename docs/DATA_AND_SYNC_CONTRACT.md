# Контракт данных и синхронизации

Последнее обновление: 2026-03-16

## 1. Общие правила данных

- идентификаторы сущностей: UUID в поле `id`;
- даты и время: ISO 8601 UTC string;
- мягкое удаление: `is_deleted` + `deleted_at`;
- версионирование записи: `version INTEGER NOT NULL`;
- обязательные технические поля syncable-сущностей: `id`, `version`, `created_at`, `updated_at`, `deleted_at`, `is_deleted`.

Значения перечислений фиксируются строками, а не числами, чтобы упростить JSON-обмен и диагностику.

## 2. Таблицы SQLite

### `roles`

Назначение: справочник ролей.

Поля:

- `id TEXT PRIMARY KEY`
- `code TEXT NOT NULL UNIQUE` со значениями `administrator`, `worker`, `commission`, `viewer`
- `name TEXT NOT NULL`
- `description TEXT NULL`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`

### `users`

Назначение: локальные пользователи, назначаемые Windows.

Поля:

- `id TEXT PRIMARY KEY`
- `full_name TEXT NOT NULL`
- `short_name TEXT NULL`
- `role_id TEXT NOT NULL`
- `pin_hash TEXT NULL`
- `is_active INTEGER NOT NULL DEFAULT 1`
- `last_login_at TEXT NULL`
- `version INTEGER NOT NULL`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`
- `deleted_at TEXT NULL`
- `is_deleted INTEGER NOT NULL DEFAULT 0`

Индексы:

- `idx_users_role_id`
- `idx_users_active`

### `departments`

Назначение: верхний уровень структуры предприятия.

Поля:

- `id TEXT PRIMARY KEY`
- `name TEXT NOT NULL`
- `code TEXT NULL`
- `sort_order INTEGER NOT NULL DEFAULT 0`
- `version INTEGER NOT NULL`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`
- `deleted_at TEXT NULL`
- `is_deleted INTEGER NOT NULL DEFAULT 0`

### `workshops`

Назначение: цех внутри подразделения.

Поля:

- `id TEXT PRIMARY KEY`
- `department_id TEXT NOT NULL`
- `name TEXT NOT NULL`
- `code TEXT NULL`
- `sort_order INTEGER NOT NULL DEFAULT 0`
- `version INTEGER NOT NULL`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`
- `deleted_at TEXT NULL`
- `is_deleted INTEGER NOT NULL DEFAULT 0`

Индексы:

- `idx_workshops_department_id`

### `sections`

Назначение: участок внутри цеха.

Поля:

- `id TEXT PRIMARY KEY`
- `workshop_id TEXT NOT NULL`
- `name TEXT NOT NULL`
- `code TEXT NULL`
- `sort_order INTEGER NOT NULL DEFAULT 0`
- `version INTEGER NOT NULL`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`
- `deleted_at TEXT NULL`
- `is_deleted INTEGER NOT NULL DEFAULT 0`

Индексы:

- `idx_sections_workshop_id`

### `objects`

Назначение: универсальная сущность продукта и объекта проверки.

Поля:

- `id TEXT PRIMARY KEY`
- `type TEXT NOT NULL` со значениями `product`, `machine`, `place`, `node`, `detail`
- `section_id TEXT NULL`
- `parent_id TEXT NULL`
- `name TEXT NOT NULL`
- `code TEXT NULL`
- `description TEXT NULL`
- `sort_order INTEGER NOT NULL DEFAULT 0`
- `is_active INTEGER NOT NULL DEFAULT 1`
- `version INTEGER NOT NULL`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`
- `deleted_at TEXT NULL`
- `is_deleted INTEGER NOT NULL DEFAULT 0`

Индексы:

- `idx_objects_section_id`
- `idx_objects_parent_id`
- `idx_objects_type`

### `object_relations`

Назначение: явные связи дерева и экспортируемый порядок детей.

Поля:

- `id TEXT PRIMARY KEY`
- `parent_object_id TEXT NOT NULL`
- `child_object_id TEXT NOT NULL`
- `relation_type TEXT NOT NULL DEFAULT 'contains'`
- `sort_order INTEGER NOT NULL DEFAULT 0`
- `version INTEGER NOT NULL`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`
- `deleted_at TEXT NULL`
- `is_deleted INTEGER NOT NULL DEFAULT 0`

Индексы:

- `idx_object_relations_parent`
- `idx_object_relations_child`
- уникальный индекс `ux_object_relations_pair`

### `components`

Назначение: физические компоненты объекта проверки.

Поля:

- `id TEXT PRIMARY KEY`
- `object_id TEXT NOT NULL`
- `name TEXT NOT NULL`
- `code TEXT NULL`
- `description TEXT NULL`
- `sort_order INTEGER NOT NULL DEFAULT 0`
- `is_required INTEGER NOT NULL DEFAULT 1`
- `version INTEGER NOT NULL`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`
- `deleted_at TEXT NULL`
- `is_deleted INTEGER NOT NULL DEFAULT 0`

Индексы:

- `idx_components_object_id`

### `component_images`

Назначение: изображения компонента и их локальные пути.

Поля:

- `id TEXT PRIMARY KEY`
- `component_id TEXT NOT NULL`
- `file_name TEXT NOT NULL`
- `media_key TEXT NOT NULL`
- `local_path TEXT NULL`
- `remote_path TEXT NULL`
- `checksum TEXT NOT NULL`
- `mime_type TEXT NOT NULL`
- `sort_order INTEGER NOT NULL DEFAULT 0`
- `width INTEGER NULL`
- `height INTEGER NULL`
- `version INTEGER NOT NULL`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`
- `deleted_at TEXT NULL`
- `is_deleted INTEGER NOT NULL DEFAULT 0`

Индексы:

- `idx_component_images_component_id`
- `ux_component_images_media_key`

### `checklists`

Назначение: шаблоны чек-листов.

Поля:

- `id TEXT PRIMARY KEY`
- `name TEXT NOT NULL`
- `description TEXT NULL`
- `is_active INTEGER NOT NULL DEFAULT 1`
- `version INTEGER NOT NULL`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`
- `deleted_at TEXT NULL`
- `is_deleted INTEGER NOT NULL DEFAULT 0`

### `checklist_items`

Назначение: пункты чек-листа.

Поля:

- `id TEXT PRIMARY KEY`
- `checklist_id TEXT NOT NULL`
- `component_id TEXT NULL`
- `title TEXT NOT NULL`
- `description TEXT NULL`
- `expected_result TEXT NULL`
- `result_type TEXT NOT NULL DEFAULT 'pass_fail_na'`
- `is_required INTEGER NOT NULL DEFAULT 1`
- `sort_order INTEGER NOT NULL DEFAULT 0`
- `version INTEGER NOT NULL`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`
- `deleted_at TEXT NULL`
- `is_deleted INTEGER NOT NULL DEFAULT 0`

Индексы:

- `idx_checklist_items_checklist_id`
- `idx_checklist_items_component_id`

### `checklist_bindings`

Назначение: привязка чек-листа к объекту или типу объекта.

Поля:

- `id TEXT PRIMARY KEY`
- `checklist_id TEXT NOT NULL`
- `target_type TEXT NOT NULL` со значениями `object`, `object_type`, `product`
- `target_id TEXT NULL`
- `target_object_type TEXT NULL`
- `priority INTEGER NOT NULL DEFAULT 0`
- `is_required INTEGER NOT NULL DEFAULT 1`
- `version INTEGER NOT NULL`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`
- `deleted_at TEXT NULL`
- `is_deleted INTEGER NOT NULL DEFAULT 0`

Индексы:

- `idx_checklist_bindings_checklist_id`
- `idx_checklist_bindings_target`

### `inspections`

Назначение: экземпляр проверки на Android и ее импортированное представление на Windows.

Поля:

- `id TEXT PRIMARY KEY`
- `device_id TEXT NOT NULL`
- `user_id TEXT NOT NULL`
- `product_object_id TEXT NOT NULL`
- `target_object_id TEXT NOT NULL`
- `started_at TEXT NOT NULL`
- `completed_at TEXT NULL`
- `status TEXT NOT NULL` со значениями `draft`, `in_progress`, `completed`, `queued`, `synced`, `conflict`
- `sync_status TEXT NOT NULL` со значениями `local_only`, `queued`, `uploaded`, `imported`, `conflict`
- `source_reference_package_id TEXT NULL`
- `source_reference_version TEXT NULL`
- `pdf_local_path TEXT NULL`
- `pdf_checksum TEXT NULL`
- `conflict_reason TEXT NULL`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`

Индексы:

- `idx_inspections_device_id`
- `idx_inspections_user_id`
- `idx_inspections_target_object_id`
- `idx_inspections_status`

### `inspection_items`

Назначение: результаты по пунктам проверки.

Поля:

- `id TEXT PRIMARY KEY`
- `inspection_id TEXT NOT NULL`
- `checklist_item_id TEXT NOT NULL`
- `component_id TEXT NULL`
- `result_status TEXT NOT NULL` со значениями `pass`, `fail`, `na`, `not_checked`
- `comment TEXT NULL`
- `measured_value TEXT NULL`
- `sort_order INTEGER NOT NULL DEFAULT 0`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`

Индексы:

- `idx_inspection_items_inspection_id`
- `idx_inspection_items_checklist_item_id`

### `inspection_signatures`

Назначение: подписи участников проверки.

Поля:

- `id TEXT PRIMARY KEY`
- `inspection_id TEXT NOT NULL`
- `signer_user_id TEXT NULL`
- `signer_name TEXT NOT NULL`
- `signer_role TEXT NOT NULL`
- `image_local_path TEXT NOT NULL`
- `checksum TEXT NOT NULL`
- `signed_at TEXT NOT NULL`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`

Индексы:

- `idx_inspection_signatures_inspection_id`

### `inspection_files`

Назначение: файлы результата проверки.

Поля:

- `id TEXT PRIMARY KEY`
- `inspection_id TEXT NOT NULL`
- `file_type TEXT NOT NULL` со значениями `pdf`, `attachment`
- `file_name TEXT NOT NULL`
- `local_path TEXT NOT NULL`
- `checksum TEXT NOT NULL`
- `mime_type TEXT NOT NULL`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`

Индексы:

- `idx_inspection_files_inspection_id`

### `sync_queue`

Назначение: локальная очередь отправки и приема пакетов.

Поля:

- `id TEXT PRIMARY KEY`
- `direction TEXT NOT NULL` со значениями `incoming`, `outgoing`
- `package_type TEXT NOT NULL` со значениями `reference`, `inspection_result`
- `package_id TEXT NOT NULL`
- `local_path TEXT NOT NULL`
- `status TEXT NOT NULL` со значениями `pending`, `processing`, `done`, `failed`, `conflict`
- `attempt_count INTEGER NOT NULL DEFAULT 0`
- `next_attempt_at TEXT NULL`
- `last_error TEXT NULL`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`

Индексы:

- `idx_sync_queue_status`
- `idx_sync_queue_direction`
- `ux_sync_queue_package_id`

### `sync_state`

Назначение: служебное состояние последней синхронизации устройства.

Поля:

- `id TEXT PRIMARY KEY`
- `device_id TEXT NOT NULL`
- `last_reference_package_id TEXT NULL`
- `last_reference_sync_at TEXT NULL`
- `last_result_push_at TEXT NULL`
- `last_result_pull_at TEXT NULL`
- `last_success_at TEXT NULL`
- `last_error TEXT NULL`
- `schema_version TEXT NOT NULL`
- `updated_at TEXT NOT NULL`

### `locks`

Назначение: локальный снимок lock-состояния и журнал его обработки.

Поля:

- `id TEXT PRIMARY KEY`
- `product_object_id TEXT NOT NULL`
- `remote_lock_key TEXT NOT NULL`
- `device_id TEXT NOT NULL`
- `user_id TEXT NOT NULL`
- `status TEXT NOT NULL` со значениями `active`, `released`, `expired`, `conflict`
- `acquired_at TEXT NOT NULL`
- `expires_at TEXT NOT NULL`
- `released_at TEXT NULL`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`

Индексы:

- `idx_locks_product_object_id`
- `idx_locks_status`

### `audit_log`

Назначение: журнал действий и событий системы.

Поля:

- `id TEXT PRIMARY KEY`
- `happened_at TEXT NOT NULL`
- `user_id TEXT NULL`
- `device_id TEXT NULL`
- `action_type TEXT NOT NULL`
- `entity_type TEXT NULL`
- `entity_id TEXT NULL`
- `result_status TEXT NOT NULL`
- `message TEXT NULL`
- `payload_json TEXT NULL`

Индексы:

- `idx_audit_log_happened_at`
- `idx_audit_log_action_type`
- `idx_audit_log_entity`

### `trash_bin`

Назначение: корзина мягко удаленных сущностей.

Поля:

- `id TEXT PRIMARY KEY`
- `entity_type TEXT NOT NULL`
- `entity_id TEXT NOT NULL`
- `display_name TEXT NOT NULL`
- `snapshot_json TEXT NOT NULL`
- `deleted_by_user_id TEXT NULL`
- `deleted_at TEXT NOT NULL`
- `restored_at TEXT NULL`
- `permanently_deleted_at TEXT NULL`

Индексы:

- `idx_trash_bin_entity`
- `idx_trash_bin_deleted_at`

### `app_settings`

Назначение: ключ-значение для настроек устройства.

Поля:

- `key TEXT PRIMARY KEY`
- `value_json TEXT NOT NULL`
- `updated_at TEXT NOT NULL`

### `device_info`

Назначение: идентификация текущего устройства и диагностика.

Поля:

- `id TEXT PRIMARY KEY`
- `device_name TEXT NOT NULL`
- `platform TEXT NOT NULL`
- `app_version TEXT NOT NULL`
- `db_schema_version TEXT NOT NULL`
- `sync_schema_version TEXT NOT NULL`
- `root_path TEXT NOT NULL`
- `last_sync_at TEXT NULL`
- `yandex_disk_connected INTEGER NOT NULL DEFAULT 0`
- `created_at TEXT NOT NULL`
- `updated_at TEXT NOT NULL`

## 3. Политика миграций

- каждая миграция имеет монотонный номер;
- миграции изменяют только SQLite-схему и seed справочника ролей;
- версия SQLite-схемы хранится отдельно от `sync schema version`;
- downgrade не поддерживается, восстановление выполняется через резервную копию.

## 4. Контракт `global_manifest.json`

Путь: `/company_qc_app/manifest/global_manifest.json`

Поля:

- `schema_version`
- `generated_at`
- `current_reference_package_id`
- `current_reference_package_checksum`
- `available_reference_packages`
- `registered_devices`

Назначение:

- сообщать Android актуальный пакет справочников;
- позволять Windows диагностировать набор устройств;
- не использоваться как источник бизнес-данных.

## 5. Контракт reference-пакета

Формат: zip-архив.

Путь:

- `/company_qc_app/reference_data/packages/reference_{package_id}.zip`

Содержимое:

- `manifest.json`
- `data/users.json`
- `data/org_structure.json`
- `data/objects.json`
- `data/object_relations.json`
- `data/components.json`
- `data/component_images.json`
- `data/checklists.json`
- `data/checklist_items.json`
- `data/checklist_bindings.json`
- `data/versions.json`

`manifest.json` содержит:

- `package_id`
- `package_type = "reference"`
- `schema_version`
- `created_at`
- `source_device_id`
- `checksum`
- `snapshot_version`
- `entities`
- `required_media`

Правила:

- reference-пакет публикуется только Windows;
- reference-пакет описывает полный согласованный снимок справочников для offline-работы;
- изображения компонентов не кладутся внутрь архива, а перечисляются в `required_media`;
- Android скачивает только требуемые media-файлы для выбранных данных.

## 6. Контракт result-пакета

Формат: zip-архив.

Путь:

- `/company_qc_app/results/incoming/result_{package_id}.zip`

Содержимое:

- `manifest.json`
- `inspection.json`
- `inspection_items.json`
- `signatures/`
- `reports/`

`manifest.json` содержит:

- `package_id`
- `package_type = "inspection_result"`
- `schema_version`
- `created_at`
- `source_device_id`
- `inspection_id`
- `inspection_checksum`
- `source_reference_package_id`
- `target_product_object_id`

`inspection.json` содержит:

- метаданные проверки;
- участников;
- статусы;
- ссылки на файлы внутри архива.

Правила:

- result-пакет создается только Android;
- PDF и подписи входят внутрь архива, чтобы импорт был атомарным;
- после успешного импорта Windows перемещает пакет в `/results/processed`;
- конфликтный пакет не меняется и перемещается в `/results/conflicts`.

## 7. Lock-файл

Путь:

- `/company_qc_app/locks/{product_object_id}.lock.json`

Поля:

- `lock_id`
- `product_object_id`
- `device_id`
- `user_id`
- `created_at`
- `expires_at`

Правила:

- lock создается только перед стартом проверки при доступной сети;
- lock удаляется после завершения проверки;
- при истекшем `expires_at` lock считается протухшим и может быть перезаписан Windows или новым Android-сеансом с записью в журнал;
- отсутствие сети не блокирует запуск проверки, но требует conflict-check на последующей синхронизации.

## 8. Политика конфликтов

Конфликтом считаются:

- параллельная активная проверка того же изделия;
- результат по устаревшему reference-пакету;
- дублирующий импорт того же `inspection_id` или `package_id`.

Поведение:

- новая онлайн-проверка не стартует при активном lock;
- офлайн-проверка завершается локально, но может получить статус `conflict` после импорта;
- Windows не объединяет конфликтующие результаты;
- конфликт сохраняется в `audit_log` и на экране диагностики;
- администратор вручную принимает организационное решение вне автоматического merge.
