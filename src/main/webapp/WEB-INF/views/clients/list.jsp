<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../layout/header.jsp"/>
<jsp:include page="../layout/sidebar.jsp"/>

<main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2">Клиенты</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <a href="${pageContext.request.contextPath}/clients/add" class="btn btn-primary">
                <i class="fas fa-user-plus me-1"></i>Добавить клиента
            </a>
        </div>
    </div>
    
    <!-- Поиск -->
    <div class="card mb-4">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/clients/search" method="get" class="row g-3">
                <div class="col-md-8">
                    <input type="text" class="form-control" name="name" 
                           placeholder="Поиск по ФИО..." value="${searchQuery}">
                </div>
                <div class="col-md-4">
                    <button type="submit" class="btn btn-outline-primary w-100">
                        <i class="fas fa-search me-1"></i>Найти
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Таблица клиентов -->
    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">Список клиентов</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>ФИО</th>
                            <th>Паспортные данные</th>
                            <th>Телефон</th>
                            <th>Email</th>
                            <th>Дата регистрации</th>
                            <th>Договоры</th>
                            <th class="text-end">Действия</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="client" items="${clients}">
                            <tr>
                                <td>
                                    <strong>${client.fullName}</strong>
                                </td>
                                <td>${client.fullPassport}</td>
                                <td>${client.phone}</td>
                                <td>${client.email}</td>
                                <td class="date-field">
                                    <fmt:formatDate value="${client.registrationDate}" pattern="dd.MM.yyyy"/>
                                </td>
                                <td>
                                    <span class="badge bg-info">${client.contracts.size()}</span>
                                </td>
                                <td class="text-end table-actions">
                                    <a href="${pageContext.request.contextPath}/clients/view/${client.id}" 
                                       class="btn btn-sm btn-info btn-action" title="Просмотр">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/clients/edit/${client.id}" 
                                       class="btn btn-sm btn-warning btn-action" title="Редактировать">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/contracts/by-client/${client.id}" 
                                       class="btn btn-sm btn-primary btn-action" title="Договоры клиента">
                                        <i class="fas fa-file-contract"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/clients/delete/${client.id}" 
                                       class="btn btn-sm btn-danger btn-action confirm-delete" title="Удалить">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty clients}">
                            <tr>
                                <td colspan="7" class="text-center text-muted py-4">
                                    <i class="fas fa-users fa-2x mb-3"></i><br>
                                    Клиенты не найдены
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            
            <!-- Пагинация -->
            <c:if test="${not empty clients and clients.size() > 0}">
                <div class="d-flex justify-content-between align-items-center mt-3">
                    <div class="text-muted">
                        Показано ${clients.size()} клиентов
                    </div>
                    <nav>
                        <ul class="pagination mb-0">
                            <li class="page-item disabled">
                                <a class="page-link" href="#">Предыдущая</a>
                            </li>
                            <li class="page-item active">
                                <a class="page-link" href="#">1</a>
                            </li>
                            <li class="page-item">
                                <a class="page-link" href="#">2</a>
                            </li>
                            <li class="page-item">
                                <a class="page-link" href="#">3</a>
                            </li>
                            <li class="page-item">
                                <a class="page-link" href="#">Следующая</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </c:if>
        </div>
    </div>
</main>

<jsp:include page="../layout/footer.jsp"/>