package com.insurance_system.util;

import com.insurance_system.entity.User;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class SessionUtils {
    
    public static HttpSession getSession() {
        ServletRequestAttributes attr = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
        return attr.getRequest().getSession();
    }
    
    public static User getCurrentUser() {
        HttpSession session = getSession();
        return (User) session.getAttribute("currentUser");
    }
    
    public static void setCurrentUser(User user) {
        HttpSession session = getSession();
        session.setAttribute("currentUser", user);
    }
    
    public static void invalidateSession() {
        HttpSession session = getSession();
        session.invalidate();
    }
    
    public static boolean isUserLoggedIn() {
        return getCurrentUser() != null;
    }
    
    public static boolean isAdmin() {
        User user = getCurrentUser();
        return user != null && "ADMIN".equals(user.getRole().getCode());
    }
    
    public static boolean isManager() {
        User user = getCurrentUser();
        return user != null && "MANAGER".equals(user.getRole().getCode());
    }
    
    public static boolean isAgent() {
        User user = getCurrentUser();
        return user != null && "AGENT".equals(user.getRole().getCode());
    }
}