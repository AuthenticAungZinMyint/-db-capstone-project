DELIMITER //

CREATE PROCEDURE AddValidBooking(IN p_BookingDate DATE, IN p_TableNumber INT, IN p_CustomerID INT, IN p_StaffID INT, IN p_NumberOfGuests INT)
BEGIN
    AddValidBookingDECLARE is_booked INT DEFAULT 0; -- Variable to check if the table is booked

    START TRANSACTION;

    -- Check if the table is already booked on the given date
    SELECT COUNT(*)
    INTO is_booked
    FROM `littlelemondb`.`Bookings`
    WHERE DATE(BookingDateTime) = p_BookingDate AND TableNumber = p_TableNumber;

    IF is_booked > 0 THEN
        -- Table is already booked, rollback the transaction
        ROLLBACK;
        SELECT CONCAT('Booking for table ', p_TableNumber, ' on ', p_BookingDate, ' failed. Table is already booked.') AS Message;
    ELSE
        -- Table is available, insert the new booking record
        INSERT INTO `littlelemondb`.`Bookings`
            (`CustomerID`, `StaffID`, `BookingDateTime`, `TableNumber`, `NumberOfGuests`, `Status`, `Notes`)
        VALUES
            (p_CustomerID, p_StaffID, CONCAT(p_BookingDate, ' 19:00:00'), p_TableNumber, p_NumberOfGuests, 'Confirmed', NULL);

        -- Commit the transaction
        COMMIT;
        SELECT CONCAT('Booking for table ', p_TableNumber, ' on ', p_BookingDate, ' successfully added.') AS Message;
    END IF;

END //

DELIMITER ;


-- Scenario 1: Attempt to book an available table (e.g., Table 10 on 2025-06-08)
-- CALL AddValidBooking('2025-06-08', 10, 1, 1, 4);

-- Scenario 2: Attempt to book a table that is already booked (e.g., Table 5 on 2022-10-10 from your sample data)
-- CALL AddValidBooking('2022-10-10', 5, 2, 3, 2);

-- Scenario 3: Attempt to book another available table
-- CALL AddValidBooking('2025-06-09', 1, 5, 5, 6);
