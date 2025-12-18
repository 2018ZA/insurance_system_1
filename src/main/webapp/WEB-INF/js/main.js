/**
 * Основной JavaScript файл для InsurancePro
 */

$(document).ready(function() {
    // Инициализация компонентов
    initComponents();
    
    // Обработчики событий
    setupEventHandlers();
    
    // Загрузка данных
    loadInitialData();
});

/**
 * Инициализация компонентов
 */
function initComponents() {
    // Включение тултипов Bootstrap
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    
    // Включение всплывающих окон
    var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
    var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
        return new bootstrap.Popover(popoverTriggerEl);
    });
}

/**
 * Настройка обработчиков событий
 */
function setupEventHandlers() {
    // Подтверждение удаления
    $(document).on('click', '.confirm-delete', function(e) {
        if (!confirm('Вы уверены, что хотите удалить эту запись?')) {
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
    
    // Валидация форм
    $('form.needs-validation').on('submit', function(e) {
        if (!this.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();
        }
        $(this).addClass('was-validated');
    });
    
    // Автоматическое скрытие алертов
    $('.alert').delay(5000).fadeOut('slow');
    
    // Обработка нажатия Enter в формах поиска
    $('.search-input').on('keypress', function(e) {
        if (e.which === 13) {
            $(this).closest('form').submit();
        }
    });
}

/**
 * Загрузка начальных данных
 */
function loadInitialData() {
    // Загрузка статистики для сайдбара
    loadSidebarStats();
    
    // Загрузка уведомлений
    loadNotifications();
}

/**
 * Загрузка статистики для сайдбара
 */
function loadSidebarStats() {
    $.ajax({
        url: '${pageContext.request.contextPath}/api/statistics/sidebar',
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            $('#sidebarClientsCount').text(data.clientsCount || 0);
            $('#sidebarContractsCount').text(data.contractsCount || 0);
        },
        error: function() {
            console.error('Ошибка загрузки статистики для сайдбара');
        }
    });
}

/**
 * Загрузка уведомлений
 */
function loadNotifications() {
    $.ajax({
        url: '${pageContext.request.contextPath}/api/notifications',
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            updateNotificationBadge(data.count);
            if (data.count > 0) {
                showNotificationPopup(data.messages);
            }
        }
    });
}

/**
 * Обновление бейджа уведомлений
 */
function updateNotificationBadge(count) {
    var badge = $('#notificationBadge');
    if (count > 0) {
        badge.text(count).show();
    } else {
        badge.hide();
    }
}

/**
 * Показ всплывающего уведомления
 */
function showNotificationPopup(messages) {
    // В реальном проекте здесь будет отображение уведомлений
    console.log('Новые уведомления:', messages);
}

/**
 * Показать индикатор загрузки
 */
function showLoading(element) {
    if (!element) {
        element = 'body';
    }
    $(element).append(
        '<div class="loading-overlay">' +
        '   <div class="loading-spinner"></div>' +
        '</div>'
    );
}

/**
 * Скрыть индикатор загрузки
 */
function hideLoading() {
    $('.loading-overlay').remove();
}

/**
 * Показать сообщение об ошибке
 */
function showError(message) {
    var alertHtml = '<div class="alert alert-danger alert-dismissible fade show" role="alert">' +
                    '   <i class="fas fa-exclamation-circle me-2"></i>' +
                    '   ' + message +
                    '   <button type="button" class="btn-close" data-bs-dismiss="alert"></button>' +
                    '</div>';
    
    $('#alertsContainer').append(alertHtml);
}

/**
 * Показать сообщение об успехе
 */
function showSuccess(message) {
    var alertHtml = '<div class="alert alert-success alert-dismissible fade show" role="alert">' +
                    '   <i class="fas fa-check-circle me-2"></i>' +
                    '   ' + message +
                    '   <button type="button" class="btn-close" data-bs-dismiss="alert"></button>' +
                    '</div>';
    
    $('#alertsContainer').append(alertHtml);
}

/**
 * Форматирование даты
 */
function formatDate(dateString) {
    if (!dateString) return '';
    
    var date = new Date(dateString);
    if (isNaN(date.getTime())) return dateString;
    
    return date.toLocaleDateString('ru-RU', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric'
    });
}

/**
 * Форматирование валюты
 */
function formatCurrency(amount) {
    if (!amount && amount !== 0) return '';
    
    var num = parseFloat(amount);
    if (isNaN(num)) return amount;
    
    return num.toLocaleString('ru-RU', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    }) + ' ₽';
}

/**
 * Поиск с задержкой (debounce)
 */
function debounce(func, wait) {
    var timeout;
    return function() {
        var context = this, args = arguments;
        clearTimeout(timeout);
        timeout = setTimeout(function() {
            func.apply(context, args);
        }, wait);
    };
}

// Глобальные обработчики ошибок AJAX
$(document).ajaxError(function(event, jqxhr, settings, thrownError) {
    console.error('AJAX ошибка:', settings.url, thrownError);
    
    if (jqxhr.status === 401) {
        // Не авторизован
        window.location.href = '${pageContext.request.contextPath}/login?sessionExpired=true';
    } else if (jqxhr.status === 403) {
        // Доступ запрещен
        showError('У вас нет прав для выполнения этого действия');
    } else if (jqxhr.status === 500) {
        // Ошибка сервера
        showError('Произошла ошибка сервера. Пожалуйста, попробуйте позже.');
    } else if (jqxhr.status === 404) {
        // Не найдено
        showError('Запрошенный ресурс не найден');
    }
});