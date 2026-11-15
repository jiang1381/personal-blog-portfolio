package com.example.service;

import com.example.entity.CartItem;

import java.util.List;

public interface CartItemService {
    List<CartItem> findByUserId(Integer userId);
    void addToCart(Integer userId, Integer gameId, Integer quantity);
    void updateQuantity(Integer id, Integer quantity);
    void removeFromCart(Integer id);
    void clearCart(Integer userId);
    int countByUserId(Integer userId);
}