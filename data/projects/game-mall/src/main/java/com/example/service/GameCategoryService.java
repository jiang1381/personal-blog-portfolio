package com.example.service;

import com.example.entity.GameCategory;

import java.util.List;

public interface GameCategoryService {
    GameCategory findById(Integer id);
    List<GameCategory> findAll();
    int add(GameCategory category);
    int update(GameCategory category);
    int delete(Integer id);
}