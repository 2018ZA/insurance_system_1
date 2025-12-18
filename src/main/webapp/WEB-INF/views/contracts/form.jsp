<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../layout/header.jsp"/>
<jsp:include page="../layout/sidebar.jsp"/>

<main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">${pageTitle}</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <a href="${pageContext.request.contextPath}/contracts" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-1"></i>Назад к списку
            </a>
        </div>
    </div>
    
    <div class="row">
        <div class="col-md-10 mx-auto">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">${pageTitle}</h5>
                </div>
                <div class="card-body">
                    <c:if test="${not empty param.error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${param.error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <form action="${formAction}" method="post">
                        <input type="hidden" name="id" value="${contract.id}">
                        
                        <!-- Номер договора -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="contractNumber" class="form-label">Номер договора</label>
                                <input type="text" class="form-control" id="contractNumber" 
                                       name="contractNumber" value="${contract.contractNumber}"
                                       <c:if test="${not empty contract.contractNumber}">readonly</c:if>>
                                <div class="form-text">
                                    <c:if test="${empty contract.contractNumber}">
                                        Будет сгенерирован автоматически при сохранении
                                    </c:if>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Клиент и тип страхования -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="clientId" class="form-label">
                                    Клиент <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="clientId" name="clientId" required>
                                    <option value="">Выберите клиента</option>
                                    <c:forEach var="client" items="${clients}">
                                        <option value="${client.id}" 
                                                ${contract.client != null and contract.client.id == client.id ? 'selected' : ''}>
                                            ${client.fullName} (${client.phone})
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback">
                                    Пожалуйста, выберите клиента.
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="insuranceTypeCode" class="form-label">
                                    Тип страхования <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="insuranceTypeCode" name="insuranceTypeCode" required>
                                    <option value="">Выберите тип страхования</option>
                                    <c:forEach var="type" items="${insuranceTypes}">
                                        <option value="${type.code}" 
                                                ${contract.insuranceType != null and contract.insuranceType.code == type.code ? 'selected' : ''}>
                                            ${type.name}
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback">
                                    Пожалуйста, выберите тип страхования.
                                </div>
                            </div>
                        </div>
                        
                        <!-- Даты -->
                        <div class="row mb-3">
                            <div class="col-md-3">
                                <label for="startDate" class="form-label">
                                    Дата начала <span class="text-danger">*</span>
                                </label>
                                <input type="date" class="form-control" id="startDate" name="startDate" 
                                       value="<fmt:formatDate value='${contract.startDate}' pattern='yyyy-MM-dd'/>" 
                                       required>
                            </div>
                            <div class="col-md-3">
                                <label for="endDate" class="form-label">
                                    Дата окончания <span class="text-danger">*</span>
                                </label>
                                <input type="date" class="form-control" id="endDate" name="endDate" 
                                       value="<fmt:formatDate value='${contract.endDate}' pattern='yyyy-MM-dd'/>" 
                                       required>
                            </div>
                            <div class="col-md-3">
                                <label for="agentId" class="form-label">Агент</label>
                                <select class="form-select" id="agentId" name="agentId">
                                    <option value="">Не назначен</option>
                                    <c:forEach var="agent" items="${agents}">
                                        <option value="${agent.id}" 
                                                ${contract.agent != null and contract.agent.id == agent.id ? 'selected' : ''}>
                                            ${agent.fullName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="statusCode" class="form-label">Статус</label>
                                <select class="form-select" id="statusCode" name="statusCode">
                                    <c:forEach var="status" items="${contractStatuses}">
                                        <option value="${status.code}" 
                                                ${contract.status != null and contract.status.code == status.code ? 'selected' : ''}>
                                            ${status.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        
                        <!-- Суммы -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="premiumAmount" class="form-label">
                                    Страховая премия (₽) <span class="text-danger">*</span>
                                </label>
                                <input type="number" class="form-control" id="premiumAmount" 
                                       name="premiumAmount" step="0.01" min="0"
                                       value="${contract.premiumAmount}" required>
                            </div>
                            <div class="col-md-6">
                                <label for="insuredAmount" class="form-label">
                                    Страховая сумма (₽) <span class="text-danger">*</span>
                                </label>
                                <input type="number" class="form-control" id="insuredAmount" 
                                       name="insuredAmount" step="0.01" min="0"
                                       value="${contract.insuredAmount}" required>
                            </div>
                        </div>
                        
                        <!-- Кнопки -->
                        <div class="row">
                            <div class="col-md-12">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-1"></i>Сохранить
                                </button>
                                <button type="reset" class="btn btn-secondary">Очистить</button>
                                <a href="${pageContext.request.contextPath}/contracts" class="btn btn-outline-secondary">
                                    Отмена
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    // Валидация дат
    document.getElementById('startDate').addEventListener('change', function() {
        var startDate = new Date(this.value);
        var endDateInput = document.getElementById('endDate');
        var endDate = new Date(endDateInput.value);
        
        if (endDate <= startDate) {
            // Устанавливаем дату окончания на 1 год позже
            startDate.setFullYear(startDate.getFullYear() + 1);
            endDateInput.valueAsDate = startDate;
        }
    });
    
    // Валидация формы
    (function() {
        'use strict'
        
        var forms = document.querySelectorAll('form')
        
        Array.prototype.slice.call(forms)
            .forEach(function(form) {
                form.addEventListener('submit', function(event) {
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }
                    
                    // Дополнительная валидация дат
                    var startDate = new Date(document.getElementById('startDate').value);
                    var endDate = new Date(document.getElementById('endDate').value);
                    
                    if (endDate <= startDate) {
                        alert('Дата окончания должна быть позже даты начала');
                        event.preventDefault();
                        return false;
                    }
                    
                    form.classList.add('was-validated')
                }, false)
            })
    })()
</script>

<jsp:include page="../layout/footer.jsp"/>