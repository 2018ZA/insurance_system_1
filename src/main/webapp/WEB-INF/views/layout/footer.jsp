<%@ page contentType="text/html;charset=UTF-8" language="java" %>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Custom JS -->
<script>
    $(document).ready(function() {
        // Загрузка статистики для сайдбара
        $.get('${pageContext.request.contextPath}/api/statistics/sidebar', function(data) {
            $('#clientsCount').text(data.clientsCount);
            $('#contractsCount').text(data.contractsCount);
        });
        
        // Подтверждение удаления
        $('.confirm-delete').on('click', function() {
            return confirm('Вы уверены, что хотите удалить эту запись?');
        });
        
        // Форматирование дат
        $('.date-field').each(function() {
            var date = new Date($(this).text());
            if (!isNaN(date.getTime())) {
                $(this).text(date.toLocaleDateString('ru-RU'));
            }
        });
        
        // Форматирование чисел
        $('.currency-field').each(function() {
            var num = parseFloat($(this).text());
            if (!isNaN(num)) {
                $(this).text(num.toLocaleString('ru-RU', {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                }) + ' ₽');
            }
        });
    });
</script>
</body>
</html>