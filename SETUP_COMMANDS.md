# OpenProject Development Setup Commands

Этот файл содержит команды, которые были выполнены для первоначальной настройки OpenProject после клонирования репозитория.

## Проблемы, с которыми столкнулись

1. **Конфликт версий Ruby**: RVM смешивал gems между версиями Ruby 3.4.1 и 3.4.5
2. **Отсутствие PostgreSQL**: Сервер не был запущен
3. **Проблемы с зависимостями**: PostgreSQL имел проблемы с библиотеками ICU

## Выполненные команды

### 1. Создание конфигурации базы данных
```bash
cp config/database.yml.example config/database.yml
```

### 2. Очистка проблемных gems
```bash
rm -rf /Users/vitaly/.rvm/gems/ruby-3.4.1
```

### 3. Установка bundler для правильной версии Ruby
```bash
/Users/vitaly/.rvm/rubies/ruby-3.4.5/bin/gem install bundler
```

### 4. Установка Ruby gems
```bash
/bin/bash --login -c "rvm use 3.4.5 && bundle install"
```

### 5. Переустановка PostgreSQL (из-за проблем с зависимостями)
```bash
brew reinstall postgresql@14
```

### 6. Запуск PostgreSQL
```bash
brew services start postgresql@14
```

### 7. Создание пользователей и баз данных PostgreSQL
```bash
createuser -s openproject_development 2>/dev/null || echo "User may already exist"
createdb openproject_development -O openproject_development 2>/dev/null || echo "Database may already exist"
```

### 8. Запуск полной настройки разработки
```bash
/bin/bash --login -c "rvm use 3.4.5 && bin/setup_dev"
```

## Результат

После выполнения всех команд:
- ✅ База данных PostgreSQL настроена и запущена
- ✅ Все Ruby gems установлены (484 gems)
- ✅ Node.js зависимости установлены
- ✅ Миграции базы данных выполнены
- ✅ Фронтенд модули связаны
- ✅ Локализация экспортирована

## Запуск в режиме разработки

### Вариант 1: Все сервисы одной командой
```bash
bin/dev
```

### Вариант 2: Отдельные сервисы
```bash
# Rails сервер
RAILS_ENV=development bin/rails server

# Angular CLI
npm run serve

# Good Job worker
RAILS_ENV=development bundle exec good_job start
```

## Дополнительные команды

### Установка git hooks
```bash
bundle exec lefthook install
```

### Проверка статуса сервисов
```bash
brew services list | grep postgresql
```

### Проверка версии Ruby
```bash
/bin/bash --login -c "rvm use 3.4.5 && ruby --version"
```

## Запуск на альтернативных портах

Если стандартные порты 3000 и 4200 заняты другими проектами:

```bash
# Остановить существующие процессы overmind
pkill -f overmind

# Удалить сокет overmind
rm -f .overmind.sock

# Запустить на портах 3001 и 4201
PORT=3001 FE_PORT=4201 /bin/bash --login -c "rvm use 3.4.5 && bin/dev"
```

**Результат:**
- Rails сервер: `http://localhost:3001`
- Angular CLI: `http://localhost:4201`

## Демо-пользователи и пароли

После успешного запуска OpenProject доступны следующие пользователи:

### Админ пользователь
- **Логин:** `admin`
- **Пароль:** `admin`
- **Email:** `admin@example.net`
- **Роль:** Администратор системы

### Development пользователи (пароль = логин)
- **reader** / **reader** - Reader DEV user (reader@example.net)
- **member** / **member** - Member DEV user (member@example.net)
- **work_packager** / **work_packager** - Work packager DEV user (work_packager@example.net)
- **project_admin** / **project_admin** - Project admin DEV user (project_admin@example.net)
- **admin_de** / **admin_de** - Admin de DEV user (admin_de@example.net) - Админ с немецкой локализацией

### Доступ к приложению
1. Откройте браузер и перейдите по адресу: `http://localhost:3001`
2. Войдите используя любой из указанных выше логинов и паролей
3. Рекомендуется начать с `admin` / `admin` для полного доступа к системе

## Примечания

- Все команды выполнялись из директории `/Users/vitaly/Development/OpenProject`
- Использовался RVM для управления версиями Ruby
- PostgreSQL@14 установлен через Homebrew
- Проект требует Ruby 3.4.5 (указано в `.ruby-version`)