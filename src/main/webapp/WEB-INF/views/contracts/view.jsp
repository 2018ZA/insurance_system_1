<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../layout/header.jsp"/>
<jsp:include page="../layout/sidebar.jsp"/>

<main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Договор №${contract.contractNumber}</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <div class="btn-group me-2">
                <a href="${pageContext.request.contextPath}/contracts/edit/${contract.id}" class="btn btn-warning">
                    <i class="fas fa-edit me-1"></i>Редактировать
                </a>
                <a href="${pageContext.request.contextPath}/contracts" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-1"></i>Назад
                </a>
            </div>
            <div class="dropdown">
                <button class="btn btn-outline-primary dropdown-toggle" type="button" 
                        data-bs-toggle="dropdown">
                    <i class="fas fa-print me-1"></i>Печать
                </button>
                <ul class="dropdown-menu">
                    <li><a class="dropdown-item" href="#" onclick="window.print()">
                        <i class="fas fa-print me-2"></i>Печать договора
                    </a></li>
                    <li><a class="dropdown-item" href="#">
                        <i class="fas fa-file-pdf me-2"></i>Скачать PDF
                    </a></li>
                </ul>
            </div>
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
                            <label class="form-label text-muted">Номер договора</label>
                            <p class="h5">${contract.contractNumber}</p>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-muted">Статус</label>
                            <p class="h5">
                                <span class="badge 
                                    <c:choose>
                                        <c:when test="${contract.status.code == 'ACTIVE'}">bg-success</c:when>
                                        <c:when test="${contract.status.code == 'EXPIRED'}">bg-warning</c:when>
                                        <c:when test="${contract.status.code == 'TERMINATED'}">bg-danger</c:when>
                                        <c:when test="${contract.status.code == 'DRAFT'}">bg-secondary</c:when>
                                        <c:otherwise>bg-info</c:otherwise>
                                    </c:choose> fs-6">
                                    ${contract.status.name}
                                </span>
                            </p>
                        </div>
                        <div class="col-md-12 mb-3">
                            <label class="form-label text-muted">Клиент</label>
                            <p class="h5">
                                <a href="${pageContext.request.contextPath}/clients/view/${contract.client.id}">
                                    ${contract.client.fullName}
                                </a>
                            </p>
                            <p class="text-muted mb-0">
                                <i class="fas fa-phone me-1"></i>${contract.client.phone}
                                <c:if test="${not empty contract.client.email}">
                                    <span class="ms-3">
                                        <i class="fas fa-envelope me-1"></i>${contract.client.email}
                                    </span>
                                </c:if>
                            </p>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-muted">Тип страхования</label>
                            <p class="h5">${contract.insuranceType.name}</p>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-muted">Агент</label>
                            <p class="h5">
                                <c:choose>
                                    <c:when test="${not empty contract.agent}">
                                        ${contract.agent.fullName}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Не назначен</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-muted">Период действия</label>
                            <p class="h5">
                                <fmt:formatDate value="${contract.startDate}" pattern="dd.MM.yyyy"/>
                                <br>
                                <small class="text-muted">по</small>
                                <br>
                                <fmt:formatDate value="${contract.endDate}" pattern="dd.MM.yyyy"/>
                            </p>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-muted">Осталось дней</label>
                            <p class="h5">
                                <c:set var="now" value="<%=new java.util.Date()%>"/>
                                <c:set var="daysLeft" value="${(contract.endDate.time - now.time) / (1000 * 60 * 60 * 24)}"/>
                                <c:choose>
                                    <c:when test="${daysLeft > 0}">
                                        <span class="text-success">
                                            <fmt:formatNumber value="${daysLeft}" maxFractionDigits="0"/> дней
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-danger">Истек</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-muted">Страховая премия</label>
                            <p class="h3 text-primary">
                                <fmt:formatNumber value="${contract.premiumAmount}" 
                                                  type="currency" currencySymbol="₽"/>
                            </p>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-muted">Страховая сумма</label>
                            <p class="h3 text-success">
                                <fmt:formatNumber value="${contract.insuredAmount}" 
                                                  type="currency" currencySymbol="₽"/>
                            </p>
                        </div>
                        <div class="col-md-12 mb-3">
                            <label class="form-label text-muted">Дата оформления</label>
                            <p class="h5">
                                <i class="fas fa-calendar-alt me-2"></i>
                                <fmt:formatDate value="${contract.createdAt}" pattern="dd.MM.yyyy HH:mm"/>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- История изменений статуса -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Действия с договором</h5>
                </div>
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <div class="btn-group w-100" role="group">
                            <c:forEach var="status" items="${contractStatuses}">
                                <c:if test="${status.code != contract.status.code}">
                                    <a href="${pageContext.request.contextPath}/contracts/change-status/${contract.id}?status=${status.code}" 
                                       class="btn btn-outline-primary">
                                        ${status.name}
                                    </a>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Дополнительная информация и действия -->
        <div class="col-md-4">
            <!-- Быстрые действия -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0">Быстрые действия</h5>
                </div>
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/contracts/edit/${contract.id}" 
                           class="btn btn-warning">
                            <i class="fas fa-edit me-2"></i>Редактировать
                        </a>
                        <a href="${pageContext.request.contextPath}/clients/view/${contract.client.id}" 
                           class="btn btn-info">
                            <i class="fas fa-user me-2"></i>Карточка клиента
                        </a>
                        <c:if test="${not empty contract.agent}">
                            <a href="#" class="btn btn-outline-primary">
                                <i class="fas fa-user-tie me-2"></i>Связаться с агентом
                            </a>
                        </c:if>
                        <a href="tel:${contract.client.phone}" class="btn btn-outline-success">
                            <i class="fas fa-phone me-2"></i>Позвонить клиенту
                        </a>
                        <a href="${pageContext.request.contextPath}/contracts/delete/${contract.id}" 
                           class="btn btn-outline-danger confirm-delete">
                            <i class="fas fa-trash me-2"></i>Удалить договор
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Информация о договоре -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Информация</h5>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <label class="form-label text-muted">ID договора</label>
                        <p>${contract.id}</p>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-muted">Дата создания</label>
                        <p>
                            <fmt:formatDate value="${contract.createdAt}" pattern="dd.MM.yyyy HH:mm:ss"/>
                        </p>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-muted">Статус активности</label>
                        <p>
                            <c:choose>
                                <c:when test="${contract.active}">
                                    <span class="badge bg-success">Активен</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger">Неактивен</span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-muted">Дней до окончания</label>
                        <p>
                            <c:choose>
                                <c:when test="${daysLeft > 0}">
                                    <span class="text-success">
                                        <fmt:formatNumber value="${daysLeft}" maxFractionDigits="0"/> дней
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-danger">Договор истек</span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>
            </div>
            
            <!-- QR код для быстрого доступа -->
            <div class="card mt-4">
                <div class="card-body text-center">
                    <div id="qrcode"></div>
                    <p class="text-muted mt-2 mb-0">QR-код для быстрого доступа к договору</p>
                    <small class="text-muted">Отсканируйте для просмотра на мобильном устройстве</small>
                </div>
            </div>
        </div>
    </div>
</main>

<script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
<script>
    // Генерация QR-кода
    new QRCode(document.getElementById("qrcode"), {
        text: window.location.href,
        width: 128,
        height: 128
    });
</script>

<jsp:include page="../layout/footer.jsp"/>