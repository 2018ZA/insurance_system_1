<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../layout/header.jsp"/>
<jsp:include page="../layout/sidebar.jsp"/>

<main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Пользователи системы</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <c:if test="${sessionScope.currentUser.role.code == 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/users/add" class="btn btn-primary">
                    <i class="fas fa-user-plus me-1"></i>Добавить пользователя
                </a>
            </c:if>
        </div>
    </div>
    
    <!-- Таблица пользователей -->
    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">Список пользователей</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Логин</th>
                            <th>ФИО</th>
                            <th>Роль</th>
                            <th>Статус</th>
                            <th>Дата регистрации</th>
                            <th>Договоров</th>
                            <th class="text-end">Действия</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${users}">
                            <tr>
                                <td>
                                    <strong>${user.login}</strong>
                                </td>
                                <td>${user.fullName}</td>
                                <td>
                                    <span class="badge 
                                        <c:choose>
                                            <c:when test="${user.role.code == 'ADMIN'}">bg-danger</c:when>
                                            <c:when test="${user.role.code == 'MANAGER'}">bg-warning</c:when>
                                            <c:when test="${user.role.code == 'AGENT'}">bg-primary</c:when>
                                            <c:otherwise>bg-secondary</c:otherwise>
                                        </c:choose>">
                                        ${user.role.name}
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.active}">
                                            <span class="badge bg-success">Активен</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger">Неактивен</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="date-field">
                                    <fmt:formatDate value="${user.createdAt}" pattern="dd.MM.yyyy"/>
                                </td>
                                <td>
                                    <span class="badge bg-info">${user.contracts.size()}</span>
                                </td>
                                <td class="text-end table-actions">
                                    <c:if test="${sessionScope.currentUser.role.code == 'ADMIN' or user.id == sessionScope.currentUser.id}">
                                        <a href="${pageContext.request.contextPath}/users/edit/${user.id}" 
                                           class="btn btn-sm btn-warning btn-action" title="Редактировать">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                    </c:if>
                                    
                                    <c:if test="${sessionScope.currentUser.role.code == 'ADMIN'}">
                                        <div class="btn-group">
                                            <button type="button" class="btn btn-sm btn-outline-primary dropdown-toggle" 
                                                    data-bs-toggle="dropdown" title="Изменить роль">
                                                <i class="fas fa-user-tag"></i>
                                            </button>
                                            <ul class="dropdown-menu">
                                                <c:forEach var="role" items="${roles}">
                                                    <c:if test="${role.code != user.role.code}">
                                                        <li>
                                                            <a class="dropdown-item" 
                                                               href="${pageContext.request.contextPath}/users/change-role/${user.id}?roleCode=${role.code}">
                                                                ${role.name}
                                                            </a>
                                                        </li>
                                                    </c:if>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                        
                                        <a href="${pageContext.request.contextPath}/users/toggle-status/${user.id}" 
                                           class="btn btn-sm ${user.active ? 'btn-outline-danger' : 'btn-outline-success'} btn-action" 
                                           title="${user.active ? 'Деактивировать' : 'Активировать'}">
                                            <i class="fas ${user.active ? 'fa-user-slash' : 'fa-user-check'}"></i>
                                        </a>
                                        
                                        <c:if test="${user.id != sessionScope.currentUser.id}">
                                            <a href="${pageContext.request.contextPath}/users/delete/${user.id}" 
                                               class="btn btn-sm btn-danger btn-action confirm-delete" title="Удалить">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </c:if>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty users}">
                            <tr>
                                <td colspan="7" class="text-center text-muted py-4">
                                    <i class="fas fa-users fa-2x mb-3"></i><br>
                                    Пользователи не найдены
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            
            <!-- Статистика -->
            <c:if test="${not empty users and users.size() > 0}">
                <div class="row mt-4">
                    <div class="col-md-3">
                        <div class="card stat-card bg-primary text-white">
                            <i class="fas fa-users"></i>
                            <h6>Всего пользователей</h6>
                            <h4>${users.size()}</h4>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card stat-card bg-success text-white">
                            <i class="fas fa-user-shield"></i>
                            <h6>Администраторов</h6>
                            <h4>
                                <c:set var="adminCount" value="0"/>
                                <c:forEach var="user" items="${users}">
                                    <c:if test="${user.role.code == 'ADMIN'}">
                                        <c:set var="adminCount" value="${adminCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${adminCount}
                            </h4>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card stat-card bg-warning text-white">
                            <i class="fas fa-user-tie"></i>
                            <h6>Менеджеров</h6>
                            <h4>
                                <c:set var="managerCount" value="0"/>
                                <c:forEach var="user" items="${users}">
                                    <c:if test="${user.role.code == 'MANAGER'}">
                                        <c:set var="managerCount" value="${managerCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${managerCount}
                            </h4>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card stat-card bg-info text-white">
                            <i class="fas fa-user"></i>
                            <h6>Агентов</h6>
                            <h4>
                                <c:set var="agentCount" value="0"/>
                                <c:forEach var="user" items="${users}">
                                    <c:if test="${user.role.code == 'AGENT'}">
                                        <c:set var="agentCount" value="${agentCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${agentCount}
                            </h4>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</main>

<jsp:include page="../layout/footer.jsp"/>