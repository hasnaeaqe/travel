-- Morocco Travels Database Schema

-- Drop tables if they exist to avoid conflicts
DROP TABLE IF EXISTS hotel_bookings;
DROP TABLE IF EXISTS flight_bookings;
DROP TABLE IF EXISTS train_bookings;
DROP TABLE IF EXISTS user_favorites;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS hotels;
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS trains;
DROP TABLE IF EXISTS destinations;
DROP TABLE IF EXISTS password_resets;
DROP TABLE IF EXISTS user_tokens;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS settings;

-- Create database
CREATE DATABASE IF NOT EXISTS morocco_travels_db;
USE morocco_travels_db;

-- Set character set
ALTER DATABASE morocco_travels_db CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Create Users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    role ENUM('user', 'admin') DEFAULT 'user',
    profile_image VARCHAR(255),
    activation_token VARCHAR(255),
    activation_expires DATETIME,
    is_active TINYINT(1) DEFAULT 0,
    remember_token VARCHAR(255),
    token_expires DATETIME,
    last_login DATETIME,
    created_at DATETIME NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Destinations table
CREATE TABLE destinations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    name_ar VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    description_ar TEXT,
    short_description VARCHAR(255),
    short_description_ar VARCHAR(255),
    featured_image VARCHAR(255),
    gallery TEXT,
    location VARCHAR(100),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    category VARCHAR(50),
    rating DECIMAL(3, 2),
    rating_count INT DEFAULT 0,
    is_featured TINYINT(1) DEFAULT 0,
    meta_title VARCHAR(255),
    meta_description TEXT,
    created_at DATETIME NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Hotels table
CREATE TABLE hotels (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    name_ar VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    description_ar TEXT,
    short_description VARCHAR(255),
    short_description_ar VARCHAR(255),
    address TEXT,
    address_ar TEXT,
    destination_id INT,
    star_rating INT NOT NULL,
    price_range VARCHAR(50),
    featured_image VARCHAR(255),
    gallery TEXT,
    amenities TEXT,
    check_in_time TIME,
    check_out_time TIME,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    is_featured TINYINT(1) DEFAULT 0,
    availability TINYINT(1) DEFAULT 1,
    created_at DATETIME NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (destination_id) REFERENCES destinations(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Rooms table
CREATE TABLE rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hotel_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    name_ar VARCHAR(100) NOT NULL,
    description TEXT,
    description_ar TEXT,
    max_adults INT NOT NULL,
    max_children INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    discount_price DECIMAL(10, 2),
    size INT,
    view VARCHAR(50),
    bed_type VARCHAR(50),
    featured_image VARCHAR(255),
    gallery TEXT,
    amenities TEXT,
    availability TINYINT(1) DEFAULT 1,
    created_at DATETIME NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Flights table
CREATE TABLE flights (
    id INT AUTO_INCREMENT PRIMARY KEY,
    flight_number VARCHAR(20) NOT NULL,
    airline VARCHAR(100) NOT NULL,
    airline_ar VARCHAR(100) NOT NULL,
    departure_city VARCHAR(100) NOT NULL,
    departure_city_ar VARCHAR(100) NOT NULL,
    arrival_city VARCHAR(100) NOT NULL,
    arrival_city_ar VARCHAR(100) NOT NULL,
    departure_airport VARCHAR(100) NOT NULL,
    departure_airport_ar VARCHAR(100) NOT NULL,
    arrival_airport VARCHAR(100) NOT NULL,
    arrival_airport_ar VARCHAR(100) NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    duration INT NOT NULL, -- in minutes
    economy_price DECIMAL(10, 2) NOT NULL,
    business_price DECIMAL(10, 2) NOT NULL,
    first_class_price DECIMAL(10, 2),
    available_seats INT NOT NULL,
    aircraft_type VARCHAR(50),
    is_featured TINYINT(1) DEFAULT 0,
    status ENUM('scheduled', 'on-time', 'delayed', 'cancelled') DEFAULT 'scheduled',
    created_at DATETIME NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Trains table
CREATE TABLE trains (
    id INT AUTO_INCREMENT PRIMARY KEY,
    train_number VARCHAR(20) NOT NULL,
    departure_station VARCHAR(100) NOT NULL,
    departure_station_ar VARCHAR(100) NOT NULL,
    arrival_station VARCHAR(100) NOT NULL,
    arrival_station_ar VARCHAR(100) NOT NULL,
    departure_city VARCHAR(100) NOT NULL,
    departure_city_ar VARCHAR(100) NOT NULL,
    arrival_city VARCHAR(100) NOT NULL,
    arrival_city_ar VARCHAR(100) NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    duration INT NOT NULL, -- in minutes
    first_class_price DECIMAL(10, 2) NOT NULL,
    second_class_price DECIMAL(10, 2) NOT NULL,
    available_seats INT NOT NULL,
    train_type VARCHAR(50),
    is_featured TINYINT(1) DEFAULT 0,
    status ENUM('scheduled', 'on-time', 'delayed', 'cancelled') DEFAULT 'scheduled',
    created_at DATETIME NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Reviews table
CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    item_id INT NOT NULL,
    item_type ENUM('hotel', 'destination', 'flight', 'train') NOT NULL,
    rating INT NOT NULL,
    title VARCHAR(255),
    content TEXT,
    is_approved TINYINT(1) DEFAULT 0,
    created_at DATETIME NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Hotel Bookings table
CREATE TABLE hotel_bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    hotel_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    guests_adults INT NOT NULL,
    guests_children INT NOT NULL,
    total_nights INT NOT NULL,
    price_per_night DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    special_requests TEXT,
    booking_status ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
    payment_status ENUM('pending', 'paid', 'refunded') DEFAULT 'pending',
    booking_reference VARCHAR(20) NOT NULL UNIQUE,
    created_at DATETIME NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Flight Bookings table
CREATE TABLE flight_bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    flight_id INT NOT NULL,
    booking_date DATE NOT NULL,
    number_of_passengers INT NOT NULL,
    passenger_details TEXT NOT NULL, -- JSON with names, passport numbers, etc.
    class ENUM('economy', 'business', 'first') NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    booking_status ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
    payment_status ENUM('pending', 'paid', 'refunded') DEFAULT 'pending',
    booking_reference VARCHAR(20) NOT NULL UNIQUE,
    created_at DATETIME NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (flight_id) REFERENCES flights(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Train Bookings table
CREATE TABLE train_bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    train_id INT NOT NULL,
    booking_date DATE NOT NULL,
    number_of_passengers INT NOT NULL,
    passenger_details TEXT NOT NULL, -- JSON with names, identification numbers, etc.
    class ENUM('first', 'second') NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    booking_status ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
    payment_status ENUM('pending', 'paid', 'refunded') DEFAULT 'pending',
    booking_reference VARCHAR(20) NOT NULL UNIQUE,
    created_at DATETIME NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (train_id) REFERENCES trains(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create User Favorites table
CREATE TABLE user_favorites (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    item_id INT NOT NULL,
    item_type ENUM('hotel', 'destination', 'flight', 'train') NOT NULL,
    created_at DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY (user_id, item_id, item_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Password Resets table
CREATE TABLE password_resets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL,
    token VARCHAR(255) NOT NULL,
    expires_at DATETIME NOT NULL,
    created_at DATETIME NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create Settings table
CREATE TABLE settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(100) NOT NULL UNIQUE,
    setting_value TEXT,
    setting_group VARCHAR(50) DEFAULT 'general',
    is_public TINYINT(1) DEFAULT 1,
    created_at DATETIME NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default admin user
INSERT INTO users (first_name, last_name, email, phone, password, role, is_active, created_at)
VALUES ('Admin', 'User', 'admin@morocco-travels.ma', '+212600000000', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 1, NOW());

-- Insert some settings
INSERT INTO settings (setting_key, setting_value, setting_group, created_at) VALUES
('site_name', 'أسفار المغرب', 'general', NOW()),
('site_email', 'info@morocco-travels.ma', 'general', NOW()),
('site_phone', '+212500000000', 'general', NOW()),
('site_address', 'شارع محمد الخامس، الرباط، المغرب', 'general', NOW()),
('currency', 'MAD', 'payment', NOW()),
('currency_symbol', 'د.م.', 'payment', NOW()),
('enable_reviews', '1', 'general', NOW()),
('booking_fee_percentage', '5', 'payment', NOW());

-- Insert sample destinations
INSERT INTO destinations (name, name_ar, slug, description, description_ar, short_description, short_description_ar, featured_image, location, latitude, longitude, category, rating, is_featured, created_at) VALUES
('Marrakech', 'مراكش', 'marrakech', 'Marrakech, known as the Red City, is a major city in Morocco. Famous for its medina, gardens, and vibrant souks.', 'مراكش، المعروفة باسم المدينة الحمراء، هي مدينة رئيسية في المغرب. تشتهر بمدينتها القديمة وحدائقها وأسواقها النابضة بالحياة.', 'Discover the magic of Marrakech with its historic sites and colorful markets', 'اكتشف سحر مراكش بمواقعها التاريخية وأسواقها الملونة', 'https://images.pexels.com/photos/3889843/pexels-photo-3889843.jpeg', 'Marrakech-Safi', 31.6295, -7.9811, 'city', 4.8, 1, NOW()),
('Chefchaouen', 'شفشاون', 'chefchaouen', 'Chefchaouen is a city in northwest Morocco. It is known for its blue-painted buildings in its old town (medina).', 'شفشاون هي مدينة في شمال غرب المغرب. تشتهر بمبانيها المطلية باللون الأزرق في مدينتها القديمة.', 'Explore the blue pearl of Morocco nestled in the Rif Mountains', 'استكشف اللؤلؤة الزرقاء للمغرب المتربعة في جبال الريف', 'https://images.pexels.com/photos/2404046/pexels-photo-2404046.jpeg', 'Tangier-Tetouan-Al Hoceima', 35.1687, -5.2694, 'city', 4.7, 1, NOW()),
('Sahara Desert', 'الصحراء الكبرى', 'sahara-desert', 'The Sahara is the largest hot desert in the world. In Morocco, you can experience camel trekking, stargazing, and traditional Berber camps.', 'الصحراء الكبرى هي أكبر صحراء حارة في العالم. في المغرب، يمكنك تجربة ركوب الجمال ومراقبة النجوم والمخيمات البربرية التقليدية.', 'Experience the magic of the desert with camel rides and camping under the stars', 'عش سحر الصحراء مع ركوب الجمال والتخييم تحت النجوم', 'https://images.pexels.com/photos/3889753/pexels-photo-3889753.jpeg', 'Drâa-Tafilalet', 31.0076, -4.5277, 'natural', 4.9, 1, NOW()),
('Fes', 'فاس', 'fes', 'Fes is the oldest imperial city in Morocco, known for its walled medina, vibrant tanneries, and ancient madrasas.', 'فاس هي أقدم مدينة إمبراطورية في المغرب، وتشتهر بمدينتها المسورة، ودباغاتها النابضة بالحياة، ومدارسها القديمة.', 'Step back in time in one of the oldest and largest medieval cities in the world', 'عد بالزمن إلى الوراء في واحدة من أقدم وأكبر المدن القروسطية في العالم', 'https://images.pexels.com/photos/2404368/pexels-photo-2404368.jpeg', 'Fès-Meknès', 34.0181, -5.0078, 'city', 4.6, 1, NOW());

-- Insert sample hotels
INSERT INTO hotels (name, name_ar, slug, description, description_ar, short_description, short_description_ar, address, address_ar, destination_id, star_rating, price_range, featured_image, amenities, check_in_time, check_out_time, latitude, longitude, is_featured, created_at) VALUES
('La Mamounia', 'لا مامونية', 'la-mamounia', 'La Mamounia is a luxury hotel located in Marrakech, Morocco. Set in royal gardens, this 5-star hotel offers elegant rooms, multiple restaurants, and a spa.', 'لا مامونية هو فندق فاخر يقع في مراكش، المغرب. يقع هذا الفندق ذو الخمس نجوم في حدائق ملكية ويوفر غرفًا أنيقة ومطاعم متعددة ومنتجع صحي.', 'Experience luxury and tradition in the heart of Marrakech', 'استمتع بالفخامة والتقاليد في قلب مراكش', 'Avenue Bab Jdid, Marrakech 40040, Morocco', 'شارع باب جديد، مراكش 40040، المغرب', 1, 5, '2000-3000', 'https://images.pexels.com/photos/2844474/pexels-photo-2844474.jpeg', 'Wi-Fi,Pool,Spa,Restaurant,Room Service,Airport Shuttle,Air Conditioning,Bar', '14:00:00', '12:00:00', 31.6294, -7.9936, 1, NOW()),
('Riad Dar Salam', 'رياض دار السلام', 'riad-dar-salam', 'Riad Dar Salam is a traditional Moroccan house converted into a hotel, located in the old medina of Fes. It features authentic architecture, a central courtyard, and a terrace with panoramic views.', 'رياض دار السلام هو منزل مغربي تقليدي تم تحويله إلى فندق، يقع في المدينة القديمة بفاس. يتميز بالهندسة المعمارية الأصيلة وفناء مركزي وشرفة مع إطلالات بانورامية.', 'Experience authentic Moroccan hospitality in a traditional riad', 'استمتع بالضيافة المغربية الأصيلة في رياض تقليدي', '23 Derb El Miter, Fes 30000, Morocco', '23 درب الميتر، فاس 30000، المغرب', 4, 4, '1500-2000', 'https://images.pexels.com/photos/2736522/pexels-photo-2736522.jpeg', 'Wi-Fi,Restaurant,Room Service,Airport Shuttle,Air Conditioning,Terrace,Breakfast Included', '14:00:00', '11:00:00', 34.0614, -4.9736, 1, NOW()),
('Hilton Tangier', 'هيلتون طنجة', 'hilton-tangier', 'Hilton Tangier is a modern hotel located in Tangier, Morocco. It offers contemporary rooms with sea views, restaurants, a fitness center, and a pool.', 'هيلتون طنجة هو فندق حديث يقع في طنجة، المغرب. يوفر غرفًا عصرية مع إطلالات على البحر ومطاعم ومركز للياقة البدنية وحوض سباحة.', 'Modern luxury with stunning views of the Mediterranean', 'فخامة عصرية مع إطلالات خلابة على البحر المتوسط', 'Route de Malabata, Tangier 90000, Morocco', 'طريق ملاباتا، طنجة 90000، المغرب', 2, 4, '1800-2500', 'https://images.pexels.com/photos/2034335/pexels-photo-2034335.jpeg', 'Wi-Fi,Pool,Gym,Restaurant,Room Service,Business Center,Air Conditioning,Bar,Free Parking', '15:00:00', '12:00:00', 35.7951, -5.8101, 1, NOW()),
('Desert Luxury Camp', 'مخيم الصحراء الفاخر', 'desert-luxury-camp', 'Desert Luxury Camp offers a unique glamping experience in the Sahara Desert. Luxurious tents with comfortable beds, en-suite bathrooms, and authentic Moroccan meals under the stars.', 'مخيم الصحراء الفاخر يقدم تجربة تخييم فاخرة في الصحراء الكبرى. خيام فاخرة مع أسرة مريحة وحمامات داخلية ووجبات مغربية أصيلة تحت النجوم.', 'Luxury camping experience in the heart of the Sahara Desert', 'تجربة تخييم فاخرة في قلب الصحراء الكبرى', 'Merzouga Desert, Errachidia, Morocco', 'صحراء مرزوكة، الرشيدية، المغرب', 3, 5, '2500-3500', 'https://images.pexels.com/photos/1268855/pexels-photo-1268855.jpeg', 'Private Bathroom,Guided Tours,Camel Rides,Stargazing,Traditional Music,Meals Included,Sunset/Sunrise Views', '14:00:00', '10:00:00', 31.1000, -4.0000, 1, NOW());

-- Insert sample rooms
INSERT INTO rooms (hotel_id, name, name_ar, description, description_ar, max_adults, max_children, price, discount_price, size, view, bed_type, featured_image, amenities, created_at) VALUES
(1, 'Deluxe Room', 'غرفة ديلوكس', 'Spacious deluxe room with traditional Moroccan decor, featuring a king-size bed, sitting area, and stunning garden views.', 'غرفة ديلوكس فسيحة مع ديكور مغربي تقليدي، تضم سرير كينج، ومنطقة جلوس، وإطلالات خلابة على الحديقة.', 2, 1, 2500.00, 2200.00, 45, 'Garden', 'King', 'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg', 'Air Conditioning,Wi-Fi,Flat-screen TV,Mini Bar,Safe,Bathroom Amenities,Hairdryer,Bathrobe,Slippers', NOW()),
(1, 'Royal Suite', 'جناح ملكي', 'Luxurious suite with separate living area, private terrace, and exclusive access to the spa. Features a king-size bed and opulent bathroom.', 'جناح فاخر مع منطقة معيشة منفصلة، وشرفة خاصة، ووصول حصري إلى المنتجع الصحي. يضم سرير كينج وحمام فخم.', 2, 2, 4500.00, 4000.00, 90, 'Garden and Pool', 'King', 'https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg', 'Air Conditioning,Wi-Fi,Flat-screen TV,Mini Bar,Safe,Bathroom Amenities,Hairdryer,Bathrobe,Slippers,Private Terrace,Living Area,Exclusive Spa Access', NOW()),
(2, 'Traditional Room', 'غرفة تقليدية', 'Charming room with authentic Moroccan design, featuring a queen-size bed and views of the central courtyard.', 'غرفة ساحرة بتصميم مغربي أصيل، تضم سرير كوين وإطلالات على الفناء المركزي.', 2, 1, 1800.00, 1600.00, 30, 'Courtyard', 'Queen', 'https://images.pexels.com/photos/1648776/pexels-photo-1648776.jpeg', 'Air Conditioning,Wi-Fi,Flat-screen TV,Safe,Bathroom Amenities,Hairdryer', NOW()),
(3, 'Sea View Room', 'غرفة بإطلالة على البحر', 'Modern room with contemporary furnishings and panoramic sea views. Features a king-size bed and spacious bathroom.', 'غرفة عصرية مع أثاث معاصر وإطلالات بانورامية على البحر. تضم سرير كينج وحمام فسيح.', 2, 1, 2200.00, 1950.00, 40, 'Sea', 'King', 'https://images.pexels.com/photos/97083/pexels-photo-97083.jpeg', 'Air Conditioning,Wi-Fi,Flat-screen TV,Mini Bar,Safe,Bathroom Amenities,Hairdryer,Coffee Maker', NOW()),
(4, 'Luxury Desert Tent', 'خيمة صحراوية فاخرة', 'Spacious luxury tent with hand-crafted furnishings, a king-size bed, private bathroom, and panoramic desert views.', 'خيمة فاخرة فسيحة مع أثاث مصنوع يدويًا، وسرير كينج، وحمام خاص، وإطلالات بانورامية على الصحراء.', 2, 2, 3000.00, 2700.00, 50, 'Desert', 'King', 'https://images.pexels.com/photos/2662183/pexels-photo-2662183.jpeg', 'Private Bathroom,Hot Water,Solar Lighting,Handcrafted Furniture,Traditional Rugs,Bedside Tables,Outdoor Seating Area', NOW());

-- Insert sample flights
INSERT INTO flights (flight_number, airline, airline_ar, departure_city, departure_city_ar, arrival_city, arrival_city_ar, departure_airport, departure_airport_ar, arrival_airport, arrival_airport_ar, departure_time, arrival_time, duration, economy_price, business_price, first_class_price, available_seats, aircraft_type, is_featured, created_at) VALUES
('AT202', 'Royal Air Maroc', 'الخطوط الملكية المغربية', 'Casablanca', 'الدار البيضاء', 'Marrakech', 'مراكش', 'Mohammed V International Airport', 'مطار محمد الخامس الدولي', 'Marrakech Menara Airport', 'مطار مراكش المنارة', '2025-01-15 08:00:00', '2025-01-15 08:45:00', 45, 800.00, 1500.00, 2500.00, 120, 'Boeing 737', 1, NOW()),
('AT305', 'Royal Air Maroc', 'الخطوط الملكية المغربية', 'Casablanca', 'الدار البيضاء', 'Fes', 'فاس', 'Mohammed V International Airport', 'مطار محمد الخامس الدولي', 'Fes-Saïs Airport', 'مطار فاس سايس', '2025-01-15 10:30:00', '2025-01-15 11:30:00', 60, 900.00, 1700.00, 2800.00, 100, 'Boeing 737', 0, NOW()),
('AT410', 'Royal Air Maroc', 'الخطوط الملكية المغربية', 'Casablanca', 'الدار البيضاء', 'Tangier', 'طنجة', 'Mohammed V International Airport', 'مطار محمد الخامس الدولي', 'Tangier Ibn Battouta Airport', 'مطار طنجة ابن بطوطة', '2025-01-15 14:00:00', '2025-01-15 15:00:00', 60, 850.00, 1600.00, 2600.00, 110, 'Airbus A320', 1, NOW()),
('AT127', 'Royal Air Maroc', 'الخطوط الملكية المغربية', 'Marrakech', 'مراكش', 'Casablanca', 'الدار البيضاء', 'Marrakech Menara Airport', 'مطار مراكش المنارة', 'Mohammed V International Airport', 'مطار محمد الخامس الدولي', '2025-01-15 17:30:00', '2025-01-15 18:15:00', 45, 800.00, 1500.00, 2500.00, 120, 'Boeing 737', 0, NOW());

-- Insert sample trains
INSERT INTO trains (train_number, departure_station, departure_station_ar, arrival_station, arrival_station_ar, departure_city, departure_city_ar, arrival_city, arrival_city_ar, departure_time, arrival_time, duration, first_class_price, second_class_price, available_seats, train_type, is_featured, created_at) VALUES
('AL1', 'Casablanca Voyageurs', 'الدار البيضاء المسافرون', 'Rabat Ville', 'الرباط المدينة', 'Casablanca', 'الدار البيضاء', 'Rabat', 'الرباط', '2025-01-15 09:00:00', '2025-01-15 10:00:00', 60, 150.00, 90.00, 200, 'Al Boraq', 1, NOW()),
('AL2', 'Rabat Ville', 'الرباط المدينة', 'Tangier Ville', 'طنجة المدينة', 'Rabat', 'الرباط', 'Tangier', 'طنجة', '2025-01-15 10:30:00', '2025-01-15 11:30:00', 60, 200.00, 120.00, 180, 'Al Boraq', 1, NOW()),
('AL3', 'Tangier Ville', 'طنجة المدينة', 'Rabat Ville', 'الرباط المدينة', 'Tangier', 'طنجة', 'Rabat', 'الرباط', '2025-01-15 12:00:00', '2025-01-15 13:00:00', 60, 200.00, 120.00, 180, 'Al Boraq', 0, NOW()),
('AL4', 'Rabat Ville', 'الرباط المدينة', 'Casablanca Voyageurs', 'الدار البيضاء المسافرون', 'Rabat', 'الرباط', 'Casablanca', 'الدار البيضاء', '2025-01-15 13:30:00', '2025-01-15 14:30:00', 60, 150.00, 90.00, 200, 'Al Boraq', 0, NOW());