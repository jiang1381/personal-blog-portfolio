package com.example.mapper;

import com.example.entity.Game;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface GameMapper {
    Game findById(Integer id);
    List<Game> findAll();
    List<Game> findByCategoryId(Integer categoryId);
    List<Game> search(@Param("keyword") String keyword, @Param("categoryId") Integer categoryId);
    int insert(Game game);
    int update(Game game);
    int delete(Integer id);
    int getUserCount();
    int getOrderCount();
    int getGameCount();
    int getPendingOrderCount();
    List<Game> getFeaturedGames(int limit);
}