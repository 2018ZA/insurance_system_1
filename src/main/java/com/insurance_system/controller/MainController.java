package com.insurance_system.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/")
public class MainController {
    
    @GetMapping("")
    public String index() {
        return "redirect:/dashboard";
    }
    
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("pageTitle", "Панель управления");
        return "dashboard";
    }
    
    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }
    
    @GetMapping("/access-denied")
    public String accessDenied() {
        return "access-denied";
    }
    
    @GetMapping("/about")
    public String about(Model model) {
        model.addAttribute("pageTitle", "Об авторе");
        
        // Информация об авторе
        model.addAttribute("authorName", "Иванов Иван Иванович");
        model.addAttribute("groupNumber", "ИТ-401");
        model.addAttribute("university", "Национальный исследовательский университет ИТМО");
        model.addAttribute("email", "ivanov@itmo.ru");
        model.addAttribute("phone", "+7 (999) 123-45-67");
        
        // Технологии
        model.addAttribute("technologies", new String[]{
            "Spring MVC",
            "Hibernate/JPA", 
            "PostgreSQL",
            "JavaScript",
            "REST API"
        });
        
        // Даты проекта
        model.addAttribute("startDate", "01.09.2023");
        model.addAttribute("endDate", "15.12.2023");
        
        return "about";
    }
}