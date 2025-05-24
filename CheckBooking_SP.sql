DELIMITER //

CREATE PROCEDURE CheckBooking(IN p_BookingDate DATE, IN p_TableNumber INT)
BEGIN
    DECLARE booking_count INT;

    SELECT COUNT(*)
    INTO booking_count
    FROM `littlelemondb`.`Bookings`
    WHERE DATE(BookingDateTime) = p_BookingDate AND TableNumber = p_TableNumber;

    IF booking_count > 0 THEN
        SELECT CONCAT('Table ', p_TableNumber, ' is already booked on ', p_BookingDate, '.') AS BookingStatus;
    ELSE
        SELECT CONCAT('Table ', p_TableNumber, ' is available on ', p_BookingDate, '.') AS BookingStatus;
    END IF;
END //

DELIMITER ;

-- Example of calling the procedure to check a booking:
-- CALL CheckBooking('2022-10-10', 5); -- Should show as booked
-- CALL CheckBooking('2022-10-10', 1); -- Should show as available
-- CALL CheckBooking('2025-05-24', 1); -- Should show as booked (from sample data)
-- CALL CheckBooking('2025-05-24', 8); -- Should show as available
