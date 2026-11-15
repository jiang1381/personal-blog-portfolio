package com.example.service;

import com.example.entity.Game;

import java.util.List;

public interface GameService {
    Game findById(Integer id);
    List<Game> findAll();
    List<Game> findByCategoryId(Integer categoryId);
    List<Game> search(String keyword, Integer categoryId);
    int add(Game game);
    int update(Game game);
    int delete(Integer id);
    int getUserCount();
    int getOrderCount();
    int getGameCount();
    int getPendingOrderCount();
    List<Game> getFeaturedGames(int limit);
}