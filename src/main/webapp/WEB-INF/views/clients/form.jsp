<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../layout/header.jsp"/>
<jsp:include page="../layout/sidebar.jsp"/>

<main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">${pageTitle}</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <a href="${pageContext.request.contextPath}/clients" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-1"></i>Назад к списку
            </a>
        </div>
    </div>
    
    <div class="row">
        <div class="col-md-8 mx-auto">
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
                        <input type="hidden" name="id" value="${client.id}">
                        
                        <div class="row mb-3">
                            <div class="col-md-12">
                                <label for="fullName" class="form-label">
                                    ФИО <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" id="fullName" name="fullName" 
                                       value="${client.fullName}" required>
                                <div class="invalid-feedback">
                                    Пожалуйста, введите ФИО клиента.
                                </div>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="passportSeries" class="form-label">Серия паспорта</label>
                                <input type="text" class="form-control" id="passportSeries" 
                                       name="passportSeries" value="${client.passportSeries}">
                            </div>
                            <div class="col-md-6">
                                <label for="passportNumber" class="form-label">Номер паспорта</label>
                                <input type="text" class="form-control" id="passportNumber" 
                                       name="passportNumber" value="${client.passportNumber}">
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="phone" class="form-label">
                                    Телефон <span class="text-danger">*</span>
                                </label>
                                <input type="tel" class="form-control" id="phone" name="phone" 
                                       value="${client.phone}" required>
                                <div class="invalid-feedback">
                                    Пожалуйста, введите номер телефона.
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" 
                                       value="${client.email}">
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-12">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-1"></i>Сохранить
                                </button>
                                <a href="${pageContext.request.contextPath}/clients" class="btn btn-secondary">
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