<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>设置</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: #f0f2f5; min-height: 100vh; display: flex; }
        .sidebar { width: 250px; background: #fff; border-right: 1px solid #e0e0e0; padding: 20px 0; flex-shrink: 0; }
        .sidebar-header { padding: 0 20px 20px; border-bottom: 1px solid #e0e0e0; margin-bottom: 10px; }
        .sidebar-header h1 { font-size: 20px; font-weight: 600; color: #1a1a1a; }
        .nav-items { list-style: none; padding: 0 10px; }
        .nav-item { margin-bottom: 4px; }
        .nav-item a { display: flex; align-items: center; padding: 10px 12px; border-radius: 8px; text-decoration: none; color: #3c3c3c; font-size: 14px; transition: background 0.2s; }
        .nav-item a:hover { background: #f0f0f0; }
        .nav-item.active a { background: #e8f0fe; color: #1a73e8; }
        .nav-item .icon { margin-right: 12px; font-size: 16px; width: 20px; text-align: center; }
        .nav-section { margin-top: 20px; padding-top: 10px; border-top: 1px solid #e0e0e0; }
        .nav-section-title { padding: 8px 12px; font-size: 11px; font-weight: 600; color: #808080; text-transform: uppercase; letter-spacing: 0.5px; }
        .main-content { flex: 1; display: flex; flex-direction: column; min-width: 0; }
        .content-header { background: #fff; padding: 20px 30px; border-bottom: 1px solid #e0e0e0; }
        .search-box { width: 100%; max-width: 600px; padding: 10px 16px; border: 1px solid #d0d0d0; border-radius: 24px; font-size: 14px; background: #f5f5f5; }
        .search-box:focus { outline: none; border-color: #1a73e8; background: #fff; }
        .content-body { flex: 1; padding: 30px; overflow-y: auto; }
        .card { background: #fff; border-radius: 8px; box-shadow: 0 1px 2px rgba(0,0,0,0.05); margin-bottom: 24px; overflow: hidden; }
        .card-header { padding: 16px 20px; border-bottom: 1px solid #f0f0f0; }
        .card-header h3 { font-size: 14px; font-weight: 600; color: #1a1a1a; }
        .card-body { padding: 20px; }
        .profile-card { display: flex; align-items: center; padding: 20px; }
        .profile-avatar { width: 64px; height: 64px; border-radius: 50%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; font-size: 24px; color: white; margin-right: 20px; }
        .profile-info { flex: 1; }
        .profile-name { font-size: 18px; font-weight: 600; color: #1a1a1a; margin-bottom: 4px; }
        .profile-email { font-size: 14px; color: #5f6368; margin-bottom: 8px; }
        .profile-status { font-size: 12px; color: #808080; display: flex; align-items: center; }
        .profile-status::before { content: ''; width: 8px; height: 8px; background: #34a853; border-radius: 50%; margin-right: 6px; }
        .setting-item { display: flex; justify-content: space-between; align-items: center; padding: 16px 20px; border-bottom: 1px solid #f5f5f5; }
        .setting-item:last-child { border-bottom: none; }
        .setting-info { flex: 1; }
        .setting-title { font-size: 14px; font-weight: 500; color: #1a1a1a; margin-bottom: 2px; }
        .setting-desc { font-size: 12px; color: #5f6368; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-size: 13px; font-weight: 500; color: #1a1a1a; margin-bottom: 8px; }
        .form-group input { width: 100%; max-width: 400px; padding: 10px 14px; border: 1px solid #d0d0d0; border-radius: 4px; font-size: 14px; }
        .form-group input:focus { outline: none; border-color: #1a73e8; }
        .btn-primary { padding: 10px 24px; background: #1a73e8; color: white; border: none; border-radius: 4px; font-size: 14px; font-weight: 500; cursor: pointer; }
        .btn-primary:hover { background: #1557b0; }
        .success-message { padding: 12px 16px; background: #d4edda; border: 1px solid #c3e6cb; border-radius: 4px; color: #155720; font-size: 14px; margin-bottom: 20px; }
        .avatar-upload { display: flex; align-items: center; gap: 20px; }
        .avatar-preview { width: 80px; height: 80px; border-radius: 50%; overflow: hidden; border: 2px solid #e0e0e0; background: #f5f5f5; }
        .avatar-preview img { width: 100%; height: 100%; object-fit: cover; }
        .avatar-actions { display: flex; gap: 12px; flex-wrap: wrap; }
        .upload-btn, .random-avatar-btn { padding: 8px 16px; border: 1px solid #1a73e8; border-radius: 4px; background: white; color: #1a73e8; font-size: 14px; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; }
        .upload-btn:hover, .random-avatar-btn:hover { background: #e8f0fe; }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-header"><h1>设置</h1></div>
        <ul class="nav-items">
            <li class="nav-item active"><a href="${pageContext.request.contextPath}/user/profile"><span class="icon">👤</span><span>个人资料</span></a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/user/changePassword"><span class="icon">🔒</span><span>密码</span></a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/game/list"><span class="icon">🏠</span><span>返回首页</span></a></li>
        </ul>
        <div class="nav-section">
            <div class="nav-section-title">管理</div>
            <ul class="nav-items">
                <li class="nav-item"><a href="${pageContext.request.contextPath}/user/logout"><span class="icon">🚪</span><span>退出登录</span></a></li>
            </ul>
        </div>
    </div>

    <div class="main-content">
        <div class="content-header"><input type="text" class="search-box" placeholder="搜索设置..."></div>
        <div class="content-body">
            <div class="card">
                <div class="card-header"><h3>个人资料</h3></div>
                <div class="card-body">
                    <div class="profile-card">
                        <div class="profile-avatar">
                            <% 
                                String avatar = ((com.example.entity.User)session.getAttribute("user")).getAvatar();
                                if (avatar != null && !avatar.isEmpty()) {
                            %>
                                <img src="<%= request.getContextPath() %><%= avatar %>" alt="头像" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
                            <% } else { %>
                                <%= ((com.example.entity.User)session.getAttribute("user")).getUsername().substring(0, 1).toUpperCase() %>
                            <% } %>
                        </div>
                        <div class="profile-info">
                            <div class="profile-name"><%= ((com.example.entity.User)session.getAttribute("user")).getUsername() %></div>
                            <div class="profile-email"><%= ((com.example.entity.User)session.getAttribute("user")).getEmail() != null ? ((com.example.entity.User)session.getAttribute("user")).getEmail() : "未绑定邮箱" %></div>
                            <div class="profile-status">在线</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header"><h3>个人资料设置</h3></div>
                <% if (request.getAttribute("success") != null) { %>
                    <div class="success-message"><%= request.getAttribute("success") %></div>
                <% } %>

                <form action="${pageContext.request.contextPath}/user/updateProfile" method="post" enctype="multipart/form-data">
                    <div class="setting-item"><div class="setting-info"><div class="setting-title">用户名</div><div class="setting-desc">您的用户名用于登录和显示</div></div><span style="color: #5f6368;"><%= ((com.example.entity.User)session.getAttribute("user")).getUsername() %></span></div>
                    <div class="setting-item"><div class="setting-info"><div class="setting-title">角色</div><div class="setting-desc">您的账户权限等级</div></div><span style="color: <%= ((com.example.entity.User)session.getAttribute("user")).getRole() == 1 ? "#d93026" : "#1a73e8" %>"><%= ((com.example.entity.User)session.getAttribute("user")).getRole() == 1 ? "管理员" : "普通用户" %></span></div>
                    <div class="setting-item"><div class="setting-info"><div class="setting-title">注册时间</div><div class="setting-desc">账户创建日期</div></div><span style="color: #5f6368;"><%= request.getAttribute("formattedCreateTime") %></span></div>

                    <div style="padding: 16px 20px; border-top: 1px solid #f5f5f5;">
                        <div class="form-group">
                            <label>头像</label>
                            <div class="avatar-upload">
                                <div class="avatar-preview"><img id="avatar-img" src="" alt="头像"></div>
                                <div class="avatar-actions">
                                    <label class="upload-btn"><input type="file" name="avatar" accept="image/*" style="display: none;" onchange="previewImage(this)"><span>📷 上传头像</span></label>
                                </div>
                            </div>
                        </div>
                        <div class="form-group"><label>邮箱</label><input type="email" name="email" value="<%= ((com.example.entity.User)session.getAttribute("user")).getEmail() != null ? ((com.example.entity.User)session.getAttribute("user")).getEmail() : "" %>" placeholder="请输入邮箱"></div>
                        <div class="form-group"><label>手机号</label><input type="tel" name="phone" value="<%= ((com.example.entity.User)session.getAttribute("user")).getPhone() != null ? ((com.example.entity.User)session.getAttribute("user")).getPhone() : "" %>" placeholder="请输入手机号"></div>
                        <button type="submit" class="btn-primary">保存修改</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function createAvatar(color, initial) {
            const canvas = document.createElement('canvas');
            canvas.width = 100;
            canvas.height = 100;
            const ctx = canvas.getContext('2d');
            
            ctx.beginPath();
            ctx.arc(50, 50, 45, 0, Math.PI * 2);
            ctx.fillStyle = color;
            ctx.fill();
            
            ctx.fillStyle = 'white';
            ctx.font = 'bold 40px Arial, sans-serif';
            ctx.textAlign = 'center';
            ctx.textBaseline = 'middle';
            ctx.fillText(initial, 50, 50);
            
            return canvas.toDataURL('image/png');
        }

        window.onload = function() {
            const avatarImg = document.getElementById('avatar-img');
            const savedAvatar = '<%= ((com.example.entity.User)session.getAttribute("user")).getAvatar() != null ? ((com.example.entity.User)session.getAttribute("user")).getAvatar() : "" %>';
            if (savedAvatar) {
                avatarImg.src = '<%= request.getContextPath() %>' + savedAvatar;
            } else {
                const username = '<%= ((com.example.entity.User)session.getAttribute("user")).getUsername() %>';
                const initial = username.substring(0, 1).toUpperCase();
                avatarImg.src = createAvatar('#667eea', initial);
            }
        };

        function previewImage(input) {
            const avatarImg = document.getElementById('avatar-img');
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) { avatarImg.src = e.target.result; };
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</body>
</html>