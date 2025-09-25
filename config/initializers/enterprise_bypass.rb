# frozen_string_literal: true

# Отключение Enterprise ограничений НАВСЕГДА
Rails.application.config.after_initialize do
  Rails.logger.info "🚀 Enterprise restrictions bypassed permanently"

  # Устанавливаем настройку для скрытия баннеров
  begin
    Setting.ee_hide_banners = true
    Rails.logger.info "✅ Enterprise banners hidden via Setting"
  rescue StandardError => e
    Rails.logger.warn "⚠️ Could not set ee_hide_banners: #{e.message}"
  end

  # Переопределяем EnterpriseToken методы
  EnterpriseToken.class_eval do
    # Разрешить ВСЕ Enterprise функции
    def self.allows_to?(feature)
      true
    end

    # Показать как активный токен
    def self.active?
      true
    end

    # Скрыть Enterprise баннеры
    def self.hide_banners?
      true
    end

    # Показать как не trial версия
    def self.trial_only?
      false
    end

    # Показать что есть активные токены
    def self.one?
      true
    end

    # Показать что есть активные токены (множественное число)
    def self.any?
      true
    end

    # Вернуть фейковый активный токен
    def self.active_tokens
      [new]
    end

    # Переопределяем методы экземпляра для безопасности
    def trial?
      false
    end

    def active?
      true
    end

    def token_object
      # Возвращаем фейковый объект вместо nil
      @fake_token_object ||= OpenStruct.new(
        trial?: false,
        active?: true,
        will_expire?: false,
        subscriber: "Community Edition",
        mail: "admin@localhost",
        company: "Local Installation",
        domain: "*",
        issued_at: Time.current,
        starts_at: Time.current,
        expires_at: 100.years.from_now,
        reprieve_days: 0,
        reprieve_days_left: 0,
        restrictions: {},
        available_features: [],
        plan: "unlimited",
        features: [],
        version: "1.0",
        started?: true
      )
    end
  end

  # Переопределяем OpenProject::Configuration для скрытия Enterprise manager
  OpenProject::Configuration.class_eval do
    def self.ee_manager_visible?
      false
    end
  end

  # Убираем Enterprise карточку из админ меню
  Rails.application.config.to_prepare do
    # Удаляем пункт :enterprise из админ меню
    admin_menu = Redmine::MenuManager.items(:admin_menu)
    if admin_menu.root.children.any? { |child| child.name == :enterprise }
      Rails.logger.info "🗑️ Removing Enterprise menu item from admin"
      admin_menu.root.children.reject! { |child| child.name == :enterprise }
    end
  end

  Rails.logger.info "🎉 All Enterprise restrictions and UI elements removed!"
end
