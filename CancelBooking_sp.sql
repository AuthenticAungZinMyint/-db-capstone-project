DELIMITER //

CREATE PROCEDURE CancelBooking(
    IN p_BookingID INT
)
BEGIN
    -- Delete the booking record from the Bookings table based on the provided BookingID.
    -- Due to ON DELETE CASCADE constraints defined in your schema,
    -- any related records in Orders, Order_Details, and Order_Delivery_Status
    -- that are linked to this booking will also be automatically deleted.
    DELETE FROM `littlelemondb`.`Bookings`
    WHERE BookingID = p_BookingID;

    -- Provide a message indicating the outcome of the deletion
    IF ROW_COUNT() > 0 THEN
        SELECT CONCAT('Booking ', p_BookingID, ' and its associated records successfully cancelled.') AS Message;
    ELSE
        SELECT CONCAT('No booking found with BookingID ', p_BookingID, '. Cancellation failed.') AS Message;
    END IF;
END //

DELIMITER ;
