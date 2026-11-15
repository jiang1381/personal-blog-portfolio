<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的订单</title>
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
            max-width: 1200px;
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
            transition: transform 0.3s;
        }
        .order-card:hover {
            transform: translateY(-2px);
        }
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid rgba(255,255,255,0.2);
        }
        .order-no {
            font-size: 0.9rem;
            color: #999;
        }
        .order-status {
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.8rem;
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
        .status-canceled {
            background: #dc3545;
            color: #fff;
        }
        .order-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .order-info p {
            color: #00d4ff;
            font-size: 1.2rem;
        }
        .action-btn {
            padding: 0.5rem 1.5rem;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .view-btn {
            background: #00d4ff;
            color: #fff;
        }
        .view-btn:hover {
            background: #00a8cc;
        }
        .pay-btn {
            background: #28a745;
            color: #fff;
        }
        .pay-btn:hover {
            background: #218838;
        }
        .cancel-btn {
            background: #dc3545;
            color: #fff;
        }
        .cancel-btn:hover {
            background: #c82333;
        }
        .empty-orders {
            text-align: center;
            padding: 4rem;
        }
        .empty-orders p {
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">🎮 游戏商城</div>
        <div class="nav">
            <a href="/game/list">游戏列表</a>
            <a href="/cart/list">购物车</a>
            <div style="width: 35px; height: 35px; border-radius: 50%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; font-size: 14px; overflow: hidden;">
                <c:if test="${user.avatar != null && user.avatar != ''}">
                    <img src="${pageContext.request.contextPath}${user.avatar}" alt="头像" style="width: 100%; height: 100%; object-fit: cover;">
                </c:if>
                <c:if test="${user.avatar == null || user.avatar == ''}">
                    ${user.username.substring(0, 1).toUpperCase()}
                </c:if>
            </div>
            <span>欢迎, ${user.username}</span>
            <span class="${user.role == 1 ? 'admin' : 'user'}">${user.role == 1 ? '管理员' : '普通用户'}</span>
            <a href="/user/logout">退出登录</a>
        </div>
    </div>

    <div class="container">
        <h2>📋 我的订单</h2>
        
        <c:if test="${empty orders}">
            <div class="empty-orders">
                <p>暂无订单</p>
                <a href="/game/list" class="action-btn view-btn">去购物</a>
            </div>
        </c:if>
        
        <c:if test="${not empty orders}">
            <c:forEach var="order" items="${orders}">
                <div class="order-card">
                    <div class="order-header">
                        <span class="order-no">订单号: ${order.orderNo}</span>
                        <span class="order-status 
                            ${order.status == 0 ? 'status-pending' : ''}
                            ${order.status == 1 ? 'status-paid' : ''}
                            ${order.status == 2 ? 'status-delivered' : ''}
                            ${order.status == 3 ? 'status-completed' : ''}
                            ${order.status == 4 ? 'status-canceled' : ''}">${order.statusText}</span>
                    </div>
                    <div class="order-info">
                        <p>下单时间: <fmt:formatDate value="${order.createTime}" pattern="yyyy年MM月dd日 HH时mm分" /></p>
                        <p>订单金额: ¥${order.totalAmount}</p>
                        <div>
                            <button class="action-btn view-btn" onclick="viewDetail(${order.id})">查看详情</button>
                            <c:if test="${order.status == 0}">
                                <button class="action-btn pay-btn" onclick="payOrder(${order.id})">立即支付</button>
                                <button class="action-btn cancel-btn" onclick="cancelOrder(${order.id})">取消订单</button>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:if>
    </div>

    <script>
        function viewDetail(orderId) {
            window.location.href = '/order/detail/' + orderId;
        }
        
        function payOrder(orderId) {
            if (confirm('确定支付此订单吗？')) {
                window.location.href = '/order/pay/' + orderId;
            }
        }
        
        function cancelOrder(orderId) {
            if (confirm('确定取消此订单吗？')) {
                window.location.href = '/order/cancel/' + orderId;
            }
        }
    </script>
</body>
</html>