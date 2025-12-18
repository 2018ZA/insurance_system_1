<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Доступ запрещен - InsurancePro</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        body {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .error-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            padding: 40px;
            text-align: center;
            max-width: 500px;
        }
        .error-icon {
            font-size: 5rem;
            color: #dc3545;
            margin-bottom: 20px;
        }
        .btn-home {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
            padding: 10px 30px;
            border-radius: 25px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="error-card">
            <div class="error-icon">
                <i class="fas fa-ban"></i>
            </div>
            <h1 class="mb-3">403</h1>
            <h3 class="mb-4">Доступ запрещен</h3>
            <p class="text-muted mb-4">
                У вас нет необходимых прав для доступа к этой странице.
                Если вы считаете, что это ошибка, обратитесь к администратору системы.
            </p>
            <div class="d-grid gap-2 d-md-block">
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-home">
                    <i class="fas fa-home me-2"></i>На главную
                </a>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-secondary">
                    <i class="fas fa-sign-in-alt me-2"></i>Войти под другой учетной записью
                </a>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>