<?php
require_once 'index.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $json = file_get_contents('php://input');
  $data = json_decode($json, true);

  if (isset($data['username']) && isset($data['password'])) {
    $username = $data['username'];
    $password = $data['password'];
    $confirmPassword = $data['confirmPassword'];

    if ($password !== $confirmPassword) {
      http_response_code(400);
      echo json_encode(['error' => 'Passwords do not match']);
      exit();
    }

    $check_stmt = $connection->prepare('SELECT * FROM users WHERE username = ?');
    $check_stmt->bind_param('s', $username);
    $check_stmt->execute();
    $check_stmt->store_result();

    if ($check_stmt->num_rows > 0) {
      http_response_code(409);
      echo json_encode(['error' => 'Username already exists']);
      $check_stmt->close();
      exit();
    } else {
      $insert_stmt = $connection->prepare("INSERT INTO users (username, password) VALUES (?, ?)");
      $insert_stmt->bind_param('ss', $username, $password);
      $insert_stmt->execute();

      if ($insert_stmt->affected_rows === 1) {
        http_response_code(200);
        echo json_encode(['success' => 'Register Successful']);
        $insert_stmt->close();
        exit();
      } else {
        http_response_code(500);
        echo json_encode(['error' => 'Register Failed']);
        exit();
      }
    }
  } else {
    http_response_code(400);
    echo json_encode(['error' => 'Missing Username or Password']);
    exit();
  }
}

$connection->close();
?>
