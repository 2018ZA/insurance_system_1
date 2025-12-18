package com.insurance_system.controller;

import com.insurance_system.service.StatisticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/statistics")
public class StatisticsController {
    
    @Autowired
    private StatisticsService statisticsService;
    
    @GetMapping("")
    public String showStatistics(Model model) {
        // Общая статистика
        Map<String, Object> generalStats = statisticsService.getGeneralStatistics();
        model.addAttribute("generalStats", generalStats);
        
        // Статистика по типам страхования
        List<Map<String, Object>> typeStats = statisticsService.getContractsByTypeStatistics();
        model.addAttribute("typeStats", typeStats);
        
        // Статистика по статусам
        Map<String, Long> statusStats = statisticsService.getContractsByStatusStatistics();
        model.addAttribute("statusStats", statusStats);
        
        model.addAttribute("pageTitle", "Статистика");
        
        return "statistics/view";
    }
    
    @GetMapping("/by-type")
    public String statisticsByType(Model model) {
        List<Map<String, Object>> typeStats = statisticsService.getContractsByTypeStatistics();
        model.addAttribute("typeStats", typeStats);
        model.addAttribute("pageTitle", "Статистика по типам страхования");
        return "statistics/by-type";
    }
    
    @GetMapping("/by-status")
    public String statisticsByStatus(Model model) {
        Map<String, Long> statusStats = statisticsService.getContractsByStatusStatistics();
        model.addAttribute("statusStats", statusStats);
        model.addAttribute("pageTitle", "Статистика по статусам договоров");
        return "statistics/by-status";
    }
}