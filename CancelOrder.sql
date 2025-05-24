CREATE DEFINER=`admin_1`@`%` PROCEDURE `CancelOrder`(IN p_OrderID INT)
BEGIN
	-- Attempt to delete the order from the Orders table.
    -- Due to ON DELETE CASCADE, related records in Order_Details
    -- and Order_Delivery_Status will also be deleted automatically.
    DELETE FROM `littlelemondb`.`Orders`
    WHERE OrderID = p_OrderID;
    -- Check if any row was affected by the DELETE statement
    IF ROW_COUNT() > 0 THEN
        SELECT CONCAT('Order with OrderID ', p_OrderID, ' and its associated details have been successfully cancelled.') AS Message;
    ELSE
        SELECT CONCAT('No order found with OrderID ', p_OrderID, '. Cancellation failed.') AS Message;
    END IF;
END