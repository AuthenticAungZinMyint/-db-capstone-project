SELECT
    C.CustomerID,
    CONCAT(C.FirstName, ' ', C.LastName) AS FullName,
    O.OrderID,
    O.TotalAmount AS OrderCost,
    MI.ItemName AS MenuItemName,
    MI.Category AS CourseCategory, -- Represents the 'course name'
    CASE
        WHEN MI.Category = 'Appetizer' THEN MI.ItemName
        ELSE NULL
    END AS StarterName -- Represents the 'starter name' if the item is an appetizer
FROM
    `littlelemondb`.`Customers` AS C
JOIN
    `littlelemondb`.`Orders` AS O
    ON C.CustomerID = O.CustomerID
JOIN
    `littlelemondb`.`Order_Details` AS OD
    ON O.OrderID = OD.OrderID
JOIN
    `littlelemondb`.`Menu_Items` AS MI
    ON OD.MenuItemID = MI.MenuItemID
WHERE
    O.TotalAmount > 100 -- Filter for orders costing more than $150
ORDER BY
    OrderCost ASC; -- Sort by the lowest cost amount
