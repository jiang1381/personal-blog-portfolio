package com.example.service.impl;

import com.example.entity.CartItem;
import com.example.mapper.CartItemMapper;
import com.example.service.CartItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CartItemServiceImpl implements CartItemService {

    @Autowired
    private CartItemMapper cartItemMapper;

    @Override
    public List<CartItem> findByUserId(Integer userId) {
        return cartItemMapper.findByUserId(userId);
    }

    @Override
    public void addToCart(Integer userId, Integer gameId, Integer quantity) {
        CartItem existingItem = cartItemMapper.findByUserIdAndGameId(userId, gameId);
        if (existingItem != null) {
            existingItem.setQuantity(existingItem.getQuantity() + quantity);
            cartItemMapper.update(existingItem);
        } else {
            CartItem cartItem = new CartItem();
            cartItem.setUserId(userId);
            cartItem.setGameId(gameId);
            cartItem.setQuantity(quantity);
            cartItemMapper.insert(cartItem);
        }
    }

    @Override
    public void updateQuantity(Integer id, Integer quantity) {
        CartItem cartItem = new CartItem();
        cartItem.setId(id);
        cartItem.setQuantity(quantity);
        cartItemMapper.update(cartItem);
    }

    @Override
    public void removeFromCart(Integer id) {
        cartItemMapper.deleteById(id);
    }

    @Override
    public void clearCart(Integer userId) {
        cartItemMapper.deleteByUserId(userId);
    }

    @Override
    public int countByUserId(Integer userId) {
        return cartItemMapper.countByUserId(userId);
    }
}