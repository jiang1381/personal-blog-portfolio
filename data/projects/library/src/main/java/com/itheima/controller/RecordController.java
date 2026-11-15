package com.itheima.controller;

import com.itheima.domain.Record;
import com.itheima.domain.User;
import com.itheima.entity.PageResult;
import com.itheima.entity.Result;
import com.itheima.service.RecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/record")
public class RecordController {
    //注入RecordService对象
    @Autowired
    private RecordService recordService;

    /**
     * 分页查询借阅记录
     * @param record 查询的条件封装到record中
     * @param pageNum  数据列表的当前页码
     * @param pageSize 数据列表1页展示多少条数据
     */
    @RequestMapping("/searchRecords")
    public ModelAndView searchRecords(Record record, Integer pageNum, Integer pageSize, HttpServletRequest request) {
        if (pageNum == null) {
            pageNum = 1;
        }
        if (pageSize == null) {
            pageSize = 10;
        }
        //获取当前登录的用户信息
        User user = (User) request.getSession().getAttribute("USER_SESSION");
        //查询到的借阅记录信息
        PageResult pageResult = recordService.searchRecords(record, user, pageNum, pageSize);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("record");
        //将查询到的数据存放在 ModelAndView的对象中
        modelAndView.addObject("pageResult", pageResult);
        //将查询的参数返回到页面，用于回显到查询的输入框中
        modelAndView.addObject("search", record);
        //将当前页码返回到页面，用于分页插件的分页显示
        modelAndView.addObject("pageNum", pageNum);
        //将当前查询的控制器路径返回到页面，页码变化时继续向该路径发送请求
        modelAndView.addObject("gourl", request.getRequestURI());
        return modelAndView;
    }

    /**
     * 删除借阅记录（仅管理员）
     * @param id 借阅记录id
     */
    @ResponseBody
    @RequestMapping("/deleteRecord")
    public Result deleteRecord(Integer id, HttpSession session) {
        try {
            User user = (User) session.getAttribute("USER_SESSION");
            if (user == null || !"admin".equals(user.getRole())) {
                return new Result(false, "无权限执行删除操作");
            }
            Integer count = recordService.delRecord(id);
            if (count != 1) {
                return new Result(false, "删除失败!");
            }
            return new Result(true, "删除成功!");
        } catch (Exception e) {
            e.printStackTrace();
            return new Result(false, "删除失败!");
        }
    }

    /**
     * 新增借阅记录
     * @param record 借阅记录信息
     */
    @ResponseBody
    @RequestMapping("/addRecord")
    public Result addRecord(Record record, HttpSession session) {
        try {
            //获取当前登录的用户姓名，设置为借阅记录的借阅人
            User user = (User) session.getAttribute("USER_SESSION");
            if (record.getBorrower() == null && user != null) {
                record.setBorrower(user.getName());
            }
            Integer count = recordService.addRecord(record);
            if (count != 1) {
                return new Result(false, "新增借阅记录失败!");
            }
            return new Result(true, "新增借阅记录成功!");
        } catch (Exception e) {
            e.printStackTrace();
            return new Result(false, "新增借阅记录失败!");
        }
    }
}
