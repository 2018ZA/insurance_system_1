<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="layout/header.jsp"/>
<jsp:include page="layout/sidebar.jsp"/>

<main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Об авторе</h1>
    </div>
    
    <div class="row">
        <div class="col-md-8 mx-auto">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">
                        <i class="fas fa-user-circle me-2"></i>Информация об авторе
                    </h4>
                </div>
                <div class="card-body">
                    <!-- Личная информация -->
                    <div class="row mb-4">
                        <div class="col-md-3 text-center">
                            <div class="avatar-placeholder mb-3">
                                <i class="fas fa-user fa-5x text-primary"></i>
                            </div>
                            <h5>${authorName}</h5>
                            <p class="text-muted">Разработчик</p>
                        </div>
                        <div class="col-md-9">
                            <h5 class="mb-3">
                                <i class="fas fa-graduation-cap me-2"></i>Образование
                            </h5>
                            <div class="mb-3">
                                <strong>Учебное заведение:</strong> ${university}<br>
                                <strong>Номер группы:</strong> ${groupNumber}
                            </div>
                            
                            <h5 class="mb-3">
                                <i class="fas fa-address-card me-2"></i>Контактная информация
                            </h5>
                            <div class="mb-3">
                                <p>
                                    <i class="fas fa-envelope me-2"></i>
                                    <strong>Email:</strong> 
                                    <a href="mailto:${email}">${email}</a>
                                </p>
                                <p>
                                    <i class="fas fa-phone me-2"></i>
                                    <strong>Телефон:</strong> 
                                    <a href="tel:${phone}">${phone}</a>
                                </p>
                            </div>
                        </div>
                    </div>
                    
                    <hr>
                    
                    <!-- Информация о проекте -->
                    <h5 class="mb-3">
                        <i class="fas fa-project-diagram me-2"></i>О проекте
                    </h5>
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <div class="card bg-light">
                                <div class="card-body">
                                    <h6>
                                        <i class="fas fa-calendar-alt me-2"></i>Сроки разработки
                                    </h6>
                                    <p class="mb-1"><strong>Начало работ:</strong> ${startDate}</p>
                                    <p class="mb-0"><strong>Завершение работ:</strong> ${endDate}</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card bg-light">
                                <div class="card-body">
                                    <h6>
                                        <i class="fas fa-shield-alt me-2"></i>Предметная область
                                    </h6>
                                    <p class="mb-0">Система автоматизации страховой компании "InsurancePro"</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Используемые технологии -->
                    <h5 class="mb-3">
                        <i class="fas fa-code me-2"></i>Используемые технологии
                    </h5>
                    <div class="row mb-4">
                        <c:forEach var="tech" items="${technologies}" varStatus="loop">
                            <div class="col-md-4 mb-2">
                                <div class="card tech-card">
                                    <div class="card-body text-center py-3">
                                        <c:choose>
                                            <c:when test="${tech == 'Spring MVC'}">
                                                <i class="fab fa-java fa-2x text-danger mb-2"></i>
                                            </c:when>
                                            <c:when test="${tech == 'Hibernate/JPA'}">
                                                <i class="fas fa-database fa-2x text-primary mb-2"></i>
                                            </c:when>
                                            <c:when test="${tech == 'PostgreSQL'}">
                                                <i class="fas fa-server fa-2x text-info mb-2"></i>
                                            </c:when>
                                            <c:when test="${tech == 'JavaScript'}">
                                                <i class="fab fa-js-square fa-2x text-warning mb-2"></i>
                                            </c:when>
                                            <c:when test="${tech == 'REST API'}">
                                                <i class="fas fa-exchange-alt fa-2x text-success mb-2"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-cog fa-2x text-secondary mb-2"></i>
                                            </c:otherwise>
                                        </c:choose>
                                        <h6 class="mb-0">${tech}</h6>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <!-- Функциональные возможности -->
                    <h5 class="mb-3">
                        <i class="fas fa-list-check me-2"></i>Функциональные возможности системы
                    </h5>
                    <div class="row">
                        <div class="col-md-6">
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item">
                                    <i class="fas fa-check text-success me-2"></i>
                                    Управление клиентами (CRUD операции)
                                </li>
                                <li class="list-group-item">
                                    <i class="fas fa-check text-success me-2"></i>
                                    Оформление договоров страхования
                                </li>
                                <li class="list-group-item">
                                    <i class="fas fa-check text-success me-2"></i>
                                    Разделение ролей пользователей
                                </li>
                                <li class="list-group-item">
                                    <i class="fas fa-check text-success me-2"></i>
                                    Поиск и фильтрация данных
                                </li>
                            </ul>
                        </div>
                        <div class="col-md-6">
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item">
                                    <i class="fas fa-check text-success me-2"></i>
                                    Статистика и отчетность
                                </li>
                                <li class="list-group-item">
                                    <i class="fas fa-check text-success me-2"></i>
                                    Адаптивный пользовательский интерфейс
                                </li>
                                <li class="list-group-item">
                                    <i class="fas fa-check text-success me-2"></i>
                                    Валидация данных на стороне клиента и сервера
                                </li>
                                <li class="list-group-item">
                                    <i class="fas fa-check text-success me-2"></i>
                                    Пагинация и сортировка данных
                                </li>
                            </ul>
                        </div>
                    </div>
                    
                    <hr class="my-4">
                    
                    <!-- Ссылки и контакты -->
                    <div class="row">
                        <div class="col-md-12 text-center">
                            <h6 class="mb-3">Ссылки и контакты</h6>
                            <div class="d-flex justify-content-center gap-3">
                                <a href="https://github.com" class="btn btn-outline-dark" target="_blank">
                                    <i class="fab fa-github me-2"></i>GitHub
                                </a>
                                <a href="https://linkedin.com" class="btn btn-outline-primary" target="_blank">
                                    <i class="fab fa-linkedin me-2"></i>LinkedIn
                                </a>
                                <a href="mailto:${email}" class="btn btn-outline-danger">
                                    <i class="fas fa-envelope me-2"></i>Email
                                </a>
                            </div>
                            <p class="text-muted mt-3 mb-0">
                                <small>
                                    <i class="fas fa-info-circle me-1"></i>
                                    Проект разработан в учебных целях. Все права защищены.
                                </small>
                            </p>
                        </div>
                    </div>
                </div>
                <div class="card-footer text-center text-muted">
                    <small>
                        &copy; ${startDate} - ${endDate} | ${university} | Группа ${groupNumber}
                    </small>
                </div>
            </div>
        </div>
    </div>
</main>

<style>
    .avatar-placeholder {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        background-color: #f8f9fa;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto;
        border: 3px solid #007bff;
    }
    .tech-card {
        transition: transform 0.3s;
        border: 1px solid #dee2e6;
    }
    .tech-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
    .list-group-item {
        border: none;
        padding: 8px 0;
    }
</style>

<jsp:include page="layout/footer.jsp"/>