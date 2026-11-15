
package com.example.controller;

import com.example.entity.User;
import com.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @RequestMapping("/login")
    public String loginPage() {
        return "login";
    }

    @RequestMapping(value = "/doLogin", method = RequestMethod.POST)
    public String doLogin(@RequestParam("username") String username,
                         @RequestParam("password") String password,
                         HttpSession session,
                         Model model) {
        User user = userService.login(username, password);
        if (user != null) {
            session.setAttribute("user", user);
            return "redirect:/game/list";
        } else {
            model.addAttribute("error", "用户名或密码错误");
            return "login";
        }
    }

    @RequestMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/user/login";
    }

    @RequestMapping("/register")
    public String registerPage() {
        return "register";
    }

    @RequestMapping(value = "/doRegister", method = RequestMethod.POST)
    public String doRegister(@RequestParam("username") String username,
                            @RequestParam("password") String password,
                            @RequestParam("email") String email,
                            @RequestParam("phone") String phone,
                            Model model) {
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);
        user.setPhone(phone);
        user.setRole(0);
        int result = userService.register(user);
        if (result > 0) {
            return "redirect:/user/login";
        } else {
            model.addAttribute("error", "注册失败");
            return "register";
        }
    }

    @RequestMapping("/admin/list")
    public String adminList(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            return "redirect:/user/login";
        }
        List<User> users = userService.findAll();
        model.addAttribute("users", users);
        return "adminUserList";
    }

    @RequestMapping("/admin/add")
    public String adminAddPage(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            return "redirect:/user/login";
        }
        return "adminUserAdd";
    }

    @RequestMapping(value = "/admin/doAdd", method = RequestMethod.POST)
    public String adminDoAdd(@RequestParam("username") String username,
                            @RequestParam("password") String password,
                            @RequestParam("email") String email,
                            @RequestParam("phone") String phone,
                            @RequestParam("role") Integer role,
                            HttpSession session,
                            Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            return "redirect:/user/login";
        }
        
        User existing = userService.findByUsername(username);
        if (existing != null) {
            model.addAttribute("error", "用户名已存在");
            return "adminUserAdd";
        }
        
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(password);
        newUser.setEmail(email);
        newUser.setPhone(phone);
        newUser.setRole(role);
        int result = userService.register(newUser);
        
        if (result > 0) {
            return "redirect:/user/admin/list";
        } else {
            model.addAttribute("error", "添加失败");
            return "adminUserAdd";
        }
    }

    @RequestMapping("/admin/edit/{id}")
    public String adminEditPage(@PathVariable("id") Integer id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            return "redirect:/user/login";
        }
        User targetUser = userService.findById(id);
        if (targetUser == null) {
            model.addAttribute("message", "用户不存在");
            model.addAttribute("redirectUrl", "/user/admin/list");
            return "error";
        }
        model.addAttribute("user", targetUser);
        return "adminUserEdit";
    }

    @RequestMapping(value = "/admin/doEdit", method = RequestMethod.POST)
    public String adminDoEdit(@RequestParam("id") Integer id,
                             @RequestParam("username") String username,
                             @RequestParam("email") String email,
                             @RequestParam("phone") String phone,
                             @RequestParam("role") Integer role,
                             HttpSession session,
                             Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            return "redirect:/user/login";
        }
        
        User targetUser = userService.findById(id);
        if (targetUser == null) {
            model.addAttribute("message", "用户不存在");
            model.addAttribute("redirectUrl", "/user/admin/list");
            return "error";
        }
        
        User existing = userService.findByUsername(username);
        if (existing != null && !existing.getId().equals(id)) {
            model.addAttribute("error", "用户名已存在");
            model.addAttribute("user", targetUser);
            return "adminUserEdit";
        }
        
        targetUser.setUsername(username);
        targetUser.setEmail(email);
        targetUser.setPhone(phone);
        targetUser.setRole(role);
        userService.update(targetUser);
        
        return "redirect:/user/admin/list";
    }

    @RequestMapping("/admin/delete/{id}")
    public String adminDelete(@PathVariable("id") Integer id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            return "redirect:/user/login";
        }
        
        User targetUser = userService.findById(id);
        if (targetUser == null) {
            model.addAttribute("message", "用户不存在");
            model.addAttribute("redirectUrl", "/user/admin/list");
            return "error";
        }
        
        userService.delete(id);
        return "redirect:/user/admin/list";
    }

    @RequestMapping("/admin/resetPassword/{id}")
    public String adminResetPasswordPage(@PathVariable("id") Integer id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            return "redirect:/user/login";
        }
        User targetUser = userService.findById(id);
        if (targetUser == null) {
            model.addAttribute("message", "用户不存在");
            model.addAttribute("redirectUrl", "/user/admin/list");
            return "error";
        }
        model.addAttribute("user", targetUser);
        return "adminResetPassword";
    }

    @RequestMapping(value = "/admin/doResetPassword", method = RequestMethod.POST)
    public String adminDoResetPassword(@RequestParam("id") Integer id,
                                       @RequestParam("newPassword") String newPassword,
                                       @RequestParam("confirmPassword") String confirmPassword,
                                       HttpSession session,
                                       Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            return "redirect:/user/login";
        }
        
        User targetUser = userService.findById(id);
        if (targetUser == null) {
            model.addAttribute("message", "用户不存在");
            model.addAttribute("redirectUrl", "/user/admin/list");
            return "error";
        }
        
        if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("error", "两次输入的密码不一致");
            model.addAttribute("user", targetUser);
            return "adminResetPassword";
        }
        
        targetUser.setPassword(newPassword);
        userService.update(targetUser);
        
        return "redirect:/user/admin/list";
    }

    @RequestMapping("/profile")
    public String profile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        model.addAttribute("user", user);
        if (user.getCreateTime() != null) {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy年MM月dd日 HH:mm:ss");
            model.addAttribute("formattedCreateTime", sdf.format(user.getCreateTime()));
        } else {
            model.addAttribute("formattedCreateTime", "未知");
        }
        return "userProfile";
    }

    @RequestMapping(value = "/updateProfile", method = RequestMethod.POST)
    public String updateProfile(@RequestParam("email") String email,
                               @RequestParam("phone") String phone,
                               @RequestParam(value = "avatar", required = false) MultipartFile avatar,
                               HttpSession session,
                               Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        user.setEmail(email);
        user.setPhone(phone);
        
        if (avatar != null && !avatar.isEmpty()) {
            String uploadDir = "h:/trae/src/main/webapp/uploads/";
            File dir = new File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }
            
            String originalFilename = avatar.getOriginalFilename();
            String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            String newFilename = UUID.randomUUID().toString() + extension;
            
            try {
                avatar.transferTo(new File(uploadDir + newFilename));
                user.setAvatar("/uploads/" + newFilename);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        
        userService.updateProfile(user);
        
        session.setAttribute("user", userService.findById(user.getId()));
        model.addAttribute("success", "个人信息更新成功");
        model.addAttribute("user", user);
        return "userProfile";
    }

    @RequestMapping("/changePassword")
    public String changePasswordPage(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        return "changePassword";
    }

    @RequestMapping(value = "/doChangePassword", method = RequestMethod.POST)
    public String doChangePassword(@RequestParam("oldPassword") String oldPassword,
                                   @RequestParam("newPassword") String newPassword,
                                   @RequestParam("confirmPassword") String confirmPassword,
                                   HttpSession session,
                                   Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        if (!user.getPassword().equals(oldPassword)) {
            model.addAttribute("error", "原密码不正确");
            return "changePassword";
        }
        
        if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("error", "两次输入的新密码不一致");
            return "changePassword";
        }
        
        user.setPassword(newPassword);
        userService.update(user);
        
        model.addAttribute("success", "密码修改成功");
        return "changePassword";
    }
}
