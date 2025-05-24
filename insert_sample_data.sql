-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema littlelemondb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `littlelemondb` DEFAULT CHARACTER SET utf8 ;
USE `littlelemondb` ;

-- -----------------------------------------------------
-- Table `littlelemondb`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`Customers` (
  `CustomerID` INT NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(100) NOT NULL,
  `LastName` VARCHAR(100) NOT NULL,
  `PhoneNumber` VARCHAR(20) NULL,
  `Email` VARCHAR(255) NULL,
  `Address` TEXT NULL,
  PRIMARY KEY (`CustomerID`),
  UNIQUE INDEX `PhoneNumber_UNIQUE` (`PhoneNumber` ASC) VISIBLE,
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `littlelemondb`.`Staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`Staff` (
  `StaffID` INT NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(100) NOT NULL,
  `LastName` VARCHAR(100) NOT NULL,
  `Role` VARCHAR(100) NOT NULL,
  `Salary` DECIMAL(10,2) NULL,
  `PhoneNumber` VARCHAR(20) NULL,
  `Staffcol` VARCHAR(45) NULL,
  `HireDate` DATE NULL,
  `IsActive` TINYINT NULL DEFAULT 1,
  PRIMARY KEY (`StaffID`),
  UNIQUE INDEX `PhoneNumber_UNIQUE` (`PhoneNumber` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `littlelemondb`.`Menu_Items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`Menu_Items` (
  `MenuItemID` INT NOT NULL AUTO_INCREMENT,
  `ItemName` VARCHAR(255) NOT NULL,
  `Description` LONGTEXT NULL,
  `Price` DECIMAL(10,2) NOT NULL,
  `Category` VARCHAR(100) NULL,
  `Subcategory` VARCHAR(100) NULL, -- Renamed Subategory to Subcategory
  `IsAvailable` TINYINT(1) NULL DEFAULT 1,
  -- `Menu_Itemscol` TINYINT NULL, -- Removed Menu_Itemscol
  `PrepTimeMinutes` INT NULL,
  PRIMARY KEY (`MenuItemID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `littlelemondb`.`Bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`Bookings` (
  `BookingID` INT NOT NULL AUTO_INCREMENT,
  `CustomerID` INT NULL,
  `StaffID` INT NULL,
  `BookingDateTime` TIMESTAMP NULL,
  `TableNumber` INT NOT NULL,
  `NumberOfGuests` INT NOT NULL,
  `Status` VARCHAR(50) NULL DEFAULT 'Confirmed',
  `Notes` TEXT NULL,
  PRIMARY KEY (`BookingID`),
  INDEX `bookings_customer_fk_idx` (`CustomerID` ASC) VISIBLE,
  INDEX `bookings_staff_fk_idx` (`StaffID` ASC) VISIBLE,
  CONSTRAINT `bookings_customer_fk`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `littlelemondb`.`Customers` (`CustomerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `bookings_staff_fk`
    FOREIGN KEY (`StaffID`)
    REFERENCES `littlelemondb`.`Staff` (`StaffID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `littlelemondb`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`Orders` (
  `OrderID` INT NOT NULL AUTO_INCREMENT,
  `CustomerID` INT NOT NULL,
  `BookingID` INT NOT NULL,
  `StaffID` INT NOT NULL,
  `OrderType` VARCHAR(50) NOT NULL,
  `TotalAmount` DECIMAL(10,2) NOT NULL,
  `OrderDateTime` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `PaymentStatus` VARCHAR(50) NULL DEFAULT 'Pending',
  PRIMARY KEY (`OrderID`),
  INDEX `orders_customer_fk_idx` (`CustomerID` ASC) VISIBLE,
  INDEX `orders_booking_fk_idx` (`BookingID` ASC) VISIBLE,
  INDEX `orders_staff_fk_idx` (`StaffID` ASC) VISIBLE,
  CONSTRAINT `orders_customer_fk`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `littlelemondb`.`Customers` (`CustomerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `orders_booking_fk`
    FOREIGN KEY (`BookingID`)
    REFERENCES `littlelemondb`.`Bookings` (`BookingID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `orders_staff_fk`
    FOREIGN KEY (`StaffID`)
    REFERENCES `littlelemondb`.`Staff` (`StaffID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `littlelemondb`.`Order_Details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`Order_Details` (
  `OrderDetailID` INT NOT NULL AUTO_INCREMENT,
  `OrderID` INT NULL,
  `MenuItemID` INT NULL,
  `Qunatity` INT NOT NULL DEFAULT 1,
  `PriceAtOrder` DECIMAL(10,2) NOT NULL,
  `Subtotal` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`OrderDetailID`),
  INDEX `order_details_order_fk_idx` (`OrderID` ASC) VISIBLE,
  INDEX `order_details_menuitem_fk_idx` (`MenuItemID` ASC) VISIBLE,
  CONSTRAINT `order_details_order_fk`
    FOREIGN KEY (`OrderID`)
    REFERENCES `littlelemondb`.`Orders` (`OrderID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `order_details_menuitem_fk`
    FOREIGN KEY (`MenuItemID`)
    REFERENCES `littlelemondb`.`Menu_Items` (`MenuItemID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `littlelemondb`.`Order_Delivery_Status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`Order_Delivery_Status` (
  `DeliveryStatusID` INT NOT NULL AUTO_INCREMENT,
  `OrderID` INT NULL,
  `DeliveryAddress` TEXT NOT NULL,
  `DeliveryStaffID` INT NULL,
  `EstimatedDeliveryTime` TIMESTAMP NULL,
  `ActualDeliveryTime` TIMESTAMP NULL,
  `Status` VARCHAR(50) NOT NULL,
  `LastUpdated` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `DeliveryNotes` TEXT NULL,
  PRIMARY KEY (`DeliveryStatusID`),
  UNIQUE INDEX `OrderID_UNIQUE` (`OrderID` ASC) VISIBLE,
  CONSTRAINT `order_delivery_staff_fk`
    FOREIGN KEY (`DeliveryStaffID`)
    REFERENCES `littlelemondb`.`Staff` (`StaffID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `order_delivery_order_fk`
    FOREIGN KEY (`OrderID`)
    REFERENCES `littlelemondb`.`Orders` (`OrderID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Sample Data Inserts
-- -----------------------------------------------------

-- Sample Data for Customers Table (30 entries)
INSERT INTO `littlelemondb`.`Customers` (`FirstName`, `LastName`, `PhoneNumber`, `Email`, `Address`) VALUES
('Alice', 'Smith', '123-456-7890', 'alice.smith@example.com', '123 Main St, Anytown, USA'),
('Bob', 'Johnson', '987-654-3210', 'bob.johnson@example.com', '456 Oak Ave, Anytown, USA'),
('Charlie', 'Brown', '555-123-4567', 'charlie.brown@example.com', '789 Pine Ln, Anytown, USA'),
('Diana', 'Miller', '111-222-3333', 'diana.miller@example.com', '101 Elm Rd, Anytown, USA'),
('Ethan', 'Davis', '444-555-6666', 'ethan.davis@example.com', '222 Willow Dr, Anytown, USA'),
('Fiona', 'Wilson', '777-888-9999', 'fiona.wilson@example.com', '333 Birch Ct, Anytown, USA'),
('George', 'Moore', '222-333-4444', 'george.moore@example.com', '444 Maple St, Anytown, USA'),
('Hannah', 'Taylor', '888-999-0000', 'hannah.taylor@example.com', '555 Cedar Ave, Anytown, USA'),
('Ian', 'Anderson', '333-444-5555', 'ian.anderson@example.com', '666 Spruce Ln, Anytown, USA'),
('Jane', 'Thomas', '999-000-1111', 'jane.thomas@example.com', '777 Oak Rd, Anytown, USA'),
('Kevin', 'Jackson', '666-777-8888', 'kevin.jackson@example.com', '888 Pine Dr, Anytown, USA'),
('Laura', 'White', '000-111-2222', 'laura.white@example.com', '999 Elm Ct, Anytown, USA'),
('Michael', 'Harris', '555-666-7777', 'michael.harris@example.com', '111 Willow St, Anytown, USA'),
('Nancy', 'Martin', '111-999-8888', 'nancy.martin@example.com', '222 Birch Ave, Anytown, USA'),
('Oliver', 'King', '444-333-2222', 'oliver.king@example.com', '333 Maple Ln, Anytown, USA'),
('Patricia', 'Wright', '777-222-1111', 'patricia.wright@example.com', '444 Cedar Rd, Anytown, USA'),
('Quinn', 'Hall', '222-888-7777', 'quinn.hall@example.com', '555 Spruce Dr, Anytown, USA'),
('Rachel', 'Green', '888-444-3333', 'rachel.green@example.com', '666 Oak Ct, Anytown, USA'),
('Samuel', 'Adams', '333-999-6666', 'samuel.adams@example.com', '777 Pine St, Anytown, USA'),
('Teresa', 'Baker', '999-555-4444', 'teresa.baker@example.com', '888 Elm Ave, Anytown, USA'),
('Victor', 'Nelson', '666-111-0000', 'victor.nelson@example.com', '999 Willow Ln, Anytown, USA'),
('Wendy', 'Carter', '000-666-5555', 'wendy.carter@example.com', '111 Birch Rd, Anytown, USA'),
('Xavier', 'Reed', '555-000-9999', 'xavier.reed@example.com', '222 Maple Dr, Anytown, USA'),
('Yolanda', 'Long', '111-555-4444', 'yolanda.long@example.com', '333 Cedar Ct, Anytown, USA'),
('Zachary', 'Ross', '444-000-3333', 'zachary.ross@example.com', '444 Spruce St, Anytown, USA'),
('Ava', 'Rivera', '777-444-2222', 'ava.rivera@example.com', '555 Oak Ave, Anytown, USA'),
('Caleb', 'Bell', '222-777-6666', 'caleb.bell@example.com', '666 Pine Ln, Anytown, USA'),
('Bella', 'Ward', '888-333-2222', 'bella.ward@example.com', '789 Elm Rd, Anytown, USA'),
('Daniel', 'Gray', '333-888-5555', 'daniel.gray@example.com', '101 Willow Dr, Anytown, USA'),
('Ella', 'Cooper', '999-444-1111', 'ella.cooper@example.com', '222 Birch Ct, Anytown, USA');

-- Sample Data for Staff Table (30 entries)
INSERT INTO `littlelemondb`.`Staff` (`FirstName`, `LastName`, `Role`, `Salary`, `PhoneNumber`, `Staffcol`, `HireDate`, `IsActive`) VALUES
('John', 'Doe', 'Manager', 50000.00, '111-222-3331', NULL, '2022-08-15', 1),
('Jane', 'Smith', 'Chef', 45000.00, '111-222-3332', NULL, '2023-01-20', 1),
('Peter', 'Jones', 'Waiter', 30000.00, '111-222-3333', NULL, '2023-05-10', 1),
('Mary', 'Brown', 'Waiter', 31000.00, '111-222-3334', NULL, '2023-07-01', 1),
('David', 'Wilson', 'Dishwasher', 25000.00, '111-222-3335', NULL, '2023-09-15', 1),
('Susan', 'Moore', 'Host', 32000.00, '111-222-3336', NULL, '2023-11-01', 1),
('Michael', 'Taylor', 'Chef', 48000.00, '111-222-3337', NULL, '2024-02-10', 1),
('Linda', 'Anderson', 'Manager', 52000.00, '111-222-3338', NULL, '2024-04-01', 1),
('James', 'Thomas', 'Waiter', 29000.00, '111-222-3339', NULL, '2024-06-15', 1),
('Karen', 'Jackson', 'Host', 33000.00, '111-222-3340', NULL, '2024-08-01', 1),
('Charles', 'White', 'Chef', 46000.00, '111-222-3341', NULL, '2024-09-20', 1),
('Patricia', 'Harris', 'Waiter', 30500.00, '111-222-3342', NULL, '2024-11-10', 1),
('Robert', 'Martin', 'Dishwasher', 26000.00, '111-222-3343', NULL, '2025-01-05', 1),
('Jennifer', 'King', 'Host', 31500.00, '111-222-3344', NULL, '2025-03-01', 1),
('William', 'Wright', 'Chef', 47000.00, '111-222-3345', NULL, '2025-04-15', 1),
('Elizabeth', 'Hall', 'Waiter', 32500.00, '111-222-3346', NULL, '2025-05-01', 1),
('Joseph', 'Green', 'Manager', 51000.00, '111-222-3347', NULL, '2023-03-10', 1),
('Jessica', 'Adams', 'Chef', 44000.00, '111-222-3348', NULL, '2023-06-01', 1),
('Thomas', 'Baker', 'Waiter', 28000.00, '111-222-3349', NULL, '2023-08-20', 1),
('Ashley', 'Nelson', 'Host', 34000.00, '111-222-3350', NULL, '2023-10-01', 1),
('Matthew', 'Carter', 'Chef', 49000.00, '111-222-3351', NULL, '2024-01-15', 1),
('Amanda', 'Reed', 'Waiter', 31500.00, '111-222-3352', NULL, '2024-03-01', 1),
('Christopher', 'Long', 'Dishwasher', 27000.00, '111-222-3353', NULL, '2024-05-10', 1),
('Sarah', 'Ross', 'Host', 32500.00, '111-222-3354', NULL, '2024-07-01', 1),
('Daniel', 'Rivera', 'Chef', 45500.00, '111-222-3355', NULL, '2024-09-15', 1),
('Brittany', 'Bell', 'Waiter', 33000.00, '111-222-3356', NULL, '2024-11-01', 1),
('Andrew', 'Ward', 'Manager', 53000.00, '111-222-3357', NULL, '2025-02-10', 1),
('Nicole', 'Gray', 'Chef', 47500.00, '111-222-3358', NULL, '2025-04-01', 1),
('Ryan', 'Cooper', 'Waiter', 29500.00, '111-222-3359', NULL, '2025-06-15', 1),
('Stephanie', 'Howard', 'Host', 33500.00, '111-222-3360', NULL, '2025-08-01', 1);

-- Sample Data for Menu_Items Table (30 entries)
INSERT INTO `littlelemondb`.`Menu_Items` (`ItemName`, `Description`, `Price`, `Category`, `Subcategory`, `IsAvailable`, `PrepTimeMinutes`) VALUES -- Removed Menu_Itemscol, updated Subategory
('Margherita Pizza', 'Classic pizza with tomato sauce, mozzarella, and basil.', 12.99, 'Main Course', 'Pizza', 1, 20),
('Pepperoni Pizza', 'Pizza with tomato sauce, mozzarella, and pepperoni.', 14.99, 'Main Course', 'Pizza', 1, 22),
('Vegetarian Pizza', 'Pizza with tomato sauce, mozzarella, and mixed vegetables.', 13.99, 'Main Course', 'Pizza', 1, 25),
('Chicken Caesar Salad', 'Romaine lettuce, grilled chicken, croutons, and Caesar dressing.', 10.99, 'Main Course', 'Salad', 1, 15),
('Greek Salad', 'Tomatoes, cucumbers, onions, olives, and feta cheese.', 9.99, 'Main Course', 'Salad', 1, 12),
('Caprese Salad', 'Fresh mozzarella, tomatoes, and basil with balsamic glaze.', 8.99, 'Appetizer', 'Salad', 1, 10),
('Spaghetti Carbonara', 'Spaghetti with eggs, cheese, pancetta, and black pepper.', 15.99, 'Main Course', 'Pasta', 1, 18),
('Fettuccine Alfredo', 'Fettuccine pasta with creamy Alfredo sauce.', 14.99, 'Main Course', 'Pasta', 1, 16),
('Lasagna', 'Layers of pasta, meat sauce, ricotta cheese, and mozzarella.', 16.99, 'Main Course', 'Pasta', 1, 35),
('Garlic Bread', 'Toasted bread with garlic butter.', 4.99, 'Appetizer', 'Bread', 1, 8),
('Bruschetta', 'Toasted bread topped with tomatoes, garlic, and basil.', 6.99, 'Appetizer', 'Bread', 1, 10),
('French Fries', 'Crispy fried potato strips.', 3.99, 'Side', 'Potatoes', 1, 10),
('Mashed Potatoes', 'Creamy mashed potatoes.', 4.49, 'Side', 'Potatoes', 1, 15),
('Grilled Salmon', 'Grilled salmon fillet with your choice of side.', 18.99, 'Main Course', 'Seafood', 1, 25),
('Fish and Chips', 'Battered and fried fish served with fries.', 15.99, 'Main Course', 'Seafood', 1, 20),
('Chocolate Cake', 'Rich chocolate cake with chocolate frosting.', 7.99, 'Dessert', 'Cake', 1, 10),
('Vanilla Ice Cream', 'Classic vanilla ice cream.', 5.99, 'Dessert', 'Ice Cream', 1, 5),
('Apple Pie', 'Homemade apple pie served warm.', 6.99, 'Dessert', 'Pie', 1, 30),
('Espresso', 'Strong black coffee.', 3.99, 'Drinks', 'Coffee', 1, 2),
('Cappuccino', 'Espresso with steamed milk and foam.', 4.49, 'Drinks', 'Coffee', 1, 3),
('Latte', 'Espresso with steamed milk.', 4.49, 'Drinks', 'Coffee', 1, 3),
('Soda (Coke)', NULL, 2.99, 'Drinks', 'Soda', 1, 1),
('Soda (Sprite)', NULL, 2.99, 'Drinks', 'Soda', 1, 1),
('Bottled Water', NULL, 1.99, 'Drinks', 'Water', 1, 1),
('Lemonade', NULL, 3.49, 'Drinks', 'Juice', 1, 5),
('Orange Juice', NULL, 3.99, 'Drinks', 'Juice', 1, 3),
('Tiramisu', 'Italian dessert with coffee-soaked ladyfingers and mascarpone.', 8.49, 'Dessert', 'Other', 1, 15),
('Panna Cotta', 'Italian cooked cream dessert.', 7.49, 'Dessert', 'Other', 1, 20),
('Minestrone Soup', 'Italian vegetable soup.', 5.99, 'Appetizer', 'Soup', 1, 25),
('Tomato Soup', 'Creamy tomato soup.', 4.99, 'Appetizer', 'Soup', 1, 20);

-- Sample Data for Bookings Table (30 entries)
INSERT INTO `littlelemondb`.`Bookings` (`CustomerID`, `StaffID`, `BookingDateTime`, `TableNumber`, `NumberOfGuests`, `Status`, `Notes`) VALUES
(1, 1, '2025-05-24 12:00:00', 1, 2, 'Confirmed', NULL),
(2, 3, '2025-05-24 13:30:00', 3, 4, 'Confirmed', 'Birthday celebration'),
(3, 2, '2025-05-24 18:00:00', 5, 2, 'Confirmed', NULL),
(4, 4, '2025-05-25 19:00:00', 2, 3, 'Confirmed', 'Anniversary dinner'),
(5, 1, '2025-05-25 20:00:00', 7, 5, 'Confirmed', 'Family gathering'),
(6, 5, '2025-05-26 12:30:00', 4, 2, 'Confirmed', NULL),
(7, 6, '2025-05-26 14:00:00', 6, 6, 'Pending', 'Large group'),
(8, 7, '2025-05-27 17:00:00', 1, 1, 'Confirmed', NULL),
(9, 8, '2025-05-27 19:30:00', 8, 4, 'Confirmed', 'Business meeting'),
(10, 9, '2025-05-28 12:00:00', 3, 2, 'Confirmed', NULL),
(11, 10, '2025-05-28 13:00:00', 5, 3, 'Confirmed', NULL),
(12, 11, '2025-05-29 18:30:00', 2, 5, 'Confirmed', 'Friends reunion'),
(13, 12, '2025-05-29 20:00:00', 7, 2, 'Confirmed', NULL),
(14, 13, '2025-05-30 12:15:00', 4, 4, 'Confirmed', NULL),
(15, 14, '2025-05-30 14:45:00', 6, 1, 'Pending', NULL),
(16, 15, '2025-05-31 17:30:00', 1, 3, 'Confirmed', 'Romantic dinner'),
(17, 16, '2025-05-31 19:00:00', 8, 6, 'Confirmed', 'Team dinner'),
(18, 17, '2025-06-01 12:00:00', 3, 2, 'Confirmed', NULL),
(19, 18, '2025-06-01 13:15:00', 5, 4, 'Confirmed', NULL),
(20, 19, '2025-06-02 18:45:00', 2, 2, 'Confirmed', NULL),
(21, 20, '2025-06-02 20:15:00', 7, 5, 'Confirmed', 'Graduation celebration'),
(22, 21, '2025-06-03 12:00:00', 4, 3, 'Confirmed', NULL),
(23, 22, '2025-06-03 14:30:00', 6, 2, 'Pending', NULL),
(24, 23, '2025-06-04 17:00:00', 1, 4, 'Confirmed', NULL),
(25, 24, '2025-06-04 19:45:00', 8, 1, 'Confirmed', NULL),
(26, 25, '2025-06-05 12:00:00', 3, 2, 'Confirmed', NULL),
(27, 26, '2025-06-05 13:45:00', 5, 3, 'Confirmed', NULL),
(28, 27, '2025-06-06 18:00:00', 2, 5, 'Confirmed', 'Farewell party'),
(29, 28, '2025-06-06 20:30:00', 7, 2, 'Confirmed', NULL),
(30, 29, '2025-06-07 12:00:00', 4, 4, 'Confirmed', NULL);

-- Sample Data for Orders Table (30 entries)
INSERT INTO `littlelemondb`.`Orders` (`CustomerID`, `BookingID`, `StaffID`, `OrderType`, `TotalAmount`, `OrderDateTime`, `PaymentStatus`) VALUES
(1, 1, 3, 'Dine-in', 35.50, '2025-05-24 12:15:00', 'Paid'),
(2, 2, 4, 'Dine-in', 75.00, '2025-05-24 13:45:00', 'Paid'),
(3, 3, 1, 'Takeaway', 25.00, '2025-05-24 18:10:00', 'Pending'),
(4, 4, 5, 'Dine-in', 50.25, '2025-05-25 19:10:00', 'Paid'),
(5, 5, 2, 'Dine-in', 120.00, '2025-05-25 20:15:00', 'Paid'),
(6, 6, 6, 'Takeaway', 40.00, '2025-05-26 12:45:00', 'Pending'),
(7, 7, 7, 'Dine-in', 90.50, '2025-05-26 14:10:00', 'Pending'),
(8, 8, 8, 'Dine-in', 15.00, '2025-05-27 17:10:00', 'Paid'),
(9, 9, 9, 'Dine-in', 60.75, '2025-05-27 19:45:00', 'Paid'),
(10, 10, 10, 'Takeaway', 30.00, '2025-05-28 12:10:00', 'Paid'),
(11, 11, 11, 'Dine-in', 45.00, '2025-05-28 13:15:00', 'Paid'),
(12, 12, 12, 'Dine-in', 110.00, '2025-05-29 18:45:00', 'Paid'),
(13, 13, 13, 'Takeaway', 28.50, '2025-05-29 20:10:00', 'Pending'),
(14, 14, 14, 'Dine-in', 70.00, '2025-05-30 12:30:00', 'Paid'),
(15, 15, 15, 'Dine-in', 20.00, '2025-05-30 15:00:00', 'Pending'),
(16, 16, 16, 'Dine-in', 55.00, '2025-05-31 17:45:00', 'Paid'),
(17, 17, 17, 'Dine-in', 130.00, '2025-05-31 19:15:00', 'Paid'),
(18, 18, 18, 'Takeaway', 38.00, '2025-06-01 12:10:00', 'Paid'),
(19, 19, 19, 'Dine-in', 80.00, '2025-06-01 13:30:00', 'Paid'),
(20, 20, 20, 'Dine-in', 30.00, '2025-06-02 19:00:00', 'Pending'),
(21, 21, 21, 'Dine-in', 100.00, '2025-06-02 20:30:00', 'Paid'),
(22, 22, 22, 'Takeaway', 42.00, '2025-06-03 12:15:00', 'Paid'),
(23, 23, 23, 'Dine-in', 65.00, '2025-06-03 14:45:00', 'Pending'),
(24, 24, 24, 'Dine-in', 22.00, '2025-06-04 17:15:00', 'Paid'),
(25, 25, 25, 'Dine-in', 78.00, '2025-06-04 20:00:00', 'Paid'),
(26, 26, 26, 'Takeaway', 33.00, '2025-06-05 12:10:00', 'Paid'),
(27, 27, 27, 'Dine-in', 58.00, '2025-06-05 14:00:00', 'Paid'),
(28, 28, 28, 'Dine-in', 140.00, '2025-06-06 18:15:00', 'Paid'),
(29, 29, 29, 'Takeaway', 27.00, '2025-06-06 20:45:00', 'Pending'),
(30, 30, 30, 'Dine-in', 85.00, '2025-06-07 12:15:00', 'Paid');

-- Sample Data for Order_Details Table (30 entries)
INSERT INTO `littlelemondb`.`Order_Details` (`OrderID`, `MenuItemID`, `Qunatity`, `PriceAtOrder`, `Subtotal`) VALUES
(1, 1, 1, 12.99, 12.99),
(1, 10, 1, 4.99, 4.99),
(2, 7, 2, 15.99, 31.98),
(2, 16, 1, 7.99, 7.99),
(3, 11, 1, 6.99, 6.99),
(3, 22, 2, 2.99, 5.98),
(4, 4, 1, 10.99, 10.99),
(4, 14, 1, 18.99, 18.99),
(5, 9, 3, 16.99, 50.97),
(5, 18, 2, 6.99, 13.98),
(6, 1, 1, 12.99, 12.99),
(6, 12, 1, 3.99, 3.99),
(7, 2, 2, 14.99, 29.98),
(7, 20, 3, 4.49, 13.47),
(8, 25, 1, 3.49, 3.49),
(9, 6, 1, 8.99, 8.99),
(9, 15, 1, 15.99, 15.99),
(10, 13, 1, 4.49, 4.49),
(10, 23, 2, 2.99, 5.98),
(11, 5, 1, 9.99, 9.99),
(11, 19, 1, 3.99, 3.99),
(12, 8, 2, 14.99, 29.98),
(12, 27, 1, 8.49, 8.49),
(13, 17, 1, 5.99, 5.99),
(14, 3, 1, 13.99, 13.99),
(14, 21, 2, 4.49, 8.98),
(15, 24, 1, 1.99, 1.99),
(16, 26, 1, 3.99, 3.99),
(17, 28, 1, 7.49, 7.49),
(18, 29, 1, 5.99, 5.99);


-- Sample Data for Order_Delivery_Status Table (30 entries)
INSERT INTO `littlelemondb`.`Order_Delivery_Status` (`OrderID`, `DeliveryAddress`, `DeliveryStaffID`, `EstimatedDeliveryTime`, `ActualDeliveryTime`, `Status`, `DeliveryNotes`) VALUES
(1, '123 Main St, Anytown, USA', 3, '2025-05-24 12:45:00', '2025-05-24 12:40:00', 'Delivered', NULL),
(2, '456 Oak Ave, Anytown, USA', 4, '2025-05-24 14:15:00', '2025-05-24 14:10:00', 'Delivered', NULL),
(3, '789 Pine Ln, Anytown, USA', 1, '2025-05-24 18:40:00', NULL, 'In Transit', 'Driver en route'),
(4, '101 Elm Rd, Anytown, USA', 5, '2025-05-25 19:40:00', '2025-05-25 19:35:00', 'Delivered', NULL),
(5, '222 Willow Dr, Anytown, USA', 2, '2025-05-25 20:45:00', '2025-05-25 20:40:00', 'Delivered', NULL),
(6, '333 Birch Ct, Anytown, USA', 6, '2025-05-26 13:15:00', NULL, 'In Transit', NULL),
(7, '444 Maple St, Anytown, USA', 7, '2025-05-26 14:40:00', NULL, 'Preparing', NULL),
(8, '555 Cedar Ave, Anytown, USA', 8, '2025-05-27 17:40:00', '2025-05-27 17:35:00', 'Delivered', NULL),
(9, '666 Spruce Ln, Anytown, USA', 9, '2025-05-27 20:15:00', '2025-05-27 20:10:00', 'Delivered', NULL),
(10, '777 Oak Rd, Anytown, USA', 10, '2025-05-28 12:40:00', '2025-05-28 12:35:00', 'Delivered', NULL),
(11, '888 Pine Dr, Anytown, USA', 11, '2025-05-28 13:45:00', '2025-05-28 13:40:00', 'Delivered', NULL),
(12, '999 Elm Ct, Anytown, USA', 12, '2025-05-29 19:15:00', '2025-05-29 19:10:00', 'Delivered', NULL),
(13, '111 Willow St, Anytown, USA', 13, '2025-05-29 20:40:00', NULL, 'In Transit', 'Customer requested contactless delivery'),
(14, '222 Birch Ave, Anytown, USA', 14, '2025-05-30 13:00:00', '2025-05-30 12:55:00', 'Delivered', NULL),
(15, '333 Maple Ln, Anytown, USA', 15, '2025-05-30 15:30:00', NULL, 'Preparing', NULL),
(16, '444 Cedar Rd, Anytown, USA', 16, '2025-05-31 18:15:00', '2025-05-31 18:10:00', 'Delivered', NULL),
(17, '555 Spruce Dr, Anytown, USA', 17, '2025-05-31 19:45:00', '2025-05-31 19:40:00', 'Delivered', NULL),
(18, '666 Oak Ct, Anytown, USA', 18, '2025-06-01 12:40:00', '2025-06-01 12:35:00', 'Delivered', NULL),
(19, '777 Pine St, Anytown, USA', 19, '2025-06-01 14:00:00', '2025-06-01 13:55:00', 'Delivered', NULL),
(20, '888 Elm Ave, Anytown, USA', 20, '2025-06-02 19:30:00', NULL, 'In Transit', NULL),
(21, '999 Willow Ln, Anytown, USA', 21, '2025-06-02 21:00:00', '2025-06-02 20:55:00', 'Delivered', NULL),
(22, '111 Birch Rd, Anytown, USA', 22, '2025-06-03 12:45:00', '2025-06-03 12:40:00', 'Delivered', NULL),
(23, '222 Maple Dr, Anytown, USA', 23, '2025-06-03 15:15:00', NULL, 'Preparing', NULL),
(24, '333 Cedar Ct, Anytown, USA', 24, '2025-06-04 17:45:00', '2025-06-04 17:40:00', 'Delivered', NULL),
(25, '444 Spruce St, Anytown, USA', 25, '2025-06-04 20:30:00', '2025-06-04 20:25:00', 'Delivered', NULL),
(26, '555 Oak Ave, Anytown, USA', 26, '2025-06-05 12:40:00', '2025-06-05 12:35:00', 'Delivered', NULL),
(27, '666 Pine Ln, Anytown, USA', 27, '2025-06-05 14:30:00', '2025-06-05 14:25:00', 'Delivered', NULL),
(28, '789 Elm Rd, Anytown, USA', 28, '2025-06-06 18:45:00', '2025-06-06 18:40:00', 'Delivered', NULL),
(29, '101 Willow Dr, Anytown, USA', 29, '2025-06-06 21:15:00', NULL, 'In Transit', NULL),
(30, '222 Birch Ct, Anytown, USA', 30, '2025-06-07 12:45:00', '2025-06-07 12:40:00', 'Delivered', NULL);
