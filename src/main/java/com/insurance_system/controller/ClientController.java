package com.insurance_system.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.insurance_system.entity.Client;
import com.insurance_system.service.ClientService;

@Controller
@RequestMapping("insurance/clients")
public class ClientController {
    
    @Autowired
    private ClientService clientService;
    
    @GetMapping("")
    public String listClients(Model model) {
        List<Client> clients = clientService.getAllClients();
        model.addAttribute("clients", clients);
        model.addAttribute("pageTitle", "Клиенты");
        return "clients/list";
    }
    
    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("client", new Client());
        model.addAttribute("pageTitle", "Добавить клиента");
        model.addAttribute("formAction", "/clients/save");
        return "clients/form";
    }
    
    @PostMapping("/save")
    public String saveClient(@ModelAttribute Client client) {
        try {
            clientService.saveClient(client);
            return "redirect:/clients";
        } catch (RuntimeException e) {
            return "redirect:/clients/add?error=" + e.getMessage();
        }
    }
    
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        // ✅ ИСПРАВЛЕНО: используем существующий метод getClientById
        Client client = clientService.getClientById(id);
        if (client == null) {
            return "redirect:/clients";
        }
        model.addAttribute("client", client);
        model.addAttribute("pageTitle", "Редактировать клиента");
        model.addAttribute("formAction", "/clients/update");
        return "clients/form";
    }
    
    @PostMapping("/update")
    public String updateClient(@ModelAttribute Client client) {
        try {
            clientService.updateClient(client);
            return "redirect:/clients";
        } catch (RuntimeException e) {
            return "redirect:/clients/edit/" + client.getId() + "?error=" + e.getMessage();
        }
    }
    
    @GetMapping("/delete/{id}")
    public String deleteClient(@PathVariable Long id) {
        try {
            clientService.deleteClient(id);
        } catch (RuntimeException e) {
            // Можно добавить flash сообщение об ошибке
            // redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/clients";
    }
    
    @GetMapping("/search")
    public String searchClients(@RequestParam(required = false) String name, Model model) {
        List<Client> clients;
        if (name != null && !name.trim().isEmpty()) {
            clients = clientService.searchClientsByName(name);
            model.addAttribute("searchQuery", name);
        } else {
            clients = clientService.getAllClients();
        }
        model.addAttribute("clients", clients);
        model.addAttribute("pageTitle", "Поиск клиентов");
        return "clients/list";
    }
    
    @GetMapping("/view/{id}")
    public String viewClient(@PathVariable Long id, Model model) {
        Client client = clientService.getClientById(id);
        if (client == null) {
            return "redirect:/clients";
        }
        model.addAttribute("client", client);
        model.addAttribute("pageTitle", "Информация о клиенте: " + client.getFullName());
        return "clients/view";
    }
}