<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>游戏商城 - 分类管理</title>
    <style>
        body { font-family: Arial, sans-serif; background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); margin: 0; padding: 0; min-height: 100vh; }
        .header { background: #2d3436; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 10px rgba(0,0,0,0.3); }
        .header h1 { color: #00cec9; margin: 0; font-size: 24px; }
        .user-info { color: #b2bec3; display: flex; align-items: center; gap: 20px; }
        .btn { padding: 8px 16px; border: none; border-radius: 6px; cursor: pointer; font-size: 14px; font-weight: bold; text-decoration: none; display: inline-block; }
        .btn-primary { background: linear-gradient(135deg, #00cec9 0%, #81ecec 100%); color: #1a1a2e; }
        .btn-danger { background: #d63031; color: white; }
        .btn-secondary { background: #636e72; color: white; }
        .btn:hover { opacity: 0.9; }
        .container { padding: 30px; }
        .category-table { width: 100%; border-collapse: collapse; background: #2d3436; border-radius: 12px; overflow: hidden; }
        .category-table th, .category-table td { padding: 15px; text-align: left; border-bottom: 1px solid #4a5568; }
        .category-table th { background: #6c5ce7; color: white; }
        .category-table tr:hover { background: #3d4347; }
        .no-data { text-align: center; color: #636e72; padding: 50px; }
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.7); justify-content: center; align-items: center; z-index: 1000; }
        .modal-overlay.show { display: flex; }
        .modal { background: #2d3436; padding: 30px; border-radius: 12px; text-align: center; min-width: 300px; }
        .modal h3 { margin-bottom: 20px; }
        .modal p { color: #b2bec3; margin-bottom: 20px; }
        .modal-actions { display: flex; gap: 15px; justify-content: center; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🎮 游戏商城 - 分类管理</h1>
        <div class="user-info">
            <a href="${pageContext.request.contextPath}/game/list" class="btn btn-secondary">返回游戏列表</a>
            <a href="${pageContext.request.contextPath}/user/logout" class="btn btn-danger">退出登录</a>
        </div>
    </div>
    
    <div class="container">
        <div style="display: flex; justify-content: flex-end; margin-bottom: 20px;">
            <a href="${pageContext.request.contextPath}/category/add" class="btn btn-primary">添加分类</a>
        </div>
        
        <table class="category-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>分类名称</th>
                    <th>分类描述</th>
                    <th>创建时间</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${categories}" var="category">
                    <tr>
                        <td>${category.id}</td>
                        <td>${category.name}</td>
                        <td>${category.description}</td>
                        <td>${category.createTime}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/category/edit?id=${category.id}" class="btn btn-primary" style="padding: 5px 12px; font-size: 12px;">编辑</a>
                            <button class="btn btn-danger" style="padding: 5px 12px; font-size: 12px;" onclick="showDeleteModal(${category.id}, '${category.name}')">删除</button>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty categories}">
                    <tr>
                        <td colspan="5" class="no-data">暂无分类数据</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
    
    <div class="modal-overlay" id="deleteModal">
        <div class="modal">
            <h3 style="color: #ff6b6b;">删除分类</h3>
            <p id="deleteMessage"></p>
            <div class="modal-actions">
                <button class="btn btn-danger" onclick="confirmDelete()">确认删除</button>
                <button class="btn btn-secondary" onclick="closeDeleteModal()">取消</button>
            </div>
        </div>
    </div>
    
    <script>
        var deleteCategoryId = 0;
        var deleteCategoryName = '';
        
        function showDeleteModal(categoryId, categoryName) {
            deleteCategoryId = categoryId;
            deleteCategoryName = categoryName;
            document.getElementById('deleteMessage').innerHTML = '确定要删除分类 <strong style="color: #ff6b6b;">' + categoryName + '</strong> 吗？<br/><br/><span style="color: #636e72; font-size: 14px;">此操作无法撤销，请谨慎操作。</span>';
            document.getElementById('deleteModal').classList.add('show');
        }
        
        function closeDeleteModal() {
            document.getElementById('deleteModal').classList.remove('show');
        }
        
        function confirmDelete() {
            closeDeleteModal();
            window.location.href = '${pageContext.request.contextPath}/category/delete?id=' + deleteCategoryId;
        }
        
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeDeleteModal();
            }
        });
    </script>
</body>
</html>