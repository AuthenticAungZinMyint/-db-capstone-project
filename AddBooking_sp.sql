DELIMITER //

CREATE PROCEDURE AddBooking(
    IN p_BookingID INT,
    IN p_CustomerID INT,
    IN p_BookingDate DATE,
    IN p_TableNumber INT
)
BEGIN
    -- Insert a new booking record into the Bookings table.
    -- Default values are used for StaffID (1), NumberOfGuests (2),
    -- Status ('Confirmed'), and Notes (NULL) as they were not provided
    -- as input parameters for this specific procedure.
    -- The BookingDateTime is constructed by appending a default time (19:00:00)
    -- to the provided booking date.
    INSERT INTO `littlelemondb`.`Bookings`
        (`BookingID`, `CustomerID`, `StaffID`, `BookingDateTime`, `TableNumber`, `NumberOfGuests`, `Status`, `Notes`)
    VALUES
        (p_BookingID, p_CustomerID, 1, CONCAT(p_BookingDate, ' 19:00:00'), p_TableNumber, 2, 'Confirmed', NULL);

    -- Provide a success message
    SELECT CONCAT('Booking ', p_BookingID, ' for Customer ID ', p_CustomerID, ' on ', p_BookingDate, ' at Table ', p_TableNumber, ' added successfully.') AS Message;
END //

DELIMITER ;