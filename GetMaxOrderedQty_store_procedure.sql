USE littlelemondb;
DELIMITER //

CREATE PROCEDURE GetMaxOrderedQuantity()
BEGIN
    SELECT MAX(Qunatity) AS MaximumOrderedQuantity
    FROM `littlelemondb`.`Order_Details`;
END //

DELIMITER ;

-- CALL GetMaxOrderedQuantity();