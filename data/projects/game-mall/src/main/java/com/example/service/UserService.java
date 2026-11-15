
package com.example.service;

import com.example.entity.User;

import java.util.List;

public interface UserService {
    User login(String username, String password);
    User findById(Integer id);
    User findByUsername(String username);
    List<User> findAll();
    int register(User user);
    int update(User user);
    int updateProfile(User user);
    int delete(Integer id);
    boolean verifyPassword(Integer userId, String password);
}
