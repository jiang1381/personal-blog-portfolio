package com.example.service.impl;

import com.example.entity.Game;
import com.example.mapper.GameMapper;
import com.example.service.GameService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GameServiceImpl implements GameService {

    @Autowired
    private GameMapper gameMapper;

    @Override
    public Game findById(Integer id) {
        return gameMapper.findById(id);
    }

    @Override
    public List<Game> findAll() {
        return gameMapper.findAll();
    }

    @Override
    public List<Game> findByCategoryId(Integer categoryId) {
        return gameMapper.findByCategoryId(categoryId);
    }

    @Override
    public List<Game> search(String keyword, Integer categoryId) {
        return gameMapper.search(keyword, categoryId);
    }

    @Override
    public int add(Game game) {
        game.setCreateTime(new java.util.Date());
        return gameMapper.insert(game);
    }

    @Override
    public int update(Game game) {
        return gameMapper.update(game);
    }

    @Override
    public int delete(Integer id) {
        return gameMapper.delete(id);
    }

    @Override
    public int getUserCount() {
        return gameMapper.getUserCount();
    }

    @Override
    public int getOrderCount() {
        return gameMapper.getOrderCount();
    }

    @Override
    public int getGameCount() {
        return gameMapper.getGameCount();
    }

    @Override
    public int getPendingOrderCount() {
        return gameMapper.getPendingOrderCount();
    }

    @Override
    public List<Game> getFeaturedGames(int limit) {
        return gameMapper.getFeaturedGames(limit);
    }
}