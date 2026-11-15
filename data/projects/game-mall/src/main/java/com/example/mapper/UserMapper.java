
package com.example.mapper;

import com.example.entity.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserMapper {
    User findByUsername(String username);
    User findById(Integer id);
    int insert(User user);
    int update(User user);
    int updateProfile(User user);
    int delete(Integer id);
    List<User> findAll();
}
