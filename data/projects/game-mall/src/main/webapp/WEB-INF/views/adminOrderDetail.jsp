<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单详情</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            min-height: 100vh;
            color: #fff;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 2rem;
            background: rgba(0,0,0,0.3);
            box-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        .logo {
            font-size: 1.5rem;
            font-weight: bold;
            color: #00d4ff;
        }
        .nav {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        .nav a, .nav button {
            padding: 0.5rem 1rem;
            border-radius: 5px;
            text-decoration: none;
            color: #fff;
            background: #00d4ff;
            border: none;
            cursor: pointer;
            transition: all 0.3s;
        }
        .nav a:hover, .nav button:hover {
            background: #00a8cc;
        }
        .container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 2rem;
        }
        h2 {
            margin-bottom: 2rem;
            color: #00d4ff;
        }
        .order-card {
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid rgba(255,255,255,0.2);
        }
        .order-no {
            font-size: 1.2rem;
            color: #00d4ff;
        }
        .order-status {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
        }
        .status-pending {
            background: #ffc107;
            color: #333;
        }
        .status-paid {
            background: #28a745;
            color: #fff;
        }
        .status-delivered {
            background: #00d4ff;
            color: #fff;
        }
        .status-completed {
            background: #6c757d;
            color: #fff;
        }
        .order-info {
            margin-bottom: 1.5rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid rgba(255,255,255,0.2);
        }
        .order-info p {
            margin-bottom: 0.5rem;
        }
        .order-items {
            margin-bottom: 1.5rem;
        }
        .order-items h3 {
            margin-bottom: 1rem;
            color: #00d4ff;
        }
        .item-row {
            display: flex;
            align-items: center;
            padding: 1rem;
            background: rgba(0,0,0,0.2);
            border-radius: 8px;
            margin-bottom: 1rem;
        }
        .item-row img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
            margin-right: 1rem;
        }
        .item-info {
            flex: 1;
        }
        .item-info h4 {
            margin-bottom: 0.5rem;
        }
        .item-info p {
            color: #00d4ff;
        }
        .total-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 1rem;
            border-top: 1px solid rgba(255,255,255,0.2);
            font-size: 1.2rem;
        }
        .total-section span:last-child {
            color: #00d4ff;
        }
        .action-btn {
            padding: 0.75rem 2rem;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .deliver-btn {
            background: #28a745;
            color: #fff;
        }
        .deliver-btn:hover {
            background: #218838;
        }
        .back-btn {
            background: rgba(255,255,255,0.2);
            color: #fff;
            text-decoration: none;
            padding: 0.75rem 2rem;
            border-radius: 5px;
            margin-right: 1rem;
        }
        .back-btn:hover {
            background: rgba(255,255,255,0.3);
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">🎮 游戏商城</div>
        <div class="nav">
            <a href="/game/list">游戏列表</a>
            <div style="width: 35px; height: 35px; border-radius: 50%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; font-size: 14px; overflow: hidden;">
                <c:if test="${user.avatar != null && user.avatar != ''}">
                    <img src="${pageContext.request.contextPath}${user.avatar}" alt="头像" style="width: 100%; height: 100%; object-fit: cover;">
                </c:if>
                <c:if test="${user.avatar == null || user.avatar == ''}">
                    ${user.username.substring(0, 1).toUpperCase()}
                </c:if>
            </div>
            <span>欢迎, ${user.username}</span>
            <span style="background: #d63031; padding: 0.5rem 1rem; border-radius: 5px;">管理员</span>
            <a href="/user/logout">退出登录</a>
        </div>
    </div>

    <div class="container">
        <h2>📋 订单详情</h2>
        
        <div class="order-card">
            <div class="order-header">
                <span class="order-no">订单号: ${order.orderNo}</span>
                <span class="order-status 
                    ${order.status == 0 ? 'status-pending' : ''}
                    ${order.status == 1 ? 'status-paid' : ''}
                    ${order.status == 2 ? 'status-delivered' : ''}
                    ${order.status == 3 ? 'status-completed' : ''}">
                    ${order.statusText}
                </span>
            </div>
            
            <div class="order-info">
                <p>用户ID: ${order.userId}</p>
                <p>下单时间: <fmt:formatDate value="${order.createTime}" pattern="yyyy年MM月dd日 HH时mm分" /></p>
                <p>订单金额: ¥${order.totalAmount}</p>
            </div>
            
            <div class="order-items">
                <h3>商品列表:</h3>
                <c:forEach var="item" items="${orderItems}">
                    <div class="item-row">
                        <img src="${item.image}" alt="${item.gameName}" />
                        <div class="item-info">
                            <h4>${item.gameName}</h4>
                            <p>¥${item.price} x ${item.quantity}</p>
                        </div>
                        <p style="color: #00d4ff;">¥${item.totalPrice}</p>
                    </div>
                </c:forEach>
            </div>
            
            <div class="total-section">
                <span>合计:</span>
                <span>¥${order.totalAmount}</span>
            </div>
            
            <div style="margin-top: 2rem; text-align: right;">
                <a href="/order/admin/list" class="back-btn">返回订单列表</a>
                <c:if test="${order.status == 1}">
                    <button class="action-btn deliver-btn" data-order-id="${order.id}" onclick="deliverOrder(this)">发货</button>
                </c:if>
            </div>
        </div>
    </div>

    <script>
        function deliverOrder(btn) {
            var orderId = btn.getAttribute('data-order-id');
            if (confirm('确定发货此订单吗？')) {
                window.location.href = '/order/admin/deliver/' + orderId;
            }
        }
    </script>
</body>
</html>