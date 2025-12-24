/**
 * Основной JavaScript файл для Insurance_system
 * Автор: [Ваше имя]
 * Версия: 1.1 (исправленная)
 */

// Используем IIFE (Immediately Invoked Function Expression) для избежания конфликтов
(function(global, $) {
    'use strict';
    
    /**
     * Конфигурация приложения
     */
    var AppConfig = {
        contextPath: '', // Будет установлено при инициализации
        apiBaseUrl: '',  // Будет установлено при инициализации
        debug: true      // Режим отладки
    };
    
    /**
     * Утилиты приложения
     */
    var AppUtils = {
        /**
         * Инициализация конфигурации
         * Вызывается из JSP для установки контекстного пути
         */
        initConfig: function(config) {
            if (config && config.contextPath) {
                AppConfig.contextPath = config.contextPath;
                AppConfig.apiBaseUrl = config.contextPath + '/api';
            } else {
                // Автоматическое определение контекстного пути
                AppConfig.contextPath = this.detectContextPath();
                AppConfig.apiBaseUrl = AppConfig.contextPath + '/api';
            }
            
            if (AppConfig.debug) {
                console.log('AppConfig initialized:', AppConfig);
            }
        },
        
        /**
         * Автоматическое определение контекстного пути приложения
         */
        detectContextPath: function() {
            // Способ 1: Из data-атрибута body
            var body = document.body;
            if (body && body.dataset.contextPath) {
                return body.dataset.contextPath;
            }
            
            // Способ 2: Из глобальной переменной
            if (global.contextPath) {
                return global.contextPath;
            }
            
            // Способ 3: Из текущего URL (для приложения по пути /insurance)
            var pathname = window.location.pathname;
            if (pathname.indexOf('/insurance') === 0) {
                return '/insurance';
            }
            
            // Способ 4: Разбор pathname для определения контекста
            var parts = pathname.split('/');
            if (parts.length > 1 && parts[1]) {
                return '/' + parts[1];
            }
            
            // По умолчанию - пустая строка (корневой контекст)
            return '';
        },
        
        /**
         * Полный URL для API запросов
         */
        buildApiUrl: function(endpoint) {
            // Убираем ведущий слеш если он есть
            if (endpoint.startsWith('/')) {
                endpoint = endpoint.substring(1);
            }
            return AppConfig.apiBaseUrl + '/' + endpoint;
        },
        
        /**
         * Полный URL для ресурсов
         */
        buildResourceUrl: function(resource) {
            // Убираем ведущий слеш если он есть
            if (resource.startsWith('/')) {
                resource = resource.substring(1);
            }
            return AppConfig.contextPath + '/' + resource;
        },
        
        /**
         * Проверка авторизации пользователя
         */
        isAuthenticated: function() {
            // Проверяем наличие элемента, указывающего на авторизацию
            return $('[data-user-authenticated="true"]').length > 0 || 
                   $('#logoutButton').length > 0;
        },
        
        /**
         * Проверка роли пользователя
         */
        hasRole: function(role) {
            var userRoles = $('body').data('user-roles') || '';
            return userRoles.split(',').indexOf(role) !== -1;
        }
    };
    
    /**
     * Компоненты пользовательского интерфейса
     */
    var UIComponents = {
        /**
         * Инициализация всех компонентов Bootstrap
         */
        initBootstrapComponents: function() {
            try {
                // Инициализация тултипов
                var tooltipTriggerList = [].slice.call(
                    document.querySelectorAll('[data-bs-toggle="tooltip"]')
                );
                tooltipTriggerList.map(function(tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl, {
                        trigger: 'hover'
                    });
                });
                
                // Инициализация popover
                var popoverTriggerList = [].slice.call(
                    document.querySelectorAll('[data-bs-toggle="popover"]')
                );
                popoverTriggerList.map(function(popoverTriggerEl) {
                    return new bootstrap.Popover(popoverTriggerEl);
                });
                
                console.log('Bootstrap components initialized');
            } catch (error) {
                console.error('Error initializing Bootstrap components:', error);
            }
        },
        
        /**
         * Инициализация подтверждения действий
         */
        initConfirmations: function() {
            // Подтверждение удаления
            $(document).on('click', '.confirm-delete', function(e) {
                var message = $(this).data('confirm-message') || 
                             'Вы уверены, что хотите удалить эту запись?';
                
                if (!confirm(message)) {
                    e.preventDefault();
                    return false;
                }
                return true;
            });
            
            // Подтверждение выхода
            $(document).on('click', '.confirm-logout', function(e) {
                if (!confirm('Вы уверены, что хотите выйти из системы?')) {
                    e.preventDefault();
                    return false;
                }
                return true;
            });
            
            // Подтверждение сброса формы
            $(document).on('click', '.confirm-reset', function(e) {
                if (!confirm('Вы уверены, что хотите сбросить все изменения?')) {
                    e.preventDefault();
                    return false;
                }
                return true;
            });
        },
        
        /**
         * Инициализация валидации форм
         */
        initFormValidation: function() {
            // Валидация при отправке формы
            $(document).on('submit', 'form.needs-validation', function(e) {
                var form = this;
                
                if (!form.checkValidity()) {
                    e.preventDefault();
                    e.stopPropagation();
                    
                    // Находим первое невалидное поле
                    var firstInvalid = $(this).find(':invalid').first();
                    if (firstInvalid.length) {
                        firstInvalid.focus();
                    }
                }
                
                $(this).addClass('was-validated');
            });
            
            // Валидация в реальном времени
            $(document).on('blur', 'form.needs-validation :input', function() {
                var $input = $(this);
                var isValid = this.checkValidity();
                
                if ($input.val().trim() !== '') {
                    if (isValid) {
                        $input.removeClass('is-invalid').addClass('is-valid');
                    } else {
                        $input.removeClass('is-valid').addClass('is-invalid');
                    }
                }
            });
        },
        
        /**
         * Инициализация обработки алертов
         */
        initAlerts: function() {
            // Автоматическое скрытие алертов через 5 секунд
            $('.alert:not(.alert-permanent)').delay(5000).fadeOut('slow', function() {
                $(this).alert('close');
            });
            
            // Закрытие алерта по клику
            $(document).on('click', '.alert .btn-close', function() {
                $(this).closest('.alert').fadeOut('slow');
            });
        },
        
        /**
         * Инициализация поиска
         */
        initSearch: function() {
            // Обработка нажатия Enter в полях поиска
            $(document).on('keypress', '.search-input', function(e) {
                if (e.which === 13) { // Enter key
                    e.preventDefault();
                    var $form = $(this).closest('form');
                    
                    if ($form.length && $form[0].checkValidity()) {
                        $form.submit();
                    } else {
                        $form.addClass('was-validated');
                    }
                }
            });
            
            // Debounced поиск для AJAX поиска
            var debouncedSearch = AppUtils.debounce(function(query) {
                if (query.length >= 2) {
                    // Здесь может быть AJAX запрос для поиска
                    console.log('Searching for:', query);
                }
            }, 300);
            
            $(document).on('input', '.search-input-ajax', function() {
                debouncedSearch($(this).val());
            });
        }
    };
    
    /**
     * Сервис данных
     */
    var DataService = {
        /**
         * Загрузка статистики для сайдбара
         * Использует правильный путь: /api/statistics/sidebar
         */
        loadSidebarStats: function() {
            // Проверяем, есть ли на странице блок статистики
            var $clientsCount = $('#clientsCount');
            var $contractsCount = $('#contractsCount');
            
            if (!$clientsCount.length && !$contractsCount.length) {
                return; // Блок статистики отсутствует на странице
            }
            
            // Показываем индикаторы загрузки
            if ($clientsCount.length) {
                $clientsCount.html('<i class="fas fa-spinner fa-spin fa-xs"></i>');
            }
            if ($contractsCount.length) {
                $contractsCount.html('<i class="fas fa-spinner fa-spin fa-xs"></i>');
            }
            
            // Формируем правильный URL
            var url = AppUtils.buildApiUrl('statistics/sidebar');
            
            if (AppConfig.debug) {
                console.log('Loading sidebar stats from:', url);
            }
            
            $.ajax({
                url: url,
                type: 'GET',
                dataType: 'json',
                timeout: 10000, // 10 секунд таймаут
                success: function(data) {
                    if (data && typeof data === 'object') {
                        // Обновляем счетчики
                        if ($clientsCount.length && data.clientsCount !== undefined) {
                            $clientsCount.text(data.clientsCount);
                        }
                        if ($contractsCount.length && data.contractsCount !== undefined) {
                            $contractsCount.text(data.contractsCount);
                        }
                        
                        if (AppConfig.debug) {
                            console.log('Sidebar stats loaded:', data);
                        }
                    } else {
                        console.warn('Invalid data format received for sidebar stats');
                        DataService.hideSidebarStats();
                    }
                },
                error: function(xhr, status, error) {
                    console.warn('Could not load sidebar statistics:', error);
                    DataService.hideSidebarStats();
                }
            });
        },
        
        /**
         * Скрытие блока статистики при ошибке
         */
        hideSidebarStats: function() {
            var $statsBlock = $('.sidebar-heading').closest('.mt-5');
            if ($statsBlock.length) {
                $statsBlock.slideUp(300, function() {
                    $(this).hide();
                });
            }
        },
        
        /**
         * Загрузка уведомлений
         */
        loadNotifications: function() {
            // Проверяем авторизацию пользователя
            if (!AppUtils.isAuthenticated()) {
                return;
            }
            
            var $notificationBadge = $('#notificationBadge');
            if (!$notificationBadge.length) {
                return; // Элемент уведомлений отсутствует
            }
            
            var url = AppUtils.buildApiUrl('notifications');
            
            $.ajax({
                url: url,
                type: 'GET',
                dataType: 'json',
                success: function(data) {
                    if (data && typeof data === 'object') {
                        // Обновляем бейдж
                        if (data.count > 0) {
                            $notificationBadge.text(data.count).show();
                        } else {
                            $notificationBadge.hide();
                        }
                        
                        // Показываем уведомления если есть новые
                        if (data.messages && data.messages.length > 0) {
                            DataService.showNotificationMessages(data.messages);
                        }
                    }
                },
                error: function(xhr) {
                    if (xhr.status !== 401) { // Не показываем ошибку если не авторизован
                        console.warn('Could not load notifications');
                    }
                }
            });
        },
        
        /**
         * Отображение сообщений уведомлений
         */
        showNotificationMessages: function(messages) {
            // В реальном приложении здесь может быть отображение попапа
            if (AppConfig.debug && messages && messages.length) {
                console.log('New notifications:', messages);
            }
        }
    };
    
    /**
     * Вспомогательные функции
     */
    var HelperFunctions = {
        /**
         * Показать индикатор загрузки
         * @param {string|jQuery} element - Селектор или jQuery объект
         * @param {string} message - Сообщение (опционально)
         */
        showLoading: function(element, message) {
            if (!element) {
                element = 'body';
            }
            
            var $element = $(element);
            var loadingHtml = 
                '<div class="loading-overlay">' +
                '  <div class="loading-content">' +
                '    <div class="loading-spinner"></div>' +
                (message ? '<div class="loading-message mt-2">' + message + '</div>' : '') +
                '  </div>' +
                '</div>';
            
            // Удаляем старый индикатор если есть
            $element.find('.loading-overlay').remove();
            
            // Добавляем новый
            $element.append(loadingHtml);
        },
        
        /**
         * Скрыть индикатор загрузки
         */
        hideLoading: function() {
            $('.loading-overlay').fadeOut(200, function() {
                $(this).remove();
            });
        },
        
        /**
         * Показать сообщение об ошибке
         * @param {string} message - Текст сообщения
         * @param {boolean} autoHide - Автоматически скрывать
         */
        showError: function(message, autoHide) {
            this.showAlert('danger', message, autoHide);
        },
        
        /**
         * Показать сообщение об успехе
         * @param {string} message - Текст сообщения
         * @param {boolean} autoHide - Автоматически скрывать
         */
        showSuccess: function(message, autoHide) {
            this.showAlert('success', message, autoHide);
        },
        
        /**
         * Показать информационное сообщение
         * @param {string} message - Текст сообщения
         * @param {boolean} autoHide - Автоматически скрывать
         */
        showInfo: function(message, autoHide) {
            this.showAlert('info', message, autoHide);
        },
        
        /**
         * Показать предупреждение
         * @param {string} message - Текст сообщения
         * @param {boolean} autoHide - Автоматически скрывать
         */
        showWarning: function(message, autoHide) {
            this.showAlert('warning', message, autoHide);
        },
        
        /**
         * Общая функция отображения алертов
         */
        showAlert: function(type, message, autoHide) {
            // Создаем контейнер если его нет
            if (!$('#alertsContainer').length) {
                $('body').append('<div id="alertsContainer"></div>');
            }
            
            var alertId = 'alert-' + Date.now();
            var autoHideAttr = autoHide === false ? '' : 'data-auto-hide="true"';
            
            var alertHtml = 
                '<div id="' + alertId + '" class="alert alert-' + type + ' alert-dismissible fade show" ' + autoHideAttr + ' role="alert">' +
                '  <i class="fas ' + this.getAlertIcon(type) + ' me-2"></i>' +
                '  ' + message +
                '  <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>' +
                '</div>';
            
            $('#alertsContainer').append(alertHtml);
            
            // Автоматическое скрытие если включено
            if (autoHide !== false) {
                setTimeout(function() {
                    $('#' + alertId).fadeOut(300, function() {
                        $(this).remove();
                    });
                }, 5000);
            }
        },
        
        /**
         * Получение иконки для типа алерта
         */
        getAlertIcon: function(type) {
            switch(type) {
                case 'success': return 'fa-check-circle';
                case 'danger': return 'fa-exclamation-circle';
                case 'warning': return 'fa-exclamation-triangle';
                case 'info': return 'fa-info-circle';
                default: return 'fa-info-circle';
            }
        },
        
        /**
         * Форматирование даты
         */
        formatDate: function(dateString) {
            if (!dateString) return '';
            
            var date = new Date(dateString);
            if (isNaN(date.getTime())) return dateString;
            
            return date.toLocaleDateString('ru-RU', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric'
            });
        },
        
        /**
         * Форматирование даты и времени
         */
        formatDateTime: function(dateString) {
            if (!dateString) return '';
            
            var date = new Date(dateString);
            if (isNaN(date.getTime())) return dateString;
            
            return date.toLocaleString('ru-RU', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            });
        },
        
        /**
         * Форматирование валюты
         */
        formatCurrency: function(amount) {
            if (amount === null || amount === undefined || amount === '') return '';
            
            var num = parseFloat(amount);
            if (isNaN(num)) return amount;
            
            return num.toLocaleString('ru-RU', {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            }) + ' ₽';
        },
        
        /**
         * Debounce функция для оптимизации производительности
         */
        debounce: function(func, wait) {
            var timeout;
            return function() {
                var context = this, args = arguments;
                clearTimeout(timeout);
                timeout = setTimeout(function() {
                    func.apply(context, args);
                }, wait);
            };
        },
        
        /**
         * Throttle функция для ограничения частоты вызовов
         */
        throttle: function(func, limit) {
            var inThrottle;
            return function() {
                var context = this, args = arguments;
                if (!inThrottle) {
                    func.apply(context, args);
                    inThrottle = true;
                    setTimeout(function() {
                        inThrottle = false;
                    }, limit);
                }
            };
        }
    };
    
    /**
     * Глобальные обработчики ошибок
     */
    var ErrorHandlers = {
        /**
         * Инициализация глобальных обработчиков ошибок
         */
        init: function() {
            // Обработка ошибок AJAX
            $(document).ajaxError(function(event, jqxhr, settings, thrownError) {
                if (AppConfig.debug) {
                    console.error('AJAX Error:', {
                        url: settings.url,
                        status: jqxhr.status,
                        error: thrownError,
                        response: jqxhr.responseText
                    });
                }
                
                ErrorHandlers.handleAjaxError(jqxhr, settings);
            });
            
            // Глобальный обработчик ошибок JavaScript
            window.onerror = function(message, source, lineno, colno, error) {
                console.error('JavaScript Error:', {
                    message: message,
                    source: source,
                    line: lineno,
                    column: colno,
                    error: error
                });
                return false; // Позволяем стандартной обработке ошибок
            };
        },
        
        /**
         * Обработка ошибок AJAX
         */
        handleAjaxError: function(jqxhr, settings) {
            // Пропускаем ошибки для определенных URL
            if (settings.url.includes('/api/statistics/sidebar') || 
                settings.url.includes('/api/notifications')) {
                return; // Эти ошибки уже обрабатываются в своих функциях
            }
            
            var message = '';
            var redirect = false;
            
            switch(jqxhr.status) {
                case 0:
                    message = 'Нет соединения с сервером. Проверьте интернет-соединение.';
                    break;
                case 401:
                    message = 'Сессия истекла. Пожалуйста, войдите снова.';
                    redirect = true;
                    setTimeout(function() {
                        window.location.href = AppUtils.buildResourceUrl('login?sessionExpired=true');
                    }, 2000);
                    break;
                case 403:
                    message = 'У вас нет прав для выполнения этого действия.';
                    break;
                case 404:
                    message = 'Запрошенный ресурс не найден.';
                    break;
                case 408:
                    message = 'Истекло время ожидания запроса.';
                    break;
                case 500:
                    message = 'Внутренняя ошибка сервера. Пожалуйста, попробуйте позже.';
                    break;
                case 503:
                    message = 'Сервис временно недоступен. Пожалуйста, попробуйте позже.';
                    break;
                default:
                    message = 'Произошла ошибка. Статус: ' + jqxhr.status;
            }
            
            if (message) {
                HelperFunctions.showError(message, true);
            }
        }
    };
    
    /**
     * Основная функция инициализации
     */
    function init() {
        try {
            // 1. Инициализация конфигурации
            AppUtils.initConfig();
            
            // 2. Инициализация компонентов UI
            UIComponents.initBootstrapComponents();
            UIComponents.initConfirmations();
            UIComponents.initFormValidation();
            UIComponents.initAlerts();
            UIComponents.initSearch();
            
            // 3. Инициализация обработчиков ошибок
            ErrorHandlers.init();
            
            // 4. Загрузка данных
            if (AppUtils.isAuthenticated()) {
                DataService.loadSidebarStats();
                DataService.loadNotifications();
            }
            
            // 5. Логирование успешной инициализации
            if (AppConfig.debug) {
                console.log('Insurance System JavaScript initialized successfully');
                console.log('Context Path:', AppConfig.contextPath);
                console.log('API Base URL:', AppConfig.apiBaseUrl);
            }
            
        } catch (error) {
            console.error('Error during application initialization:', error);
            HelperFunctions.showError('Ошибка инициализации приложения. Пожалуйста, обновите страницу.');
        }
    }
    
    // Экспортируем публичные методы в глобальную область видимости
    global.InsuranceApp = {
        init: init,
        config: AppConfig,
        utils: AppUtils,
        ui: UIComponents,
        data: DataService,
        helpers: HelperFunctions,
        
        /**
         * Перезагрузка статистики сайдбара (можно вызвать из консоли)
         */
        reloadSidebarStats: function() {
            DataService.loadSidebarStats();
        },
        
        /**
         * Показать сообщение (для отладки)
         */
        showMessage: function(type, message) {
            HelperFunctions.showAlert(type, message);
        }
    };
    
    // Инициализация при загрузке документа
    $(document).ready(function() {
        InsuranceApp.init();
    });
    
})(window, jQuery); // Передаем глобальные объекты как параметры