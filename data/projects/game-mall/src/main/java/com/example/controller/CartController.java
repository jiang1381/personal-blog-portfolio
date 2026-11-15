package com.example.controller;

import com.example.entity.CartItem;
import com.example.entity.User;
import com.example.service.CartItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartItemService cartItemService;

    @RequestMapping("/list")
    public String list(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        List<CartItem> cartItems = cartItemService.findByUserId(user.getId());
        double totalPrice = cartItems.stream().mapToDouble(CartItem::getTotalPrice).sum();
        
        model.addAttribute("cartItems", cartItems);
        model.addAttribute("totalPrice", totalPrice);
        return "cartList";
    }

    @RequestMapping("/add")
    public String add(@RequestParam("gameId") Integer gameId, 
                     @RequestParam(value = "quantity", defaultValue = "1") Integer quantity,
                     HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        cartItemService.addToCart(user.getId(), gameId, quantity);
        
        model.addAttribute("message", "添加购物车成功");
        model.addAttribute("redirectUrl", "/game/list");
        return "userSuccess";
    }

    @RequestMapping("/update")
    public String update(@RequestParam("id") Integer id, 
                        @RequestParam("quantity") Integer quantity) {
        if (quantity <= 0) {
            cartItemService.removeFromCart(id);
        } else {
            cartItemService.updateQuantity(id, quantity);
        }
        return "redirect:/cart/list";
    }

    @RequestMapping("/remove/{id}")
    public String remove(@PathVariable("id") Integer id) {
        cartItemService.removeFromCart(id);
        return "redirect:/cart/list";
    }

    @RequestMapping("/clear")
    public String clear(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            cartItemService.clearCart(user.getId());
        }
        return "redirect:/cart/list";
    }
}