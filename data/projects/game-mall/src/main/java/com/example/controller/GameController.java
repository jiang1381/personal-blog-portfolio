package com.example.controller;

import com.example.entity.Game;
import com.example.entity.GameCategory;
import com.example.entity.User;
import com.example.service.GameCategoryService;
import com.example.service.GameService;
import com.example.service.CartItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/game")
public class GameController {

    @Autowired
    private GameService gameService;

    @Autowired
    private GameCategoryService gameCategoryService;

    @Autowired
    private CartItemService cartItemService;

    @RequestMapping("/list")
    public String list(Model model, HttpSession session,
                      @RequestParam(value = "keyword", required = false) String keyword,
                      @RequestParam(value = "category", required = false) Integer categoryId) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        List<Game> games = gameService.search(keyword, categoryId);
        List<GameCategory> categories = gameCategoryService.findAll();
        model.addAttribute("games", games);
        model.addAttribute("categories", categories);
        model.addAttribute("user", user);
        
        // 管理员统计数据
        if (user.getRole() == 1) {
            Map<String, Integer> stats = new HashMap<>();
            stats.put("userCount", gameService.getUserCount());
            stats.put("orderCount", gameService.getOrderCount());
            stats.put("gameCount", gameService.getGameCount());
            stats.put("pendingOrders", gameService.getPendingOrderCount());
            model.addAttribute("stats", stats);
        }
        
        // 普通用户购物车数量和热门推荐
        if (user.getRole() == 0) {
            int cartCount = cartItemService.countByUserId(user.getId());
            model.addAttribute("cartCount", cartCount);
            List<Game> featuredGames = gameService.getFeaturedGames(6);
            model.addAttribute("featuredGames", featuredGames);
        }
        
        return "gameList";
    }

    @RequestMapping("/add")
    public String addPage(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            return "redirect:/game/list";
        }
        List<GameCategory> categories = gameCategoryService.findAll();
        model.addAttribute("categories", categories);
        return "gameAdd";
    }

    @RequestMapping(value = "/doAdd", method = RequestMethod.POST)
    public String doAdd(@RequestParam("name") String name,
                       @RequestParam("description") String description,
                       @RequestParam("price") Double price,
                       @RequestParam("categoryId") Integer categoryId,
                       @RequestParam("image") String image,
                       @RequestParam("stock") Integer stock,
                       Model model) {
        try {
            Game game = new Game();
            game.setName(name);
            game.setDescription(description);
            game.setPrice(price);
            game.setCategoryId(categoryId);
            game.setImage(image);
            game.setStock(stock);
            int result = gameService.add(game);
            if (result > 0) {
                model.addAttribute("title", "添加成功");
                model.addAttribute("message", "游戏已成功添加到数据库");
                model.addAttribute("detail", "游戏名称: " + name + " | 价格: ¥" + price);
                model.addAttribute("redirectUrl", "/game/list");
                return "success";
            } else {
                model.addAttribute("title", "添加失败");
                model.addAttribute("message", "游戏添加失败，请稍后重试");
                model.addAttribute("detail", "游戏名称: " + name);
                model.addAttribute("redirectUrl", "/game/add");
                return "error";
            }
        } catch (Exception e) {
            model.addAttribute("title", "添加失败");
            model.addAttribute("message", "添加游戏时发生错误");
            model.addAttribute("detail", "错误信息: " + e.getMessage());
            model.addAttribute("redirectUrl", "/game/add");
            return "error";
        }
    }

    @RequestMapping("/edit")
    public String editPage(@RequestParam("id") Integer id, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            return "redirect:/game/list";
        }
        Game game = gameService.findById(id);
        List<GameCategory> categories = gameCategoryService.findAll();
        model.addAttribute("game", game);
        model.addAttribute("categories", categories);
        return "gameEdit";
    }

    @RequestMapping(value = "/doEdit", method = RequestMethod.POST)
    public String doEdit(@RequestParam("id") Integer id,
                        @RequestParam("name") String name,
                        @RequestParam("description") String description,
                        @RequestParam("price") Double price,
                        @RequestParam("categoryId") Integer categoryId,
                        @RequestParam("image") String image,
                        @RequestParam("stock") Integer stock,
                        Model model) {
        try {
            Game game = gameService.findById(id);
            if (game == null) {
                model.addAttribute("title", "操作失败");
                model.addAttribute("message", "游戏不存在，无法修改");
                model.addAttribute("detail", "游戏ID: " + id);
                model.addAttribute("redirectUrl", "/game/list");
                return "error";
            }
            game.setName(name);
            game.setDescription(description);
            game.setPrice(price);
            game.setCategoryId(categoryId);
            game.setImage(image);
            game.setStock(stock);
            int result = gameService.update(game);
            if (result > 0) {
                model.addAttribute("title", "修改成功");
                model.addAttribute("message", "游戏信息已成功更新");
                model.addAttribute("detail", "游戏名称: " + name + " | 价格: ¥" + price);
                model.addAttribute("redirectUrl", "/game/list");
                return "success";
            } else {
                model.addAttribute("title", "修改失败");
                model.addAttribute("message", "游戏修改失败，请稍后重试");
                model.addAttribute("detail", "游戏名称: " + name);
                model.addAttribute("redirectUrl", "/game/edit?id=" + id);
                return "error";
            }
        } catch (Exception e) {
            model.addAttribute("title", "修改失败");
            model.addAttribute("message", "修改游戏时发生错误");
            model.addAttribute("detail", "错误信息: " + e.getMessage());
            model.addAttribute("redirectUrl", "/game/edit?id=" + id);
            return "error";
        }
    }

    @RequestMapping("/delete")
    public String delete(@RequestParam("id") Integer id, HttpSession session, Model model) {
        try {
            User user = (User) session.getAttribute("user");
            if (user == null || user.getRole() != 1) {
                return "redirect:/game/list";
            }
            Game game = gameService.findById(id);
            String gameName = game != null ? game.getName() : "未知游戏";
            gameService.delete(id);
            model.addAttribute("title", "删除成功");
            model.addAttribute("message", "游戏已成功从数据库中删除");
            model.addAttribute("detail", "已删除游戏: " + gameName);
            model.addAttribute("redirectUrl", "/game/list");
            return "success";
        } catch (Exception e) {
            model.addAttribute("title", "删除失败");
            model.addAttribute("message", "删除游戏时发生错误");
            model.addAttribute("detail", "错误信息: " + e.getMessage());
            model.addAttribute("redirectUrl", "/game/list");
            return "error";
        }
    }
}