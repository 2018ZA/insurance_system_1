<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../layout/header.jsp"/>
<jsp:include page="../layout/sidebar.jsp"/>

<main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">${pageTitle}</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <a href="${pageContext.request.contextPath}/users" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-1"></i>Назад к списку
            </a>
        </div>
    </div>
    
    <div class="row">
        <div class="col-md-6 mx-auto">
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
                    
                    <form action="${formAction}" method="post" class="needs-validation" novalidate>
                        <input type="hidden" name="id" value="${user.id}">
                        
                        <div class="row mb-3">
                            <div class="col-md-12">
                                <label for="login" class="form-label">
                                    Логин <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" id="login" name="login" 
                                       value="${user.login}" required 
                                       <c:if test="${not empty user.login}">readonly</c:if>>
                                <div class="invalid-feedback">
                                    Пожалуйста, введите логин.
                                </div>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-12">
                                <label for="fullName" class="form-label">
                                    ФИО <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" id="fullName" name="fullName" 
                                       value="${user.fullName}" required>
                                <div class="invalid-feedback">
                                    Пожалуйста, введите ФИО.
                                </div>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="password" class="form-label">
                                    <c:choose>
                                        <c:when test="${empty user.id}">Пароль <span class="text-danger">*</span></c:when>
                                        <c:otherwise>Новый пароль (оставьте пустым, если не нужно менять)</c:otherwise>
                                    </c:choose>
                                </label>
                                <input type="password" class="form-control" id="password" name="password"
                                       <c:if test="${empty user.id}">required</c:if>>
                            </div>
                            <div class="col-md-6">
                                <label for="confirmPassword" class="form-label">
                                    Подтверждение пароля <span class="text-danger">*</span>
                                </label>
                                <input type="password" class="form-control" id="confirmPassword" 
                                       name="confirmPassword" 
                                       <c:if test="${empty user.id}">required</c:if>>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-12">
                                <label for="roleCode" class="form-label">
                                    Роль <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="roleCode" name="roleCode" required>
                                    <option value="">Выберите роль</option>
                                    <c:forEach var="role" items="${roles}">
                                        <option value="${role.code}" 
                                                ${user.role != null and user.role.code == role.code ? 'selected' : ''}>
                                            ${role.name}
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback">
                                    Пожалуйста, выберите роль.
                                </div>
                            </div>
                        </div>
                        
                        <c:if test="${not empty user.id}">
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="active" 
                                               name="active" ${user.active ? 'checked' : ''}>
                                        <label class="form-check-label" for="active">
                                            Активен
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        
                        <div class="row">
                            <div class="col-md-12">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-1"></i>Сохранить
                                </button>
                                <button type="reset" class="btn btn-secondary">Очистить</button>
                                <a href="${pageContext.request.contextPath}/users" class="btn btn-outline-secondary">
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
    // Валидация пароля
    var password = document.getElementById("password");
    var confirmPassword = document.getElementById("confirmPassword");
    
    function validatePassword() {
        if (password.value != confirmPassword.value) {
            confirmPassword.setCustomValidity("Пароли не совпадают");
        } else {
            confirmPassword.setCustomValidity('');
        }
    }
    
    password.onchange = validatePassword;
    confirmPassword.onkeyup = validatePassword;
    
    // Валидация формы
    (function() {
        'use strict'
        
        var forms = document.querySelectorAll('.needs-validation')
        
        Array.prototype.slice.call(forms)
            .forEach(function(form) {
                form.addEventListener('submit', function(event) {
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }
                    
                    form.classList.add('was-validated')
                }, false)
            })
    })()
</script>

<jsp:include page="../layout/footer.jsp"/>