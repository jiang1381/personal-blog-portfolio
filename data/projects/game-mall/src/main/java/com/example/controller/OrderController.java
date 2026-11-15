package com.example.controller;

import com.example.entity.CartItem;
import com.example.entity.Order;
import com.example.entity.OrderItem;
import com.example.entity.User;
import com.example.service.CartItemService;
import com.example.service.OrderService;
import com.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/order")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private CartItemService cartItemService;

    @Autowired
    private UserService userService;

    @RequestMapping("/list")
    public String list(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        List<Order> orders = orderService.findByUserId(user.getId());
        model.addAttribute("orders", orders);
        return "orderList";
    }

    @RequestMapping("/checkout")
    public String checkout(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        List<CartItem> cartItems = cartItemService.findByUserId(user.getId());
        if (cartItems.isEmpty()) {
            model.addAttribute("message", "购物车为空");
            model.addAttribute("redirectUrl", "/cart/list");
            return "userError";
        }
        
        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem cartItem : cartItems) {
            OrderItem item = new OrderItem();
            item.setGameId(cartItem.getGameId());
            item.setGameName(cartItem.getGameName());
            item.setPrice(cartItem.getPrice());
            item.setQuantity(cartItem.getQuantity());
            item.setImage(cartItem.getImage());
            orderItems.add(item);
        }
        
        Order order = orderService.createOrder(user.getId(), orderItems);
        cartItemService.clearCart(user.getId());
        
        model.addAttribute("order", order);
        model.addAttribute("orderItems", orderItems);
        return "orderSuccess";
    }

    @RequestMapping("/detail/{id}")
    public String detail(@PathVariable("id") Integer id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        Order order = orderService.findById(id);
        if (order == null || !order.getUserId().equals(user.getId())) {
            model.addAttribute("message", "订单不存在");
            model.addAttribute("redirectUrl", "/order/list");
            return "userError";
        }
        
        List<OrderItem> items = orderService.findOrderItems(id);
        model.addAttribute("order", order);
        model.addAttribute("orderItems", items);
        return "orderDetail";
    }

    @RequestMapping("/pay/{id}")
    public String pay(@PathVariable("id") Integer id, 
                     @RequestParam(value = "password", required = false) String password,
                     HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        Order order = orderService.findById(id);
        if (order == null || !order.getUserId().equals(user.getId())) {
            model.addAttribute("errorMsg", "订单不存在");
            return "payError";
        }
        
        if (order.getStatus() != 0) {
            model.addAttribute("errorMsg", "订单状态异常，当前状态: " + order.getStatusText() + "，无法重复支付");
            return "payError";
        }
        
        // 如果没有提交密码，显示密码输入页面
        if (password == null || password.isEmpty()) {
            model.addAttribute("order", order);
            return "payPassword";
        }
        
        // 验证密码
        if (!userService.verifyPassword(user.getId(), password)) {
            model.addAttribute("order", order);
            model.addAttribute("errorMsg", "密码错误，请重新输入");
            return "payPassword";
        }
        
        orderService.updateStatus(id, 1);
        
        model.addAttribute("orderNo", order.getOrderNo());
        return "userSuccess";
    }

    @RequestMapping("/admin/list")
    public String adminList(HttpSession session, Model model,
                          @RequestParam(value = "status", required = false) Integer status) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            return "redirect:/user/login";
        }
        
        List<Order> orders;
        if (status != null) {
            orders = orderService.findByStatus(status);
        } else {
            orders = orderService.findAll();
        }
        model.addAttribute("orders", orders);
        model.addAttribute("selectedStatus", status);
        return "adminOrderList";
    }

    @RequestMapping("/admin/pending")
    public String adminPendingOrders(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            return "redirect:/user/login";
        }
        
        return "redirect:/order/admin/list?status=1";
    }

    @RequestMapping("/admin/detail/{id}")
    public String adminDetail(@PathVariable("id") Integer id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            return "redirect:/user/login";
        }
        
        Order order = orderService.findById(id);
        if (order == null) {
            model.addAttribute("message", "订单不存在");
            model.addAttribute("redirectUrl", "/order/admin/list");
            return "error";
        }
        
        List<OrderItem> items = orderService.findOrderItems(id);
        model.addAttribute("order", order);
        model.addAttribute("orderItems", items);
        return "adminOrderDetail";
    }

    @RequestMapping("/admin/deliver/{id}")
    public String deliver(@PathVariable("id") Integer id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            return "redirect:/user/login";
        }
        
        Order order = orderService.findById(id);
        if (order == null) {
            model.addAttribute("title", "发货失败");
            model.addAttribute("message", "订单不存在");
            model.addAttribute("detail", "未找到ID为 " + id + " 的订单");
            model.addAttribute("redirectUrl", "/order/admin/list");
            return "error";
        }
        
        if (order.getStatus() != 1) {
            model.addAttribute("title", "发货失败");
            model.addAttribute("message", "只能对已支付的订单发货");
            model.addAttribute("detail", "当前订单状态: " + order.getStatusText());
            model.addAttribute("redirectUrl", "/order/admin/list");
            return "error";
        }
        
        orderService.updateStatus(id, 2);
        
        model.addAttribute("title", "发货成功");
        model.addAttribute("message", "订单已成功发货");
        model.addAttribute("detail", "订单号: " + order.getOrderNo());
        model.addAttribute("redirectUrl", "/order/admin/list");
        return "success";
    }

    @RequestMapping("/cancel/{id}")
    public String cancel(@PathVariable("id") Integer id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        Order order = orderService.findById(id);
        if (order == null || !order.getUserId().equals(user.getId())) {
            model.addAttribute("title", "取消失败");
            model.addAttribute("message", "订单不存在");
            model.addAttribute("redirectUrl", "/order/list");
            return "error";
        }
        
        if (order.getStatus() != 0) {
            model.addAttribute("title", "取消失败");
            model.addAttribute("message", "只能取消待支付的订单");
            model.addAttribute("detail", "当前订单状态: " + order.getStatusText());
            model.addAttribute("redirectUrl", "/order/list");
            return "userError";
        }
        
        orderService.updateStatus(id, 4);
        
        model.addAttribute("title", "取消成功");
        model.addAttribute("message", "订单已成功取消");
        model.addAttribute("detail", "订单号: " + order.getOrderNo());
        model.addAttribute("redirectUrl", "/order/list");
        return "userSuccess";
    }

    @RequestMapping("/admin/delete/{id}")
    public String adminDelete(@PathVariable("id") Integer id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            return "redirect:/user/login";
        }
        
        Order order = orderService.findById(id);
        if (order == null) {
            model.addAttribute("title", "删除失败");
            model.addAttribute("message", "订单不存在");
            model.addAttribute("redirectUrl", "/order/admin/list");
            return "error";
        }
        
        orderService.deleteById(id);
        
        model.addAttribute("title", "删除成功");
        model.addAttribute("message", "订单已成功删除");
        model.addAttribute("detail", "订单号: " + order.getOrderNo());
        model.addAttribute("redirectUrl", "/order/admin/list");
        return "success";
    }
}