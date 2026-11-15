<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>游戏商城 - 添加游戏</title>
    <style>
        body { font-family: Arial, sans-serif; background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); min-height: 100vh; margin: 0; }
        .container { width: 500px; margin: 80px auto; padding: 30px; background: #2d3436; border-radius: 12px; box-shadow: 0 8px 32px rgba(0,0,0,0.3); }
        h2 { text-align: center; color: #00cec9; margin-bottom: 30px; font-size: 24px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; color: #b2bec3; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 12px; border: 1px solid #4a5568; border-radius: 6px; font-size: 14px; box-sizing: border-box; background: #1a1a2e; color: white; }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus { outline: none; border-color: #00cec9; }
        .form-group textarea { height: 100px; resize: vertical; }
        .btn { width: 100%; padding: 12px; background: linear-gradient(135deg, #00cec9 0%, #81ecec 100%); color: #1a1a2e; border: none; border-radius: 6px; cursor: pointer; font-size: 16px; font-weight: bold; }
        .btn:hover { opacity: 0.9; }
        .btn-secondary { background: #636e72; color: white; margin-top: 10px; }
        .error { color: #ff6b6b; text-align: center; margin-bottom: 15px; }
        .link { text-align: center; margin-top: 15px; }
        .link a { color: #00cec9; text-decoration: none; }
    </style>
</head>
<body>
    <div class="container">
        <h2>添加游戏</h2>
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/game/doAdd" method="post">
            <div class="form-group">
                <label>游戏名称：</label>
                <input type="text" name="name" required placeholder="请输入游戏名称">
            </div>
            <div class="form-group">
                <label>游戏描述：</label>
                <textarea name="description" placeholder="请输入游戏描述"></textarea>
            </div>
            <div class="form-group">
                <label>价格：</label>
                <input type="number" name="price" step="0.01" required placeholder="请输入价格">
            </div>
            <div class="form-group">
                <label>游戏分类：</label>
                <select name="categoryId">
                    <option value="">请选择分类</option>
                    <c:forEach items="${categories}" var="category">
                        <option value="${category.id}">${category.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label>封面图片URL：</label>
                <input type="text" name="image" placeholder="请输入图片URL">
            </div>
            <div class="form-group">
                <label>库存数量：</label>
                <input type="number" name="stock" required placeholder="请输入库存数量">
            </div>
            <button type="submit" class="btn">添加游戏</button>
            <button type="button" class="btn btn-secondary" onclick="location.href='${pageContext.request.contextPath}/game/list'">返回列表</button>
        </form>
    </div>
</body>
</html>