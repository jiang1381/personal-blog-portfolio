package com.example.service;

import com.example.entity.Order;
import com.example.entity.OrderItem;

import java.util.List;

public interface OrderService {
    List<Order> findByUserId(Integer userId);
    List<Order> findAll();
    List<Order> findByStatus(Integer status);
    Order findById(Integer id);
    List<OrderItem> findOrderItems(Integer orderId);
    Order createOrder(Integer userId, List<OrderItem> items);
    void updateStatus(Integer orderId, Integer status);
    void deleteById(Integer id);
}