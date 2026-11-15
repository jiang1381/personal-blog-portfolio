<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>购物车</title>
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
        .cart-item {
            display: flex;
            align-items: center;
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            transition: transform 0.3s;
        }
        .cart-item:hover {
            transform: translateX(5px);
        }
        .cart-item img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
            margin-right: 1.5rem;
        }
        .cart-item-info {
            flex: 1;
        }
        .cart-item-info h3 {
            margin-bottom: 0.5rem;
        }
        .cart-item-info p {
            color: #00d4ff;
            font-size: 1.2rem;
        }
        .quantity-control {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-right: 1rem;
        }
        .quantity-control button {
            width: 30px;
            height: 30px;
            border: none;
            background: #00d4ff;
            color: #fff;
            border-radius: 5px;
            cursor: pointer;
        }
        .quantity-control input {
            width: 50px;
            text-align: center;
            padding: 0.5rem;
            border: 1px solid #00d4ff;
            border-radius: 5px;
            background: rgba(0,0,0,0.3);
            color: #fff;
        }
        .remove-btn {
            padding: 0.5rem 1rem;
            background: #ff4757;
            border: none;
            border-radius: 5px;
            color: #fff;
            cursor: pointer;
            transition: background 0.3s;
        }
        .remove-btn:hover {
            background: #ff6b7a;
        }
        .total-section {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 2rem;
            margin-top: 2rem;
            padding-top: 1rem;
            border-top: 1px solid rgba(255,255,255,0.2);
        }
        .total-section p {
            font-size: 1.5rem;
            color: #00d4ff;
        }
        .checkout-btn {
            padding: 0.75rem 2rem;
            background: #00d4ff;
            border: none;
            border-radius: 5px;
            color: #fff;
            font-size: 1.1rem;
            cursor: pointer;
            transition: background 0.3s;
        }
        .checkout-btn:hover {
            background: #00a8cc;
        }
        .empty-cart {
            text-align: center;
            padding: 4rem;
        }
        .empty-cart p {
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">🎮 游戏商城</div>
        <div class="nav">
            <a href="/game/list">游戏列表</a>
            <a href="/cart/list" style="background: #28a745;">🛒 购物车</a>
            <a href="/order/list">📋 我的订单</a>
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
        <h2>🛒 我的购物车</h2>
        
        <c:if test="${empty cartItems}">
            <div class="empty-cart">
                <p>购物车是空的</p>
                <a href="/game/list" class="checkout-btn">去购物</a>
            </div>
        </c:if>
        
        <c:if test="${not empty cartItems}">
            <c:forEach var="item" items="${cartItems}">
                <div class="cart-item">
                    <img src="${item.image}" alt="${item.gameName}" />
                    <div class="cart-item-info">
                        <h3>${item.gameName}</h3>
                        <p>¥${item.price}</p>
                    </div>
                    <div class="quantity-control">
                        <button onclick="updateQuantity(${item.id}, ${item.quantity - 1})">-</button>
                        <input type="number" value="${item.quantity}" min="1" onchange="updateQuantity(${item.id}, this.value)" />
                        <button onclick="updateQuantity(${item.id}, ${item.quantity + 1})">+</button>
                    </div>
                    <p style="margin-right: 1rem;">¥${item.totalPrice}</p>
                    <button class="remove-btn" onclick="removeItem(${item.id})">删除</button>
                </div>
            </c:forEach>
            
            <div class="total-section">
                <p>合计: ¥${totalPrice}</p>
                <button class="checkout-btn" onclick="checkout()">去结算</button>
            </div>
        </c:if>
    </div>

    <script>
        function updateQuantity(id, quantity) {
            window.location.href = '/cart/update?id=' + id + '&quantity=' + quantity;
        }
        
        function removeItem(id) {
            if (confirm('确定删除该商品吗？')) {
                window.location.href = '/cart/remove/' + id;
            }
        }
        
        function checkout() {
            window.location.href = '/order/checkout';
        }
    </script>
</body>
</html>