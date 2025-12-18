package com.insurance_system.service;

import com.insurance_system.dao.ClientDAO;
import com.insurance_system.entity.Client;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ClientService {
    
    @Autowired
    private ClientDAO clientDAO;
    
    @Transactional
    public List<Client> getAllClients() {
        return clientDAO.getAllClients();
    }
    
    @Transactional
    public Client getClientById(Long id) {
        return clientDAO.getClientById(id);
    }
    
    @Transactional
    public void saveClient(Client client) {
        // Проверка уникальности телефона
        Client existingClient = clientDAO.findClientByPhone(client.getPhone());
        if (existingClient != null && !existingClient.getId().equals(client.getId())) {
            throw new RuntimeException("Клиент с таким телефоном уже существует");
        }
        
        // Проверка уникальности паспорта
        if (client.getPassportSeries() != null && client.getPassportNumber() != null) {
            Client passportClient = clientDAO.findClientByPassport(
                client.getPassportSeries(), 
                client.getPassportNumber()
            );
            if (passportClient != null && !passportClient.getId().equals(client.getId())) {
                throw new RuntimeException("Клиент с такими паспортными данными уже существует");
            }
        }
        
        clientDAO.saveClient(client);
    }
    
    @Transactional
    public void updateClient(Client client) {
        saveClient(client); // Используем тот же метод для обновления
    }
    
    @Transactional
    public void deleteClient(Long id) {
        Client client = clientDAO.getClientById(id);
        if (client != null && !client.getContracts().isEmpty()) {
            throw new RuntimeException("Нельзя удалить клиента с активными договорами");
        }
        clientDAO.deleteClient(id);
    }
    
    @Transactional
    public List<Client> searchClientsByName(String name) {
        return clientDAO.searchClientsByName(name);
    }
    
    @Transactional
    public long getClientsCount() {
        return clientDAO.getClientsCount();
    }
    
    @Transactional
    public Client findClientByPassport(String series, String number) {
        return clientDAO.findClientByPassport(series, number);
    }
    
    @Transactional
    public Client findClientByPhone(String phone) {
        return clientDAO.findClientByPhone(phone);
    }
}