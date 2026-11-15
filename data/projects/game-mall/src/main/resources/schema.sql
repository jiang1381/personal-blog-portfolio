USE mall_db;

CREATE TABLE IF NOT EXISTS user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    role INT NOT NULL DEFAULT 0,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS game_category (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(200),
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS game (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    category_id INT,
    image VARCHAR(500),
    stock INT NOT NULL DEFAULT 0,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_name (name),
    INDEX idx_category_id (category_id),
    FOREIGN KEY (category_id) REFERENCES game_category(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO user (username, password, email, phone, role, create_time) VALUES
('admin', 'admin', 'admin@example.com', '13800138000', 1, NOW()),
('user1', '123456', 'user1@example.com', '13900139000', 0, NOW());

INSERT INTO game_category (name, description, create_time) VALUES
('RPG', 'Role Playing Games', NOW()),
('Action', 'Action and Shooting Games', NOW()),
('Strategy', 'Strategy and War Games', NOW()),
('Casual', 'Casual and Puzzle Games', NOW());

INSERT INTO game (name, description, price, category_id, image, stock, create_time) VALUES
('World of Warcraft', 'Classic MMORPG', 199.00, 1, 'https://img0.baidu.com/it/u=3660540222,3265070749&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', 100, NOW()),
('League of Legends', 'MOBA Game', 0.00, 1, 'https://img2.baidu.com/it/u=3303838999,3874872769&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', 999, NOW()),
('CS2', 'First Person Shooter', 149.00, 2, 'https://img2.baidu.com/it/u=1642856738,1827677562&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', 200, NOW()),
('DOTA2', 'MOBA Game', 0.00, 1, 'https://img0.baidu.com/it/u=3155469318,267719494&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', 999, NOW()),
('Civilization VI', 'Turn-based Strategy', 199.00, 3, 'https://img2.baidu.com/it/u=3723978888,1853455548&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', 150, NOW()),
('Stardew Valley', 'Casual Farm Simulation', 48.00, 4, 'https://img0.baidu.com/it/u=2430657140,1976473617&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', 300, NOW()),
('The Legend of Zelda', 'Action Adventure RPG', 299.00, 1, 'https://img1.baidu.com/it/u=1234567890,1234567890&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', 80, NOW()),
('Cyberpunk 2077', 'Open World RPG', 298.00, 1, 'https://img2.baidu.com/it/u=2345678901,2345678901&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', 120, NOW()),
('Elden Ring', 'Action RPG', 298.00, 1, 'https://img0.baidu.com/it/u=3456789012,3456789012&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', 150, NOW()),
('Halo Infinite', 'First Person Shooter', 199.00, 2, 'https://img1.baidu.com/it/u=4567890123,4567890123&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', 200, NOW()),
('Call of Duty', 'First Person Shooter', 199.00, 2, 'https://img2.baidu.com/it/u=5678901234,5678901234&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', 180, NOW()),
('Battlefield 2042', 'First Person Shooter', 248.00, 2, 'https://img0.baidu.com/it/u=6789012345,6789012345&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', 100, NOW()),
('Age of Empires IV', 'Real-time Strategy', 199.00, 3, 'https://img1.baidu.com/it/u=7890123456,7890123456&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', 160, NOW()),
('Total War: Warhammer III', 'Strategy Game', 299.00, 3, 'https://img2.baidu.com/it/u=8901234567,8901234567&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', 90, NOW()),
('PUBG', 'Battle Royale', 98.00, 2, 'https://img0.baidu.com/it/u=9012345678,9012345678&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', 500, NOW()),
('Among Us', 'Casual Party Game', 6.00, 4, 'https://img1.baidu.com/it/u=1122334455,1122334455&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', 999, NOW()),
('Minecraft', 'Sandbox Game', 165.00, 4, 'https://img2.baidu.com/it/u=2233445566,2233445566&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', 800, NOW()),
('Terraria', '2D Adventure', 36.00, 4, 'https://img0.baidu.com/it/u=3344556677,3344556677&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', 400, NOW()),
('GTA V', 'Open World Action', 159.00, 2, 'https://img1.baidu.com/it/u=4455667788,4455667788&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', 300, NOW()),
('Red Dead Redemption 2', 'Open World Adventure', 199.00, 1, 'https://img2.baidu.com/it/u=5566778899,5566778899&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500', 250, NOW());

CREATE TABLE IF NOT EXISTS cart_item (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    game_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_game_id (game_id),
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY (game_id) REFERENCES game(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_no VARCHAR(50) NOT NULL UNIQUE,
    user_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    status INT NOT NULL DEFAULT 0,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_order_no (order_no),
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS order_item (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    game_id INT NOT NULL,
    game_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    quantity INT NOT NULL DEFAULT 1,
    image VARCHAR(500),
    INDEX idx_order_id (order_id),
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (game_id) REFERENCES game(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;