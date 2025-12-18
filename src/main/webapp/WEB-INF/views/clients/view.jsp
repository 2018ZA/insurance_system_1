<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../layout/header.jsp"/>
<jsp:include page="../layout/sidebar.jsp"/>

<main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Информация о клиенте</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <a href="${pageContext.request.contextPath}/clients/edit/${client.id}" class="btn btn-warning me-2">
                <i class="fas fa-edit me-1"></i>Редактировать
            </a>
            <a href="${pageContext.request.contextPath}/contracts/add?clientId=${client.id}" class="btn btn-success me-2">
                <i class="fas fa-file-contract me-1"></i>Оформить договор
            </a>
            <a href="${pageContext.request.contextPath}/clients" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-1"></i>Назад
            </a>
        </div>
    </div>
    
    <div class="row">
        <!-- Основная информация -->
        <div class="col-md-8">
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0">Основная информация</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-muted">ФИО</label>
                            <p class="h5">${client.fullName}</p>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-muted">Паспортные данные</label>
                            <p class="h5">${client.fullPassport}</p>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-muted">Телефон</label>
                            <p class="h5">
                                <i class="fas fa-phone me-2"></i>${client.phone}
                            </p>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-muted">Email</label>
                            <p class="h5">
                                <c:choose>
                                    <c:when test="${not empty client.email}">
                                        <i class="fas fa-envelope me-2"></i>${client.email}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Не указан</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-muted">Дата регистрации</label>
                            <p class="h5">
                                <i class="fas fa-calendar-alt me-2"></i>
                                <fmt:formatDate value="${client.registrationDate}" pattern="dd.MM.yyyy HH:mm"/>
                            </p>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-muted">Количество договоров</label>
                            <p class="h5">
                                <span class="badge bg-primary fs-6">${client.contracts.size()}</span>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Договоры клиента -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Договоры клиента</h5>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty client.contracts}">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Номер договора</th>
                                            <th>Тип страхования</th>
                                            <th>Статус</th>
                                            <th>Период действия</th>
                                            <th>Премия</th>
                                            <th>Действия</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="contract" items="${client.contracts}">
                                            <tr>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/contracts/view/${contract.id}">
                                                        ${contract.contractNumber}
                                                    </a>
                                                </td>
                                                <td>${contract.insuranceType.name}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${contract.status.code == 'ACTIVE'}">
                                                            <span class="badge bg-success">${contract.status.name}</span>
                                                        </c:when>
                                                        <c:when test="${contract.status.code == 'EXPIRED'}">
                                                            <span class="badge bg-warning">${contract.status.name}</span>
                                                        </c:when>
                                                        <c:when test="${contract.status.code == 'TERMINATED'}">
                                                            <span class="badge bg-danger">${contract.status.name}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">${contract.status.name}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${contract.startDate}" pattern="dd.MM.yyyy"/>
                                                     - 
                                                    <fmt:formatDate value="${contract.endDate}" pattern="dd.MM.yyyy"/>
                                                </td>
                                                <td>
                                                    <fmt:formatNumber value="${contract.premiumAmount}" 
                                                                      type="currency" currencySymbol="₽"/>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/contracts/view/${contract.id}" 
                                                       class="btn btn-sm btn-info" title="Просмотр">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4">
                                <i class="fas fa-file-contract fa-3x text-muted mb-3"></i>
                                <p class="text-muted">У клиента нет оформленных договоров</p>
                                <a href="${pageContext.request.contextPath}/contracts/add?clientId=${client.id}" 
                                   class="btn btn-primary">
                                    <i class="fas fa-plus me-1"></i>Оформить первый договор
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        
        <!-- Дополнительная информация -->
        <div class="col-md-4">
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0">Быстрые действия</h5>
                </div>
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/contracts/add?clientId=${client.id}" 
                           class="btn btn-success">
                            <i class="fas fa-file-contract me-2"></i>Оформить договор
                        </a>
                        <a href="tel:${client.phone}" class="btn btn-outline-primary">
                            <i class="fas fa-phone me-2"></i>Позвонить
                        </a>
                        <c:if test="${not empty client.email}">
                            <a href="mailto:${client.email}" class="btn btn-outline-secondary">
                                <i class="fas fa-envelope me-2"></i>Написать email
                            </a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/clients/edit/${client.id}" 
                           class="btn btn-outline-warning">
                            <i class="fas fa-edit me-2"></i>Редактировать
                        </a>
                        <a href="${pageContext.request.contextPath}/clients/delete/${client.id}" 
                           class="btn btn-outline-danger confirm-delete">
                            <i class="fas fa-trash me-2"></i>Удалить
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Статистика</h5>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <label class="form-label text-muted">Всего договоров</label>
                        <h4>${client.contracts.size()}</h4>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-muted">Активных договоров</label>
                        <h4>
                            <c:set var="activeCount" value="0"/>
                            <c:forEach var="contract" items="${client.contracts}">
                                <c:if test="${contract.status.code == 'ACTIVE'}">
                                    <c:set var="activeCount" value="${activeCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${activeCount}
                        </h4>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-muted">Общая сумма премий</label>
                        <h4>
                            <c:set var="totalPremium" value="0"/>
                            <c:forEach var="contract" items="${client.contracts}">
                                <c:set var="totalPremium" value="${totalPremium + contract.premiumAmount}"/>
                            </c:forEach>
                            <fmt:formatNumber value="${totalPremium}" type="currency" currencySymbol="₽"/>
                        </h4>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../layout/footer.jsp"/>