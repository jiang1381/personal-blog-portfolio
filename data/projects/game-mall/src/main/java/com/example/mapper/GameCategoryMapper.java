package com.example.mapper;

import com.example.entity.GameCategory;

import java.util.List;

public interface GameCategoryMapper {
    GameCategory findById(Integer id);
    List<GameCategory> findAll();
    int insert(GameCategory category);
    int update(GameCategory category);
    int delete(Integer id);
}