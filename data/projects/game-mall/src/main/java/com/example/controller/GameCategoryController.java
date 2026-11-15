package com.example.controller;

import com.example.entity.GameCategory;
import com.example.entity.User;
import com.example.service.GameCategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/category")
public class GameCategoryController {

    @Autowired
    private GameCategoryService gameCategoryService;

    @RequestMapping("/list")
    public String list(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        List<GameCategory> categories = gameCategoryService.findAll();
        model.addAttribute("categories", categories);
        model.addAttribute("user", user);
        return "categoryList";
    }

    @RequestMapping("/add")
    public String addPage(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            return "redirect:/category/list";
        }
        return "categoryAdd";
    }

    @RequestMapping(value = "/doAdd", method = RequestMethod.POST)
    public String doAdd(@RequestParam("name") String name,
                       @RequestParam("description") String description,
                       Model model) {
        try {
            GameCategory category = new GameCategory();
            category.setName(name);
            category.setDescription(description);
            int result = gameCategoryService.add(category);
            if (result > 0) {
                model.addAttribute("title", "添加成功");
                model.addAttribute("message", "分类已成功添加到数据库");
                model.addAttribute("detail", "分类名称: " + name);
                model.addAttribute("redirectUrl", "/category/list");
                return "success";
            } else {
                model.addAttribute("title", "添加失败");
                model.addAttribute("message", "分类添加失败，请稍后重试");
                model.addAttribute("detail", "分类名称: " + name);
                model.addAttribute("redirectUrl", "/category/add");
                return "error";
            }
        } catch (Exception e) {
            model.addAttribute("title", "添加失败");
            model.addAttribute("message", "添加分类时发生错误");
            model.addAttribute("detail", "错误信息: " + e.getMessage());
            model.addAttribute("redirectUrl", "/category/add");
            return "error";
        }
    }

    @RequestMapping("/edit")
    public String editPage(@RequestParam("id") Integer id, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            return "redirect:/category/list";
        }
        GameCategory category = gameCategoryService.findById(id);
        model.addAttribute("category", category);
        return "categoryEdit";
    }

    @RequestMapping(value = "/doEdit", method = RequestMethod.POST)
    public String doEdit(@RequestParam("id") Integer id,
                        @RequestParam("name") String name,
                        @RequestParam("description") String description,
                        Model model) {
        try {
            GameCategory category = gameCategoryService.findById(id);
            if (category == null) {
                model.addAttribute("title", "操作失败");
                model.addAttribute("message", "分类不存在，无法修改");
                model.addAttribute("detail", "分类ID: " + id);
                model.addAttribute("redirectUrl", "/category/list");
                return "error";
            }
            category.setName(name);
            category.setDescription(description);
            int result = gameCategoryService.update(category);
            if (result > 0) {
                model.addAttribute("title", "修改成功");
                model.addAttribute("message", "分类信息已成功更新");
                model.addAttribute("detail", "分类名称: " + name);
                model.addAttribute("redirectUrl", "/category/list");
                return "success";
            } else {
                model.addAttribute("title", "修改失败");
                model.addAttribute("message", "分类修改失败，请稍后重试");
                model.addAttribute("detail", "分类名称: " + name);
                model.addAttribute("redirectUrl", "/category/edit?id=" + id);
                return "error";
            }
        } catch (Exception e) {
            model.addAttribute("title", "修改失败");
            model.addAttribute("message", "修改分类时发生错误");
            model.addAttribute("detail", "错误信息: " + e.getMessage());
            model.addAttribute("redirectUrl", "/category/edit?id=" + id);
            return "error";
        }
    }

    @RequestMapping("/delete")
    public String delete(@RequestParam("id") Integer id, HttpSession session, Model model) {
        try {
            User user = (User) session.getAttribute("user");
            if (user == null || user.getRole() != 1) {
                return "redirect:/category/list";
            }
            GameCategory category = gameCategoryService.findById(id);
            String categoryName = category != null ? category.getName() : "未知分类";
            gameCategoryService.delete(id);
            model.addAttribute("title", "删除成功");
            model.addAttribute("message", "分类已成功从数据库中删除");
            model.addAttribute("detail", "已删除分类: " + categoryName);
            model.addAttribute("redirectUrl", "/category/list");
            return "success";
        } catch (Exception e) {
            model.addAttribute("title", "删除失败");
            model.addAttribute("message", "删除分类时发生错误");
            model.addAttribute("detail", "错误信息: " + e.getMessage());
            model.addAttribute("redirectUrl", "/category/list");
            return "error";
        }
    }
}