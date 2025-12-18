<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../layout/header.jsp"/>
<jsp:include page="../layout/sidebar.jsp"/>

<main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">
            <c:choose>
                <c:when test="${not empty client}">
                    Договоры клиента: ${client.fullName}
                </c:when>
                <c:otherwise>
                    ${pageTitle}
                </c:otherwise>
            </c:choose>
        </h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <a href="${pageContext.request.contextPath}/contracts/add" class="btn btn-primary">
                <i class="fas fa-file-contract me-1"></i>Оформить договор
            </a>
        </div>
    </div>
    
    <!-- Фильтры поиска -->
    <div class="card mb-4">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/contracts/search" method="get" class="row g-3">
                <div class="col-md-3">
                    <label for="startDate" class="form-label">Дата начала с</label>
                    <input type="date" class="form-control" id="startDate" name="startDate" 
                           value="<fmt:formatDate value='${searchStartDate}' pattern='yyyy-MM-dd'/>">
                </div>
                <div class="col-md-3">
                    <label for="endDate" class="form-label">Дата окончания по</label>
                    <input type="date" class="form-control" id="endDate" name="endDate"
                           value="<fmt:formatDate value='${searchEndDate}' pattern='yyyy-MM-dd'/>">
                </div>
                <div class="col-md-2">
                    <label for="type" class="form-label">Тип страхования</label>
                    <select class="form-select" id="type" name="type">
                        <option value="">Все типы</option>
                        <c:forEach var="type" items="${insuranceTypes}">
                            <option value="${type.code}" 
                                    ${searchType == type.code ? 'selected' : ''}>
                                ${type.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <label for="status" class="form-label">Статус</label>
                    <select class="form-select" id="status" name="status">
                        <option value="">Все статусы</option>
                        <c:forEach var="status" items="${contractStatuses}">
                            <option value="${status.code}" 
                                    ${searchStatus == status.code ? 'selected' : ''}>
                                ${status.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-search me-1"></i>Найти
                    </button>
                </div>
            </form>
            
            <c:if test="${not empty searchStartDate or not empty searchEndDate or not empty searchType or not empty searchStatus}">
                <div class="mt-3">
                    <small class="text-muted">
                        Активные фильтры:
                        <c:if test="${not empty searchStartDate}">
                            <span class="badge bg-info me-1">
                                Начало с: <fmt:formatDate value="${searchStartDate}" pattern="dd.MM.yyyy"/>
                            </span>
                        </c:if>
                        <c:if test="${not empty searchEndDate}">
                            <span class="badge bg-info me-1">
                                Окончание по: <fmt:formatDate value="${searchEndDate}" pattern="dd.MM.yyyy"/>
                            </span>
                        </c:if>
                        <c:if test="${not empty searchType}">
                            <c:forEach var="type" items="${insuranceTypes}">
                                <c:if test="${type.code == searchType}">
                                    <span class="badge bg-info me-1">Тип: ${type.name}</span>
                                </c:if>
                            </c:forEach>
                        </c:if>
                        <c:if test="${not empty searchStatus}">
                            <c:forEach var="status" items="${contractStatuses}">
                                <c:if test="${status.code == searchStatus}">
                                    <span class="badge bg-info me-1">Статус: ${status.name}</span>
                                </c:if>
                            </c:forEach>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/contracts" class="text-danger">
                            <i class="fas fa-times"></i> Сбросить
                        </a>
                    </small>
                </div>
            </c:if>
        </div>
    </div>
    
    <!-- Таблица договоров -->
    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">Список договоров</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>№ договора</th>
                            <th>Клиент</th>
                            <th>Тип страхования</th>
                            <th>Статус</th>
                            <th>Период действия</th>
                            <th>Премия</th>
                            <th>Дата оформления</th>
                            <th class="text-end">Действия</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="contract" items="${contracts}">
                            <tr>
                                <td>
                                    <strong>
                                        <a href="${pageContext.request.contextPath}/contracts/view/${contract.id}">
                                            ${contract.contractNumber}
                                        </a>
                                    </strong>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/clients/view/${contract.client.id}">
                                        ${contract.client.fullName}
                                    </a>
                                </td>
                                <td>${contract.insuranceType.name}</td>
                                <td>
                                    <span class="badge 
                                        <c:choose>
                                            <c:when test="${contract.status.code == 'ACTIVE'}">bg-success</c:when>
                                            <c:when test="${contract.status.code == 'EXPIRED'}">bg-warning</c:when>
                                            <c:when test="${contract.status.code == 'TERMINATED'}">bg-danger</c:when>
                                            <c:when test="${contract.status.code == 'DRAFT'}">bg-secondary</c:when>
                                            <c:otherwise>bg-info</c:otherwise>
                                        </c:choose>">
                                        ${contract.status.name}
                                    </span>
                                </td>
                                <td>
                                    <fmt:formatDate value="${contract.startDate}" pattern="dd.MM.yyyy"/>
                                    <br>
                                    <small class="text-muted">по</small>
                                    <br>
                                    <fmt:formatDate value="${contract.endDate}" pattern="dd.MM.yyyy"/>
                                </td>
                                <td class="currency-field">
                                    <fmt:formatNumber value="${contract.premiumAmount}" 
                                                      type="currency" currencySymbol="₽"/>
                                </td>
                                <td class="date-field">
                                    <fmt:formatDate value="${contract.createdAt}" pattern="dd.MM.yyyy"/>
                                </td>
                                <td class="text-end table-actions">
                                    <a href="${pageContext.request.contextPath}/contracts/view/${contract.id}" 
                                       class="btn btn-sm btn-info btn-action" title="Просмотр">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/contracts/edit/${contract.id}" 
                                       class="btn btn-sm btn-warning btn-action" title="Редактировать">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    
                                    <div class="btn-group">
                                        <button type="button" class="btn btn-sm btn-outline-primary dropdown-toggle" 
                                                data-bs-toggle="dropdown" title="Изменить статус">
                                            <i class="fas fa-exchange-alt"></i>
                                        </button>
                                        <ul class="dropdown-menu">
                                            <c:forEach var="status" items="${contractStatuses}">
                                                <c:if test="${status.code != contract.status.code}">
                                                    <li>
                                                        <a class="dropdown-item" 
                                                           href="${pageContext.request.contextPath}/contracts/change-status/${contract.id}?status=${status.code}">
                                                            ${status.name}
                                                        </a>
                                                    </li>
                                                </c:if>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                    
                                    <a href="${pageContext.request.contextPath}/contracts/delete/${contract.id}" 
                                       class="btn btn-sm btn-danger btn-action confirm-delete" title="Удалить">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty contracts}">
                            <tr>
                                <td colspan="8" class="text-center text-muted py-4">
                                    <i class="fas fa-file-contract fa-2x mb-3"></i><br>
                                    Договоры не найдены
                                    <c:if test="${not empty searchStartDate or not empty searchEndDate or not empty searchType or not empty searchStatus}">
                                        <br>
                                        <small>Попробуйте изменить параметры поиска</small>
                                    </c:if>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            
            <!-- Пагинация и статистика -->
            <c:if test="${not empty contracts and contracts.size() > 0}">
                <div class="d-flex justify-content-between align-items-center mt-3">
                    <div class="text-muted">
                        Найдено ${contracts.size()} договоров
                        <c:if test="${not empty client}">
                            у клиента ${client.fullName}
                        </c:if>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/contracts/export" class="btn btn-sm btn-outline-secondary">
                            <i class="fas fa-download me-1"></i>Экспорт в Excel
                        </a>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</main>

<jsp:include page="../layout/footer.jsp"/>