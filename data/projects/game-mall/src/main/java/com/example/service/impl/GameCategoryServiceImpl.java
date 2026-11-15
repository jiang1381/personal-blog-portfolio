package com.example.service.impl;

import com.example.entity.GameCategory;
import com.example.mapper.GameCategoryMapper;
import com.example.service.GameCategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GameCategoryServiceImpl implements GameCategoryService {

    @Autowired
    private GameCategoryMapper gameCategoryMapper;

    @Override
    public GameCategory findById(Integer id) {
        return gameCategoryMapper.findById(id);
    }

    @Override
    public List<GameCategory> findAll() {
        return gameCategoryMapper.findAll();
    }

    @Override
    public int add(GameCategory category) {
        category.setCreateTime(new java.util.Date());
        return gameCategoryMapper.insert(category);
    }

    @Override
    public int update(GameCategory category) {
        return gameCategoryMapper.update(category);
    }

    @Override
    public int delete(Integer id) {
        return gameCategoryMapper.delete(id);
    }
}