CREATE VIEW OrdersView AS
SELECT
    O.OrderID,
    OD.Qunatity AS Quantity,
    O.TotalAmount AS Cost
FROM
    `littlelemondb`.`Orders` AS O
JOIN
    `littlelemondb`.`Order_Details` AS OD
ON
    O.OrderID = OD.OrderID
WHERE
    OD.Qunatity > 2;

-- To view the contents of the virtual table:
-- SELECT * FROM OrdersView;
