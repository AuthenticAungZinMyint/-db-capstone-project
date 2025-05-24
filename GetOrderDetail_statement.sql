-- Prepare the statement
PREPARE GetOrderDetail FROM
'SELECT
    OrderDetailID,
    OrderID,
    MenuItemID,
    Qunatity,
    PriceAtOrder,
    Subtotal
FROM
    `littlelemondb`.`Order_Details`
WHERE
    OrderID = ?';

-- Example of executing the prepared statement with OrderID = 1
-- SET @order_id = 1;
-- EXECUTE GetOrderDetail USING @order_id;

-- Example of executing the prepared statement with OrderID = 5
-- SET @order_id = 5;
-- EXECUTE GetOrderDetail USING @order_id;

-- Deallocate the prepared statement when no longer needed
-- DEALLOCATE PREPARE GetOrderDetail;