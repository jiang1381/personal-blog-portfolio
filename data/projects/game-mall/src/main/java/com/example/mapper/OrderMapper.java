package com.example.mapper;

import com.example.entity.Order;

import java.util.List;

public interface OrderMapper {
    List<Order> findByUserId(Integer userId);
    List<Order> findAll();
    List<Order> findByStatus(Integer status);
    Order findById(Integer id);
    int insert(Order order);
    int update(Order order);
    int deleteById(Integer id);
}