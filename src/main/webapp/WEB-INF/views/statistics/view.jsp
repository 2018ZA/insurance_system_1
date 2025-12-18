<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../layout/header.jsp"/>
<jsp:include page="../layout/sidebar.jsp"/>

<main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Статистика</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <div class="btn-group me-2">
                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="window.print()">
                    <i class="fas fa-print me-1"></i>Печать
                </button>
                <button type="button" class="btn btn-sm btn-outline-secondary" id="exportBtn">
                    <i class="fas fa-download me-1"></i>Экспорт
                </button>
            </div>
        </div>
    </div>
    
    <!-- Общая статистика -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card stat-card bg-primary text-white">
                <i class="fas fa-users"></i>
                <h6>Всего клиентов</h6>
                <h3>${generalStats.totalClients}</h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stat-card bg-success text-white">
                <i class="fas fa-file-contract"></i>
                <h6>Всего договоров</h6>
                <h3>${generalStats.totalContracts}</h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stat-card bg-warning text-white">
                <i class="fas fa-check-circle"></i>
                <h6>Активных договоров</h6>
                <h3>${generalStats.activeContracts}</h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stat-card bg-info text-white">
                <i class="fas fa-money-bill-wave"></i>
                <h6>Общая премия</h6>
                <h3>
                    <fmt:formatNumber value="${generalStats.totalPremium}" 
                                      type="currency" currencySymbol="₽"/>
                </h3>
            </div>
        </div>
    </div>
    
    <div class="row">
        <!-- Статистика по типам страхования -->
        <div class="col-md-8">
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0">Статистика по типам страхования</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Тип страхования</th>
                                    <th>Количество договоров</th>
                                    <th>% от общего числа</th>
                                    <th>Средняя премия</th>
                                    <th>Общая премия</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="typeStat" items="${typeStats}">
                                    <tr>
                                        <td>
                                            <strong>${typeStat.typeName}</strong>
                                        </td>
                                        <td>
                                            <span class="badge bg-primary">${typeStat.contractCount}</span>
                                        </td>
                                        <td>
                                            <div class="progress" style="height: 20px;">
                                                <c:set var="percentage" value="${typeStat.contractCount * 100 / generalStats.totalContracts}"/>
                                                <div class="progress-bar" role="progressbar" 
                                                     style="width:${percentage}%">
                                                    <fmt:formatNumber value="${percentage}" maxFractionDigits="1"/>%
                                                </div>
                                            </div>
                                        </td>
                                        <td class="currency-field">
                                            <fmt:formatNumber value="${typeStat.averagePremium}" 
                                                              type="currency" currencySymbol="₽"/>
                                        </td>
                                        <td class="currency-field">
                                            <fmt:formatNumber value="${typeStat.averagePremium * typeStat.contractCount}" 
                                                              type="currency" currencySymbol="₽"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            <!-- График распределения по типам -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Распределение договоров по типам страхования</h5>
                </div>
                <div class="card-body">
                    <canvas id="typeChart" width="400" height="200"></canvas>
                </div>
            </div>
        </div>
        
        <!-- Статистика по статусам -->
        <div class="col-md-4">
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0">Распределение по статусам</h5>
                </div>
                <div class="card-body">
                    <canvas id="statusChart" width="300" height="300"></canvas>
                </div>
            </div>
            
            <!-- Дополнительная статистика -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Дополнительная статистика</h5>
                </div>
                <div class="card-body">
                    <div class="list-group list-group-flush">
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            Средняя страховая премия
                            <span class="badge bg-primary rounded-pill">
                                <fmt:formatNumber value="${generalStats.totalPremium / generalStats.totalContracts}" 
                                                  type="currency" currencySymbol="₽"/>
                            </span>
                        </div>
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            Средняя страховая сумма
                            <span class="badge bg-success rounded-pill">
                                <fmt:formatNumber value="${generalStats.totalPremium * 10 / generalStats.totalContracts}" 
                                                  type="currency" currencySymbol="₽"/>
                            </span>
                        </div>
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            Договоров на клиента
                            <span class="badge bg-info rounded-pill">
                                <fmt:formatNumber value="${generalStats.totalContracts / generalStats.totalClients}" 
                                                  maxFractionDigits="2"/>
                            </span>
                        </div>
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            Процент активных договоров
                            <span class="badge bg-warning rounded-pill">
                                <fmt:formatNumber value="${generalStats.activeContracts * 100 / generalStats.totalContracts}" 
                                                  maxFractionDigits="1"/>%
                            </span>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Период статистики -->
            <div class="card mt-4">
                <div class="card-header">
                    <h5 class="mb-0">Фильтр по периоду</h5>
                </div>
                <div class="card-body">
                    <form id="periodForm" class="row g-2">
                        <div class="col-md-6">
                            <label for="startDate" class="form-label">С</label>
                            <input type="date" class="form-control" id="startDate" name="startDate">
                        </div>
                        <div class="col-md-6">
                            <label for="endDate" class="form-label">По</label>
                            <input type="date" class="form-control" id="endDate" name="endDate">
                        </div>
                        <div class="col-md-12">
                            <button type="submit" class="btn btn-primary w-100 mt-2">
                                <i class="fas fa-filter me-1"></i>Применить фильтр
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
    // График по типам страхования
    var typeLabels = [];
    var typeData = [];
    var typeColors = ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40'];
    
    <c:forEach var="typeStat" items="${typeStats}" varStatus="loop">
        typeLabels.push("${typeStat.typeName}");
        typeData.push(${typeStat.contractCount});
    </c:forEach>
    
    var typeCtx = document.getElementById('typeChart').getContext('2d');
    var typeChart = new Chart(typeCtx, {
        type: 'bar',
        data: {
            labels: typeLabels,
            datasets: [{
                label: 'Количество договоров',
                data: typeData,
                backgroundColor: typeColors,
                borderColor: typeColors.map(color => color.replace('0.5', '1')),
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1
                    }
                }
            }
        }
    });
    
    // Круговая диаграмма по статусам
    var statusLabels = [];
    var statusData = [];
    var statusColors = ['#36A2EB', '#FF6384', '#FFCE56', '#4BC0C0', '#9966FF'];
    
    <c:forEach var="entry" items="${statusStats}" varStatus="loop">
        statusLabels.push("${entry.key}");
        statusData.push(${entry.value});
    </c:forEach>
    
    var statusCtx = document.getElementById('statusChart').getContext('2d');
    var statusChart = new Chart(statusCtx, {
        type: 'doughnut',
        data: {
            labels: statusLabels,
            datasets: [{
                data: statusData,
                backgroundColor: statusColors,
                hoverOffset: 4
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'bottom'
                }
            }
        }
    });
    
    // Экспорт статистики
    document.getElementById('exportBtn').addEventListener('click', function() {
        var dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify({
            generalStats: ${generalStats},
            typeStats: ${typeStats},
            statusStats: ${statusStats}
        }, null, 2));
        
        var downloadAnchor = document.createElement('a');
        downloadAnchor.setAttribute("href", dataStr);
        downloadAnchor.setAttribute("download", "statistics_" + new Date().toISOString().slice(0,10) + ".json");
        document.body.appendChild(downloadAnchor);
        downloadAnchor.click();
        document.body.removeChild(downloadAnchor);
    });
    
    // Фильтр по периоду
    document.getElementById('periodForm').addEventListener('submit', function(e) {
        e.preventDefault();
        var startDate = document.getElementById('startDate').value;
        var endDate = document.getElementById('endDate').value;
        
        // В реальном проекте здесь будет AJAX запрос для обновления статистики
        alert('Фильтр применен: ' + startDate + ' - ' + endDate + '\n\nВ реальном проекте здесь будет обновление статистики через AJAX');
    });
</script>

<jsp:include page="../layout/footer.jsp"/>