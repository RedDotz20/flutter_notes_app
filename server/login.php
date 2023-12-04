<?php
require_once 'index.php';

//? Login Account
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
	$json = file_get_contents('php://input');
	$data = json_decode($json, true);

	if (isset($data['username']) && isset($data['password'])) {
		$username = $data['username'];
		$password = $data['password'];

		$stmt = $connection->prepare('SELECT * FROM users WHERE username = ?');
		$stmt->bind_param('s', $username);
		$stmt->execute();
		$result = $stmt->get_result();

		if ($result->num_rows === 1) {
			$row = $result->fetch_assoc();
			$id = $row['user_id'];
      $currentPassword = $row['password'];

      if ($currentPassword === $password) {
        http_response_code(200);
				echo json_encode([ 'success' => 'Login Successful']);
      } else {
        http_response_code(401);
        echo json_encode(['error' => 'Invalid Credentials']);
        exit();
      }

      $stmt->close();
			exit();

		} else {
			http_response_code(404);
			echo json_encode(['error' => 'User Not Found']);
			exit();
		}

	} else {
			http_response_code(400);
			echo json_encode(['error' => 'Missing Username or Password']);
			exit();
	}
}


$connection->close();