<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <nav class="col-md-3 col-lg-2 d-md-block sidebar collapse">
            <div class="position-sticky pt-3">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link ${pageTitle == 'Панель управления' ? 'active' : ''}" 
                           href="${pageContext.request.contextPath}/dashboard">
                            <i class="fas fa-tachometer-alt me-2"></i>Панель управления
                        </a>
                    </li>
                    
                    <li class="nav-item">
                        <a class="nav-link ${pageTitle == 'Клиенты' ? 'active' : ''}" 
                           href="${pageContext.request.contextPath}/clients">
                            <i class="fas fa-users me-2"></i>Клиенты
                        </a>
                    </li>
                    
                    <li class="nav-item">
                        <a class="nav-link ${pageTitle == 'Договоры страхования' ? 'active' : ''}" 
                           href="${pageContext.request.contextPath}/contracts">
                            <i class="fas fa-file-contract me-2"></i>Договоры
                        </a>
                    </li>
                    
                    <c:if test="${sessionScope.currentUser.role.code == 'ADMIN' || sessionScope.currentUser.role.code == 'MANAGER'}">
                        <li class="nav-item">
                            <a class="nav-link ${pageTitle == 'Пользователи системы' ? 'active' : ''}" 
                               href="${pageContext.request.contextPath}/users">
                                <i class="fas fa-user-cog me-2"></i>Пользователи
                            </a>
                        </li>
                    </c:if>
                    
                    <li class="nav-item">
                        <a class="nav-link ${pageTitle == 'Статистика' ? 'active' : ''}" 
                           href="${pageContext.request.contextPath}/statistics">
                            <i class="fas fa-chart-bar me-2"></i>Статистика
                        </a>
                    </li>
                    
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/about">
                            <i class="fas fa-info-circle me-2"></i>Об авторе
                        </a>
                    </li>
                </ul>
                
                <!-- Статистика в сайдбаре -->
                <div class="mt-5">
                    <h6 class="sidebar-heading px-3 mt-4 mb-1 text-muted">
                        <span>Быстрая статистика</span>
                    </h6>
                    <div class="px-3">
                        <small class="text-muted">
                            <i class="fas fa-users me-1"></i> Клиентов: <span id="clientsCount">0</span>
                        </small><br>
                        <small class="text-muted">
                            <i class="fas fa-file-contract me-1"></i> Договоров: <span id="contractsCount">0</span>
                        </small>
                    </div>
                </div>
            </div>
        </nav>