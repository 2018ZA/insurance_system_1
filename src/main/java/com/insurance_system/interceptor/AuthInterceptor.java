package com.insurance_system.interceptor;

import com.insurance_system.util.SessionUtils;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AuthInterceptor implements HandlerInterceptor {
    
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) 
            throws Exception {
        
        String requestURI = request.getRequestURI();
        
        // Публичные пути
        if (requestURI.equals("/insurance/login") || 
            requestURI.equals("/insurance/about") ||
            requestURI.startsWith("/insurance/css/") ||
            requestURI.startsWith("/insurance/js/") ||
            requestURI.startsWith("/insurance/images/")) {
            return true;
        }
        
        // Проверка аутентификации
        if (!SessionUtils.isUserLoggedIn()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        
        // Проверка ролей для защищенных путей
        if (requestURI.startsWith("/insurance/admin/") && !SessionUtils.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/access-denied");
            return false;
        }
        
        if (requestURI.startsWith("/insurance/manager/") && !SessionUtils.isManager()) {
            response.sendRedirect(request.getContextPath() + "/access-denied");
            return false;
        }
        
        return true;
    }
}