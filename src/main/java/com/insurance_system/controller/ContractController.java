package com.insurance_system.controller;

import com.insurance_system.entity.Client;
import com.insurance_system.entity.Contract;
import com.insurance_system.entity.InsuranceType;
import com.insurance_system.service.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/contracts")
public class ContractController {
    
    @Autowired
    private ContractService contractService;
    
    @Autowired
    private ClientService clientService;
    
    @Autowired
    private InsuranceTypeService insuranceTypeService;
    
    @Autowired
    private ContractStatusService contractStatusService;
    
    @Autowired
    private UserService userService;
    
    @GetMapping("")
    public String listContracts(Model model) {
        List<Contract> contracts = contractService.getAllContracts();
        model.addAttribute("contracts", contracts);
        model.addAttribute("pageTitle", "Договоры страхования");
        return "contracts/list";
    }
    
    @GetMapping("/add")
    public String showAddForm(Model model) {
        Contract contract = new Contract();
        contract.setStartDate(new Date());
        contract.setEndDate(new Date(System.currentTimeMillis() + 365L * 24 * 60 * 60 * 1000)); // +1 год
        
        model.addAttribute("contract", contract);
        model.addAttribute("clients", clientService.getAllClients());
        model.addAttribute("insuranceTypes", insuranceTypeService.getAllInsuranceTypes());
        model.addAttribute("contractStatuses", contractStatusService.getAllContractStatuses());
        model.addAttribute("agents", userService.getUsersByRole("AGENT"));
        model.addAttribute("pageTitle", "Оформить договор");
        model.addAttribute("formAction", "/contracts/save");
        
        return "contracts/form";
    }
    
    @PostMapping("/save")
    public String saveContract(
            @ModelAttribute Contract contract,
            @RequestParam Long clientId,
            @RequestParam String insuranceTypeCode,
            @RequestParam(required = false) Long agentId) {
        
        try {
            Client client = clientService.getClientById(clientId);
            if (client == null) {
                throw new RuntimeException("Клиент не найден");
            }
            
            InsuranceType insuranceType = insuranceTypeService.getInsuranceTypeByCode(insuranceTypeCode);
            if (insuranceType == null) {
                throw new RuntimeException("Тип страхования не найден");
            }
            
            contract.setClient(client);
            contract.setInsuranceType(insuranceType);
            
            contractService.saveContract(contract, agentId);
            return "redirect:/contracts";
        } catch (RuntimeException e) {
            return "redirect:/contracts/add?error=" + e.getMessage();
        }
    }
    
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        Contract contract = contractService.getContractById(id);
        if (contract == null) {
            return "redirect:/contracts";
        }
        
        model.addAttribute("contract", contract);
        model.addAttribute("clients", clientService.getAllClients());
        model.addAttribute("insuranceTypes", insuranceTypeService.getAllInsuranceTypes());
        model.addAttribute("contractStatuses", contractStatusService.getAllContractStatuses());
        model.addAttribute("agents", userService.getUsersByRole("AGENT"));
        model.addAttribute("pageTitle", "Редактировать договор");
        model.addAttribute("formAction", "/contracts/update");
        
        return "contracts/form";
    }
    
    @PostMapping("/update")
    public String updateContract(
            @ModelAttribute Contract contract,
            @RequestParam Long clientId,
            @RequestParam String insuranceTypeCode,
            @RequestParam(required = false) Long agentId) {
        
        try {
            Client client = clientService.getClientById(clientId);
            InsuranceType insuranceType = insuranceTypeService.getInsuranceTypeByCode(insuranceTypeCode);
            
            contract.setClient(client);
            contract.setInsuranceType(insuranceType);
            
            if (agentId != null) {
                contract.setAgent(userService.getUserById(agentId));
            }
            
            contractService.updateContract(contract);
            return "redirect:/contracts";
        } catch (RuntimeException e) {
            return "redirect:/contracts/edit/" + contract.getId() + "?error=" + e.getMessage();
        }
    }
    
    @GetMapping("/delete/{id}")
    public String deleteContract(@PathVariable Long id) {
        contractService.deleteContract(id);
        return "redirect:/contracts";
    }
    
    @GetMapping("/change-status/{id}")
    public String changeContractStatus(
            @PathVariable Long id,
            @RequestParam String status) {
        
        contractService.changeContractStatus(id, status);
        return "redirect:/contracts";
    }
    
    @GetMapping("/search")
    public String searchContracts(
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) String status,
            Model model) {
        
        List<Contract> contracts = contractService.searchContracts(startDate, endDate, type, status);
        
        model.addAttribute("contracts", contracts);
        model.addAttribute("insuranceTypes", insuranceTypeService.getAllInsuranceTypes());
        model.addAttribute("contractStatuses", contractStatusService.getAllContractStatuses());
        model.addAttribute("searchStartDate", startDate);
        model.addAttribute("searchEndDate", endDate);
        model.addAttribute("searchType", type);
        model.addAttribute("searchStatus", status);
        model.addAttribute("pageTitle", "Поиск договоров");
        
        return "contracts/list";
    }
    
    @GetMapping("/by-client/{clientId}")
    public String getContractsByClient(@PathVariable Long clientId, Model model) {
        Client client = clientService.getClientById(clientId);
        if (client == null) {
            return "redirect:/clients";
        }
        
        List<Contract> contracts = contractService.getContractsByClient(clientId);
        
        model.addAttribute("contracts", contracts);
        model.addAttribute("client", client);
        model.addAttribute("pageTitle", "Договоры клиента: " + client.getFullName());
        
        return "contracts/list";
    }
    
    @GetMapping("/view/{id}")
    public String viewContract(@PathVariable Long id, Model model) {
        Contract contract = contractService.getContractById(id);
        if (contract == null) {
            return "redirect:/contracts";
        }
        
        model.addAttribute("contract", contract);
        model.addAttribute("pageTitle", "Договор №" + contract.getContractNumber());
        
        return "contracts/view";
    }
}