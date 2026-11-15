package com.example.service.impl;

import com.example.entity.Order;
import com.example.entity.OrderItem;
import com.example.mapper.OrderItemMapper;
import com.example.mapper.OrderMapper;
import com.example.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private OrderItemMapper orderItemMapper;

    @Override
    public List<Order> findByUserId(Integer userId) {
        return orderMapper.findByUserId(userId);
    }

    @Override
    public List<Order> findAll() {
        return orderMapper.findAll();
    }

    @Override
    public List<Order> findByStatus(Integer status) {
        return orderMapper.findByStatus(status);
    }

    @Override
    public Order findById(Integer id) {
        return orderMapper.findById(id);
    }

    @Override
    public List<OrderItem> findOrderItems(Integer orderId) {
        return orderItemMapper.findByOrderId(orderId);
    }

    @Override
    @Transactional
    public Order createOrder(Integer userId, List<OrderItem> items) {
        Order order = new Order();
        order.setOrderNo(UUID.randomUUID().toString().replace("-", "").substring(0, 16));
        order.setUserId(userId);
        
        double totalAmount = items.stream().mapToDouble(item -> item.getPrice() * item.getQuantity()).sum();
        order.setTotalAmount(totalAmount);
        order.setStatus(0);
        order.setCreateTime(new Date());
        
        orderMapper.insert(order);
        
        for (OrderItem item : items) {
            item.setOrderId(order.getId());
            orderItemMapper.insert(item);
        }
        
        return order;
    }

    @Override
    public void updateStatus(Integer orderId, Integer status) {
        Order order = new Order();
        order.setId(orderId);
        order.setStatus(status);
        orderMapper.update(order);
    }

    @Override
    @Transactional
    public void deleteById(Integer id) {
        orderItemMapper.deleteByOrderId(id);
        orderMapper.deleteById(id);
    }
}