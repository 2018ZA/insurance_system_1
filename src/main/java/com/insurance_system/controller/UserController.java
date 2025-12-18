package com.insurance_system.controller;

import com.insurance_system.entity.User;
import com.insurance_system.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/users")
public class UserController {
    
    @Autowired
    private UserService userService;
    
    @GetMapping("")
    public String listUsers(Model model) {
        List<User> users = userService.getAllUsers();
        model.addAttribute("users", users);
        model.addAttribute("pageTitle", "Пользователи системы");
        return "users/list";
    }
    
    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("user", new User());
        model.addAttribute("roles", userService.getAllRoles());
        model.addAttribute("pageTitle", "Добавить пользователя");
        model.addAttribute("formAction", "/users/save");
        return "users/form";
    }
    
    @PostMapping("/save")
    public String saveUser(
            @ModelAttribute User user,
            @RequestParam String roleCode,
            @RequestParam String confirmPassword) {
        
        try {
            // Проверка подтверждения пароля
            if (!user.getPassword().equals(confirmPassword)) {
                throw new RuntimeException("Пароли не совпадают");
            }
            
            user.setRole(userService.getRoleByCode(roleCode));
            userService.saveUser(user);
            return "redirect:/users";
        } catch (RuntimeException e) {
            return "redirect:/users/add?error=" + e.getMessage();
        }
    }
    
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        User user = userService.getUserById(id);
        if (user == null) {
            return "redirect:/users";
        }
        
        model.addAttribute("user", user);
        model.addAttribute("roles", userService.getAllRoles());
        model.addAttribute("pageTitle", "Редактировать пользователя");
        model.addAttribute("formAction", "/users/update");
        
        return "users/form";
    }
    
    @PostMapping("/update")
    public String updateUser(
            @ModelAttribute User user,
            @RequestParam String roleCode,
            @RequestParam(required = false) String newPassword,
            @RequestParam(required = false) String confirmPassword) {
        
        try {
            // Если указан новый пароль
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                if (!newPassword.equals(confirmPassword)) {
                    throw new RuntimeException("Пароли не совпадают");
                }
                user.setPassword(newPassword);
            }
            
            user.setRole(userService.getRoleByCode(roleCode));
            userService.updateUser(user);
            return "redirect:/users";
        } catch (RuntimeException e) {
            return "redirect:/users/edit/" + user.getId() + "?error=" + e.getMessage();
        }
    }
    
    @GetMapping("/delete/{id}")
    public String deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return "redirect:/users";
    }
    
    @GetMapping("/change-role/{id}")
    public String changeUserRole(
            @PathVariable Long id,
            @RequestParam String roleCode) {
        
        userService.changeUserRole(id, roleCode);
        return "redirect:/users";
    }
    
    @GetMapping("/toggle-status/{id}")
    public String toggleUserStatus(@PathVariable Long id) {
        User user = userService.getUserById(id);
        if (user != null) {
            userService.changeUserStatus(id, !user.getActive());
        }
        return "redirect:/users";
    }
}