<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="layout/header.jsp"/>
<jsp:include page="layout/sidebar.jsp"/>

<!-- Main Content -->
<main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Панель управления</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <div class="btn-group me-2">
                <button type="button" class="btn btn-sm btn-outline-secondary">
                    <i class="fas fa-download me-1"></i> Экспорт
                </button>
            </div>
        </div>
    </div>
    
    <!-- Статистические карточки -->
    <div class="row">
        <div class="col-md-3">
            <div class="stat-card bg-primary text-white">
                <i class="fas fa-users"></i>
                <h5>Всего клиентов</h5>
                <h3 id="totalClients">0</h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card bg-success text-white">
                <i class="fas fa-file-contract"></i>
                <h5>Всего договоров</h5>
                <h3 id="totalContracts">0</h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card bg-warning text-white">
                <i class="fas fa-check-circle"></i>
                <h5>Активных договоров</h5>
                <h3 id="activeContracts">0</h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card bg-info text-white">
                <i class="fas fa-money-bill-wave"></i>
                <h5>Общая премия</h5>
                <h3 id="totalPremium">0 ₽</h3>
            </div>
        </div>
    </div>
    
    <!-- Быстрые действия -->
    <div class="row mt-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Быстрые действия</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3 mb-3">
                            <a href="${pageContext.request.contextPath}/clients/add" class="btn btn-primary w-100">
                                <i class="fas fa-user-plus me-2"></i>Добавить клиента
                            </a>
                        </div>
                        <div class="col-md-3 mb-3">
                            <a href="${pageContext.request.contextPath}/contracts/add" class="btn btn-success w-100">
                                <i class="fas fa-file-signature me-2"></i>Оформить договор
                            </a>
                        </div>
                        <div class="col-md-3 mb-3">
                            <a href="${pageContext.request.contextPath}/clients" class="btn btn-info w-100">
                                <i class="fas fa-search me-2"></i>Найти клиента
                            </a>
                        </div>
                        <div class="col-md-3 mb-3">
                            <a href="${pageContext.request.contextPath}/statistics" class="btn btn-warning w-100">
                                <i class="fas fa-chart-pie me-2"></i>Просмотреть статистику
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Последние договоры -->
    <div class="row mt-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Последние договоры</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover" id="recentContracts">
                            <thead>
                                <tr>
                                    <th>Номер</th>
                                    <th>Клиент</th>
                                    <th>Тип страхования</th>
                                    <th>Статус</th>
                                    <th>Дата начала</th>
                                    <th>Премия</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Данные будут загружены через AJAX -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    $(document).ready(function() {
        // Загрузка статистики
        $.get('${pageContext.request.contextPath}/api/statistics/dashboard', function(data) {
            $('#totalClients').text(data.totalClients);
            $('#totalContracts').text(data.totalContracts);
            $('#activeContracts').text(data.activeContracts);
            $('#totalPremium').text(data.totalPremium.toLocaleString('ru-RU') + ' ₽');
        });
        
        // Загрузка последних договоров
        $.get('${pageContext.request.contextPath}/api/contracts/recent', function(contracts) {
            var tbody = $('#recentContracts tbody');
            tbody.empty();
            
            contracts.forEach(function(contract) {
                var statusClass = '';
                switch(contract.statusCode) {
                    case 'ACTIVE': statusClass = 'badge bg-success'; break;
                    case 'DRAFT': statusClass = 'badge bg-secondary'; break;
                    case 'EXPIRED': statusClass = 'badge bg-warning'; break;
                    case 'TERMINATED': statusClass = 'badge bg-danger'; break;
                    default: statusClass = 'badge bg-info';
                }
                
                var row = '<tr>' +
                    '<td><a href="${pageContext.request.contextPath}/contracts/view/' + contract.id + '">' + contract.contractNumber + '</a></td>' +
                    '<td>' + contract.clientName + '</td>' +
                    '<td>' + contract.insuranceType + '</td>' +
                    '<td><span class="' + statusClass + '">' + contract.status + '</span></td>' +
                    '<td class="date-field">' + contract.startDate + '</td>' +
                    '<td class="currency-field">' + contract.premiumAmount + '</td>' +
                    '</tr>';
                
                tbody.append(row);
            });
        });
    });
</script>

<jsp:include page="layout/footer.jsp"/>