SELECT
    ItemName
FROM
    `littlelemondb`.`Menu_Items`
WHERE
    MenuItemID = ANY (
        SELECT
            MenuItemID
        FROM
            `littlelemondb`.`Order_Details`
        WHERE
            Qunatity > 2
    );