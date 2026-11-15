<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta name="referrer" content="no-referrer">
    <title>游戏商城 - 游戏列表</title>
    <style>
        /* 公共样式 */
        * { box-sizing: border-box; }
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; min-height: 100vh; }
        .btn { padding: 8px 16px; border: none; border-radius: 6px; cursor: pointer; font-size: 14px; font-weight: bold; text-decoration: none; display: inline-block; transition: all 0.3s; }
        .btn:hover { opacity: 0.9; transform: translateY(-1px); }
        .container { padding: 30px; }
        .game-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 25px; }
        .game-card { border-radius: 12px; overflow: hidden; transition: transform 0.3s; }
        .game-card:hover { transform: translateY(-5px); }
        .game-image { height: 180px; display: flex; align-items: center; justify-content: center; position: relative; }
        .game-image img { width: 100%; height: 100%; object-fit: cover; }
        .game-info { padding: 20px; }
        .game-name { font-size: 18px; font-weight: bold; margin-bottom: 10px; }
        .game-desc { font-size: 14px; margin-bottom: 15px; line-height: 1.4; height: 42px; overflow: hidden; }
        .game-meta { display: flex; justify-content: space-between; align-items: center; }
        .game-price { font-size: 20px; font-weight: bold; }
        .game-stock { font-size: 12px; }
        .game-actions { margin-top: 15px; display: flex; gap: 10px; }
        .category-filter { margin-bottom: 25px; display: flex; gap: 10px; flex-wrap: wrap; }
        .filter-btn { padding: 8px 16px; border: 1px solid; border-radius: 20px; background: transparent; cursor: pointer; transition: all 0.3s; }
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.7); justify-content: center; align-items: center; z-index: 1000; }
        .modal-overlay.show { display: flex; }
        .modal { padding: 30px; border-radius: 12px; text-align: center; min-width: 300px; }
        .modal h3 { margin-bottom: 20px; }
        .modal p { margin-bottom: 20px; }
        .modal-actions { display: flex; gap: 15px; justify-content: center; }

        /* 管理员主题 */
        body.admin-theme { background: linear-gradient(135deg, #2d1b4e 0%, #1a1a2e 50%, #4a1942 100%); }
        body.admin-theme .header { background: linear-gradient(135deg, #1a1a2e 0%, #2d1b4e 100%); border-bottom: 2px solid #d63031; }
        body.admin-theme .header h1 { color: #ff6b6b; }
        body.admin-theme .user-info { color: #b2bec3; }
        body.admin-theme .role-btn { background: linear-gradient(135deg, #d63031 0%, #e17055 100%); color: white; box-shadow: 0 4px 15px rgba(214, 48, 49, 0.4); }
        body.admin-theme .btn-primary { background: linear-gradient(135deg, #ff6b6b 0%, #e17055 100%); color: white; }
        body.admin-theme .btn-danger { background: linear-gradient(135deg, #6c5ce7 0%, #a29bfe 100%); color: white; }
        body.admin-theme .btn-secondary { background: #636e72; color: white; }
        body.admin-theme .game-card { background: #2d3436; box-shadow: 0 4px 15px rgba(0,0,0,0.3); }
        body.admin-theme .game-image { background: linear-gradient(135deg, #6c5ce7 0%, #a29bfe 100%); }
        body.admin-theme .game-name { color: #ff6b6b; }
        body.admin-theme .game-desc { color: #b2bec3; }
        body.admin-theme .game-price { color: #fdcb6e; }
        body.admin-theme .game-stock { color: #636e72; }
        body.admin-theme .filter-btn { border-color: #4a5568; color: #b2bec3; }
        body.admin-theme .filter-btn:hover, body.admin-theme .filter-btn.active { background: #ff6b6b; color: white; border-color: #ff6b6b; }
        body.admin-theme .modal { background: #2d3436; }
        body.admin-theme .modal h3 { color: #ff6b6b; }
        body.admin-theme .modal p { color: #b2bec3; }
        body.admin-theme .stats-card { background: linear-gradient(135deg, #2d3436 0%, #1a1a2e 100%); border-left: 4px solid #ff6b6b; }
        body.admin-theme .stats-number { color: #ff6b6b; }
        body.admin-theme .stats-label { color: #b2bec3; }

        /* 普通用户主题 */
        body.user-theme { background: linear-gradient(135deg, #0c2461 0%, #1e3799 50%, #0a3d62 100%); }
        body.user-theme .header { background: linear-gradient(135deg, #0c2461 0%, #1e3799 100%); border-bottom: 2px solid #00cec9; }
        body.user-theme .header h1 { color: #00cec9; }
        body.user-theme .user-info { color: #b2bec3; }
        body.user-theme .role-btn { background: linear-gradient(135deg, #0984e3 0%, #00cec9 100%); color: white; box-shadow: 0 4px 15px rgba(0, 206, 201, 0.4); }
        body.user-theme .btn-primary { background: linear-gradient(135deg, #00cec9 0%, #81ecec 100%); color: #1a1a2e; }
        body.user-theme .btn-danger { background: #d63031; color: white; }
        body.user-theme .btn-secondary { background: #636e72; color: white; }
        body.user-theme .game-card { background: rgba(255,255,255,0.1); backdrop-filter: blur(10px); box-shadow: 0 4px 20px rgba(0,0,0,0.2); }
        body.user-theme .game-image { background: linear-gradient(135deg, #00cec9 0%, #81ecec 100%); }
        body.user-theme .game-name { color: #00cec9; }
        body.user-theme .game-desc { color: #b2bec3; }
        body.user-theme .game-price { color: #fdcb6e; }
        body.user-theme .game-stock { color: #636e72; }
        body.user-theme .filter-btn { border-color: #00cec9; color: #00cec9; }
        body.user-theme .filter-btn:hover, body.user-theme .filter-btn.active { background: #00cec9; color: #1a1a2e; border-color: #00cec9; }
        body.user-theme .modal { background: rgba(255,255,255,0.1); backdrop-filter: blur(10px); }
        body.user-theme .modal h3 { color: #00cec9; }
        body.user-theme .modal p { color: #b2bec3; }
        body.user-theme .cart-badge { background: #ff6b6b; color: white; border-radius: 50%; padding: 2px 8px; font-size: 12px; margin-left: -8px; margin-top: -8px; position: absolute; }
       body.user-theme .featured-section { background: rgba(255,255,255,0.05); border-radius: 12px; padding: 20px; margin-bottom: 25px; }
        body.user-theme .featured-title { color: #00cec9; font-size: 20px; font-weight: bold; margin-bottom: 20px; }
        
        /* 横幅轮播图样式 */
        .banner-carousel {
            position: relative;
            width: 100%;
            height: 320px;
            border-radius: 16px;
            overflow: hidden;
            margin-bottom: 25px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.3);
        }
        
        .banner-track {
            display: flex;
            transition: transform 0.5s ease;
            height: 100%;
        }
        
        .banner-item {
            min-width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 40px 60px;
            position: relative;
        }
        
        .banner-content {
            flex: 1;
            color: white;
            z-index: 10;
        }
        
        .banner-tag {
            display: inline-block;
            background: rgba(255,255,255,0.2);
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 14px;
            margin-bottom: 15px;
            backdrop-filter: blur(10px);
        }
        
        .banner-title {
            font-size: 36px;
            font-weight: bold;
            margin-bottom: 12px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .banner-desc {
            font-size: 16px;
            margin-bottom: 15px;
            opacity: 0.9;
        }
        
        .banner-hint {
            font-size: 14px;
            opacity: 0.8;
            animation: pulse 1.5s infinite;
        }
        
        @keyframes pulse {
            0%, 100% { opacity: 0.6; }
            50% { opacity: 1; }
        }
        
        .banner-content {
            max-width: 400px;
            line-height: 1.6;
        }
        
        .banner-price {
            display: flex;
            align-items: baseline;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .price-label {
            font-size: 14px;
            opacity: 0.8;
        }
        
        .price-value {
            font-size: 48px;
            font-weight: bold;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .banner-btn {
            background: white;
            border: none;
            padding: 14px 32px;
            border-radius: 30px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        
        .banner-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.3);
        }
        
        .banner-image {
            width: 400px;
            height: 320px;
            position: relative;
            z-index: 10;
        }
        
        .banner-image img {
            width: 100%;
            height: 100%;
            object-fit: contain;
            filter: drop-shadow(0 10px 20px rgba(0,0,0,0.3));
        }
        
        .image-placeholder {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
        }
        
        .image-placeholder span {
            color: white;
            font-size: 14px;
            text-align: center;
            padding: 10px;
        }
        
        .banner-indicators {
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            gap: 12px;
            z-index: 20;
        }
        
        .banner-indicator {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            border: 2px solid rgba(255,255,255,0.5);
            background: transparent;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .banner-indicator.active {
            background: white;
            transform: scale(1.2);
        }15px; }

        .header { padding: 60px 100px !important; box-shadow: 0 2px 10px rgba(0,0,0,0.3); overflow: hidden; width: 100%; min-height: 120px !important; }
        .header h1 { margin: 0; font-size: 26px; float: left; line-height: 30px; }
        .user-info { float: right; display: flex; align-items: center; gap: 15px; flex-wrap: wrap; }
        .role-btn { padding: 10px 24px; border-radius: 20px; font-size: 14px; font-weight: bold; cursor: pointer; transition: all 0.3s; border: none; }
        .role-btn:hover { opacity: 0.8; transform: scale(1.05); }
        .stats-section { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stats-card-link { text-decoration: none; color: inherit; display: block; }
        .stats-card { padding: 20px; border-radius: 12px; text-align: center; cursor: pointer; transition: all 0.3s; }
        .stats-card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.3); }
        .stats-number { font-size: 32px; font-weight: bold; }
        .stats-label { font-size: 14px; margin-top: 5px; }
        .cart-icon { position: relative; }
        .cart-badge { position: absolute; top: -8px; right: -8px; background: #e74c3c; color: white; font-size: 12px; font-weight: bold; min-width: 20px; height: 20px; border-radius: 50%; display: flex; align-items: center; justify-content: center; padding: 0 5px; }
    </style>
</head>
<body class="${user.role == 1 ? 'admin-theme' : 'user-theme'}">
    <div class="header" style="padding: 0 80px !important; min-height: 120px !important; box-shadow: 0 2px 10px rgba(0,0,0,0.3); overflow: hidden; width: 100%; display: flex !important; align-items: center !important; justify-content: space-between !important;">
        <h1 style="margin: 0; font-size: 26px;">🎮 游戏商城</h1>
        <div class="user-info" style="display: flex; align-items: center; gap: 15px; flex-wrap: wrap;">
            <div style="width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; font-size: 16px; overflow: hidden;">
                <c:if test="${user.avatar != null && user.avatar != ''}">
                    <img src="${pageContext.request.contextPath}${user.avatar}" alt="头像" style="width: 100%; height: 100%; object-fit: cover;">
                </c:if>
                <c:if test="${user.avatar == null || user.avatar == ''}">
                    ${user.username.substring(0, 1).toUpperCase()}
                </c:if>
            </div>
            <span>欢迎, ${user.username}</span>
            <span class="role-btn">
                ${user.role == 1 ? '👑 管理员' : '👤 普通用户'}
            </span>
            <c:if test="${user.role == 1}">
                <a href="${pageContext.request.contextPath}/order/admin/list" class="btn btn-secondary">📋 订单管理</a>
                <a href="${pageContext.request.contextPath}/user/admin/list" class="btn btn-secondary">👥 用户管理</a>
                <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-secondary">⚙️ 设置</a>
            </c:if>
            <c:if test="${user.role == 0}">
                <div class="cart-icon">
                    <a href="${pageContext.request.contextPath}/cart/list" class="btn btn-secondary">🛒 购物车</a>
                    <span class="cart-badge">${cartCount != null ? cartCount : 0}</span>
                </div>
                <a href="${pageContext.request.contextPath}/order/list" class="btn btn-secondary">📋 我的订单</a>
                <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-secondary">⚙️ 设置</a>
            </c:if>
            <a href="${pageContext.request.contextPath}/user/login" class="btn btn-primary">切换账号</a>
            <a href="${pageContext.request.contextPath}/user/logout" class="btn btn-danger">退出登录</a>
        </div>
    </div>
    
    <div class="container">
        <%-- 管理员统计面板 --%>
        <c:if test="${user.role == 1}">
            <div class="stats-section">
                <a href="${pageContext.request.contextPath}/user/admin/list" class="stats-card-link">
                    <div class="stats-card">
                        <div class="stats-number">${stats != null ? stats.userCount : 0}</div>
                        <div class="stats-label">总用户数</div>
                    </div>
                </a>
                <a href="${pageContext.request.contextPath}/order/admin/list" class="stats-card-link">
                    <div class="stats-card">
                        <div class="stats-number">${stats != null ? stats.orderCount : 0}</div>
                        <div class="stats-label">总订单数</div>
                    </div>
                </a>
                <a href="${pageContext.request.contextPath}/game/list" class="stats-card-link">
                    <div class="stats-card">
                        <div class="stats-number">${stats != null ? stats.gameCount : 0}</div>
                        <div class="stats-label">游戏数量</div>
                    </div>
                </a>
                <a href="${pageContext.request.contextPath}/order/admin/pending" class="stats-card-link">
                    <div class="stats-card">
                        <div class="stats-number">${stats != null ? stats.pendingOrders : 0}</div>
                        <div class="stats-label">待发货订单</div>
                    </div>
                </a>
            </div>
        </c:if>

        <%-- 普通用户推荐区域 --%>
        <c:if test="${user.role == 0}">
            <div class="banner-carousel">
                <div class="banner-track" id="bannerTrack">
                    <c:forEach items="${featuredGames}" var="game" varStatus="status">
                        <div class="banner-item" style="background: linear-gradient(135deg, ${status.index % 3 == 0 ? '#ff6b6b' : status.index % 3 == 1 ? '#6c5ce7' : '#00cec9'} 0%, ${status.index % 3 == 0 ? '#ee5a24' : status.index % 3 == 1 ? '#a29bfe' : '#81ecec'} 100%); cursor: pointer;" onclick="scrollToGameCard('${game.name}')">
                            <div class="banner-content">
                                <div class="banner-tag">🎮 热门游戏推荐</div>
                                <h2 class="banner-title">${game.name}</h2>
                                <p class="banner-desc">${game.description}</p>
                                <div class="banner-hint">👆 点击查看游戏详情</div>
                            </div>
                            <div class="banner-image">
                                <img src="${game.image}" alt="${game.name}" onError="this.style.display='none'; this.parentElement.innerHTML='<div class=image-placeholder><span>${game.name}</span></div>'">
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <div class="banner-indicators" id="bannerIndicators">
                    <c:forEach items="${featuredGames}" var="game" varStatus="status">
                        <button class="banner-indicator" onclick="goToBannerSlide(${status.index})" ${status.index == 0 ? 'class=banner-indicator active' : 'class=banner-indicator'}></button>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 15px;">
            <div class="category-filter">
                <button class="filter-btn ${empty param.category ? 'active' : ''}" onclick="location.href='${pageContext.request.contextPath}/game/list'">全部游戏</button>
                <c:forEach items="${categories}" var="category">
                    <button class="filter-btn ${param.category == category.id ? 'active' : ''}" onclick="location.href='${pageContext.request.contextPath}/game/list?category=${category.id}'">${category.name}</button>
                </c:forEach>
            </div>
            <div style="display: flex; gap: 10px; align-items: center;">
                <c:if test="${user.role == 1}">
                    <a href="${pageContext.request.contextPath}/game/add" class="btn btn-primary">➕ 添加游戏</a>
                    <a href="${pageContext.request.contextPath}/category/list" class="btn btn-secondary">📁 分类管理</a>
                </c:if>
                <form action="${pageContext.request.contextPath}/game/list" method="get" style="display: flex; gap: 5px;">
                    <input type="hidden" name="category" value="${param.category}">
                    <input type="text" name="keyword" placeholder="搜索游戏名称..." value="${param.keyword}" 
                           style="padding: 8px 12px; border: 1px solid; border-radius: 6px; background: rgba(0,0,0,0.3); color: #b2bec3; outline: none; min-width: 200px;">
                    <button type="submit" class="btn btn-primary" style="padding: 8px 16px;">搜索</button>
                </form>
            </div>
        </div>
        
        <div class="game-grid">
            <c:forEach items="${games}" var="game">
                <div class="game-card" id="game-card-${game.name.replaceAll('\\s+', '-')}">
                    <div class="game-image" data-name="${game.name}">
                        <img src="${game.image}" alt="${game.name}" onload="this.style.display='block';" onError="handleImageError(this)">
                    </div>
                    <div class="game-info">
                        <div class="game-name">${game.name}</div>
                        <div class="game-desc">${game.description}</div>
                        <div class="game-meta">
                            <span class="game-price">¥${game.price}</span>
                            <span class="game-stock">库存: ${game.stock}</span>
                        </div>
                        <c:if test="${user.role == 1}">
                            <div class="game-actions">
                                <a href="${pageContext.request.contextPath}/game/edit?id=${game.id}" class="btn btn-primary" style="flex:1;">✏️ 编辑</a>
                                <button class="btn btn-danger" style="flex:1;" onclick="showDeleteModal(${game.id}, '${game.name}')">🗑️ 删除</button>
                            </div>
                        </c:if>
                        <c:if test="${user.role == 0}">
                            <div class="game-actions">
                                <button class="btn btn-primary" style="flex:1;" onclick="addToCart(${game.id})">🛒 加入购物车</button>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
        
        <c:if test="${empty games}">
            <div style="text-align: center; color: #636e72; padding: 50px;">暂无游戏数据</div>
        </c:if>
    </div>
    
    <div class="modal-overlay" id="deleteModal">
        <div class="modal">
            <h3 style="color: #ff6b6b;">🗑️ 删除游戏</h3>
            <p id="deleteMessage"></p>
            <div class="modal-actions">
                <button class="btn btn-danger" onclick="confirmDelete()">确认删除</button>
                <button class="btn btn-secondary" onclick="closeDeleteModal()">取消</button>
            </div>
        </div>
    </div>
    
    <script>
        var deleteGameId = 0;
        var deleteGameName = '';
        
        // 横幅轮播图相关
        var currentBannerSlide = 0;
        var bannerSlideInterval;
        
        function initBannerCarousel() {
            var track = document.getElementById('bannerTrack');
            if (!track) return;
            
            var items = track.querySelectorAll('.banner-item');
            if (items.length === 0) return;
            
            startBannerAutoPlay();
        }
        
        function startBannerAutoPlay() {
            bannerSlideInterval = setInterval(nextBannerSlide, 5000);
        }
        
        function stopBannerAutoPlay() {
            if (bannerSlideInterval) {
                clearInterval(bannerSlideInterval);
            }
        }
        
        function nextBannerSlide() {
            var track = document.getElementById('bannerTrack');
            var items = track.querySelectorAll('.banner-item');
            if (items.length === 0) return;
            
            currentBannerSlide = (currentBannerSlide + 1) % items.length;
            updateBannerCarousel();
        }
        
        function goToBannerSlide(index) {
            stopBannerAutoPlay();
            currentBannerSlide = index;
            updateBannerCarousel();
            startBannerAutoPlay();
        }
        
        function updateBannerCarousel() {
            var track = document.getElementById('bannerTrack');
            var items = track.querySelectorAll('.banner-item');
            var indicators = document.querySelectorAll('.banner-indicator');
            
            if (items.length === 0) return;
            
            var slideWidth = items[0].offsetWidth;
            track.style.transform = 'translateX(-' + currentBannerSlide * slideWidth + 'px)';
            
            indicators.forEach(function(indicator, index) {
                indicator.classList.remove('active');
                if (index === currentBannerSlide) {
                    indicator.classList.add('active');
                }
            });
        }
        
        function showDeleteModal(gameId, gameName) {
            deleteGameId = gameId;
            deleteGameName = gameName;
            document.getElementById('deleteMessage').innerHTML = '确定要删除游戏 <strong style="color: #ff6b6b;">' + gameName + '</strong> 吗？<br/><br/><span style="color: #636e72; font-size: 14px;">此操作无法撤销，请谨慎操作。</span>';
            document.getElementById('deleteModal').classList.add('show');
        }
        
        function closeDeleteModal() {
            document.getElementById('deleteModal').classList.remove('show');
        }
        
        function confirmDelete() {
            closeDeleteModal();
            window.location.href = '${pageContext.request.contextPath}/game/delete?id=' + deleteGameId;
        }
        
        function addToCart(gameId) {
            window.location.href = '${pageContext.request.contextPath}/cart/add?gameId=' + gameId;
        }
        
        function scrollToGameCard(gameName) {
            var cardId = 'game-card-' + gameName.replace(/\s+/g, '-');
            var card = document.getElementById(cardId);
            if (card) {
                card.scrollIntoView({ behavior: 'smooth', block: 'center' });
                card.style.boxShadow = '0 0 20px rgba(0, 206, 201, 0.6)';
                setTimeout(function() {
                    card.style.boxShadow = '';
                }, 2000);
            }
        }
        
        function handleImageError(img) {
            var container = img.parentElement;
            var gameName = container.getAttribute('data-name');
            img.style.display = 'none';
            container.innerHTML = '<span style="font-size: 14px; text-align: center; padding: 10px;">' + gameName + '</span>';
        }
        
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeDeleteModal();
            }
        });
        
        document.addEventListener('DOMContentLoaded', function() {
            initBannerCarousel();
        });
    </script>
</body>
</html>