package com.example.mapper;

import com.example.entity.OrderItem;

import java.util.List;

public interface OrderItemMapper {
    List<OrderItem> findByOrderId(Integer orderId);
    int insert(OrderItem orderItem);
    int deleteByOrderId(Integer orderId);
}