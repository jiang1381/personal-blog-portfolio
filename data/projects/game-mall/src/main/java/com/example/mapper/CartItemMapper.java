package com.example.mapper;

import com.example.entity.CartItem;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CartItemMapper {
    List<CartItem> findByUserId(Integer userId);
    CartItem findByUserIdAndGameId(@Param("userId") Integer userId, @Param("gameId") Integer gameId);
    int insert(CartItem cartItem);
    int update(CartItem cartItem);
    int deleteById(Integer id);
    int deleteByUserId(Integer userId);
    int countByUserId(Integer userId);
}