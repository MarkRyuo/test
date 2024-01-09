<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Condition</title>
</head>
<body>
  

  <form action="condition.php" method="post">

    <label for="quantity">quantity</label>
    <input type="text" id="quantity" name="quantity" required>

    <label for="price">Price</label>
    <input type="text" id="price" name="price" required>

    <input type="submit" value="Add Quantity">
  </form>
</body>
</html>

<?php 

$quantity = $_POST["quantity"] ;
$price = $_POST["price"] ;

if ($quantity >= 20) {
  echo "are you kidding me thats to many" ;
}
else {
  echo "bro thats great" ;
}


?>