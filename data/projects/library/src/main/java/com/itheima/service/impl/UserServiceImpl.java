package com.itheima.service.impl;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.itheima.domain.User;
import com.itheima.entity.PageResult;
import com.itheima.mapper.UserMapper;
import com.itheima.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

@Service
@Transactional
public class UserServiceImpl  implements UserService {
    // 注入UserMapper对象
    @Autowired
    private UserMapper userMapper;
    // 通过User的用户账号和用户密码查询用户信息
    @Override
    public User login(User user) {
        return userMapper.login(user);
    }

    /**
     * 新增员工
     * @param user
     */
    @Override
    public Integer addUser(User user) {
        //入职日期为空时，默认设置为当天
        if (user.getHiredate() == null || "".equals(user.getHiredate())) {
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            user.setHiredate(dateFormat.format(new Date()));
        }
        //员工状态为空时，默认设置为在职
        if (user.getStatus() == null || "".equals(user.getStatus())) {
            user.setStatus("0");
        }
        return userMapper.addUser(user);
    }

    /**
     * 办理离职
     * @param id 员工id
     */
    @Override
    public Integer delUser(Integer id) {
        return userMapper.delUser(id);
    }

    /**
     * 编辑员工信息
     * @param user
     */
    @Override
    public Integer editUser(User user) {
        return userMapper.editUser(user);
    }

    /**
     * 分页查询在职员工信息
     * @param user 封装查询条件的对象
     * @param pageNum 当前页码
     * @param pageSize 每页显示数量
     */
    @Override
    public PageResult searchUsers(User user, Integer pageNum, Integer pageSize) {
        // 设置分页查询的参数，开始分页
        PageHelper.startPage(pageNum, pageSize);
        Page<User> page = userMapper.searchUsers(user);
        return new PageResult(page.getTotal(), page.getResult());
    }

    /**
     * 根据id查询员工信息
     * @param id 员工id
     */
    @Override
    public User findById(Integer id) {
        return userMapper.findById(id);
    }

    /**
     * 检查员工姓名是否重复
     * @param name 员工姓名
     */
    @Override
    public Integer checkName(String name) {
        return userMapper.checkName(name);
    }

    /**
     * 检查员工邮箱是否重复
     * @param email 员工邮箱
     */
    @Override
    public Integer checkEmail(String email) {
        return userMapper.checkEmail(email);
    }
}
