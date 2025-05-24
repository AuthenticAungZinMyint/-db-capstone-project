-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `littlelemondb` DEFAULT CHARACTER SET utf8 ;
USE `littlelemondb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`Customers` (
  `CustomerID` INT NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(100) NOT NULL,
  `LastName` VARCHAR(100) NOT NULL,
  `PhoneNumber` VARCHAR(20) NULL,
  `Email` VARCHAR(255) NULL,
  `Address` TEXT NULL, -- Changed TEXT(255) to TEXT
  PRIMARY KEY (`CustomerID`),
  UNIQUE INDEX `PhoneNumber_UNIQUE` (`PhoneNumber` ASC) VISIBLE,
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`Staff` (
  `StaffID` INT NOT NULL AUTO_INCREMENT, -- Added AUTO_INCREMENT for StaffID
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
-- Table `mydb`.`Menu_Items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`Menu_Items` (
  `MenuItemID` INT NOT NULL AUTO_INCREMENT,
  `ItemName` VARCHAR(255) NOT NULL,
  `Description` LONGTEXT NULL,
  `Price` DECIMAL(10,2) NOT NULL,
  `Category` VARCHAR(100) NULL,
  `Subategory` VARCHAR(100) NULL,
  `IsAvailable` TINYINT(1) NULL DEFAULT 1,
  `Menu_Itemscol` TINYINT NULL,
  `PrepTimeMinutes` INT NULL,
  PRIMARY KEY (`MenuItemID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`Bookings` (
  `BookingID` INT NOT NULL AUTO_INCREMENT,
  `CustomerID` INT NULL,
  `StaffID` INT NULL,
  `BookingDateTime` TIMESTAMP NULL,
  `TableNumber` INT NOT NULL,
  `NumberOfGuests` INT NOT NULL,
  `Status` VARCHAR(50) NULL DEFAULT 'Confirmed', -- Removed extra quotes
  `Notes` TEXT NULL,
  PRIMARY KEY (`BookingID`),
  INDEX `bookings_customer_fk_idx` (`CustomerID` ASC) VISIBLE, -- Renamed index for clarity
  INDEX `bookings_staff_fk_idx` (`StaffID` ASC) VISIBLE, -- Renamed index for clarity
  CONSTRAINT `bookings_customer_fk` -- Renamed constraint for clarity
    FOREIGN KEY (`CustomerID`)
    REFERENCES `littlelemondb`.`Customers` (`CustomerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `bookings_staff_fk` -- Renamed constraint for clarity
    FOREIGN KEY (`StaffID`)
    REFERENCES `littlelemondb`.`Staff` (`StaffID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`Orders` (
  `OrderID` INT NOT NULL AUTO_INCREMENT,
  `CustomerID` INT NOT NULL,
  `BookingID` INT NOT NULL,
  `StaffID` INT NOT NULL,
  `OrderType` VARCHAR(50) NOT NULL, -- Removed duplicate
  `TotalAmount` DECIMAL(10,2) NOT NULL, -- Removed duplicate
  `OrderDateTime` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `PaymentStatus` VARCHAR(50) NULL DEFAULT 'Pending',
  PRIMARY KEY (`OrderID`),
  INDEX `orders_customer_fk_idx` (`CustomerID` ASC) VISIBLE, -- Renamed index
  INDEX `orders_booking_fk_idx` (`BookingID` ASC) VISIBLE, -- Renamed index
  INDEX `orders_staff_fk_idx` (`StaffID` ASC) VISIBLE, -- Renamed index
  CONSTRAINT `orders_customer_fk` -- Renamed constraint
    FOREIGN KEY (`CustomerID`)
    REFERENCES `littlelemondb`.`Customers` (`CustomerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `orders_booking_fk` -- Renamed constraint
    FOREIGN KEY (`BookingID`)
    REFERENCES `littlelemondb`.`Bookings` (`BookingID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `orders_staff_fk` -- Renamed constraint
    FOREIGN KEY (`StaffID`)
    REFERENCES `littlelemondb`.`Staff` (`StaffID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Order_Details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`Order_Details` (
  `OrderDetailID` INT NOT NULL AUTO_INCREMENT,
  `OrderID` INT NULL,
  `MenuItemID` INT NULL,
  `Qunatity` INT NOT NULL DEFAULT 1,
  `PriceAtOrder` DECIMAL(10,2) NOT NULL,
  `Subtotal` DECIMAL(10,2) NOT NULL, -- Removed invalid DEFAULT calculation
  PRIMARY KEY (`OrderDetailID`),
  INDEX `order_details_order_fk_idx` (`OrderID` ASC) VISIBLE, -- Renamed index
  INDEX `order_details_menuitem_fk_idx` (`MenuItemID` ASC) VISIBLE, -- Renamed index
  CONSTRAINT `order_details_order_fk` -- Renamed constraint
    FOREIGN KEY (`OrderID`)
    REFERENCES `littlelemondb`.`Orders` (`OrderID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `order_details_menuitem_fk` -- Renamed constraint
    FOREIGN KEY (`MenuItemID`)
    REFERENCES `littlelemondb`.`Menu_Items` (`MenuItemID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Order_Delivery_Status`
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
  CONSTRAINT `order_delivery_staff_fk` -- Renamed constraint for clarity
    FOREIGN KEY (`DeliveryStaffID`) -- CORRECTED: This now correctly references DeliveryStaffID
    REFERENCES `littlelemondb`.`Staff` (`StaffID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `order_delivery_order_fk` -- Renamed constraint for clarity
    FOREIGN KEY (`OrderID`)
    REFERENCES `littlelemondbbookings`.`Orders` (`OrderID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
