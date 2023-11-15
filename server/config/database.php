<?php

class DatabaseConnection {
  private $host;
  private $username;
  private $password;
  private $database;
  private $conn;

  public function __construct() {
    //? Read the .env file
    $envFile = __DIR__ . '/../.env'; 

    if (file_exists($envFile)) {
      $env = parse_ini_file($envFile);

      if ($env) {
        $this->host = $env['DB_HOST'];
        $this->username = $env['DB_USERNAME'];
        $this->password = $env['DB_PASSWORD'];
        $this->database = $env['DB_DATABASE'];
      } else {
        die(".env file is empty or invalid.");
      }

    } else {
        die(".env file not found.");
    }
  }

  public function connect() {
    $this->conn = new mysqli (
      $this->host, $this->username, $this->password, $this->database
    );

    if ($this->conn->connect_error) {
      die("Connection failed: " . $this->conn->connect_error);
    }
  }

  public function close() {
    if ($this->conn) {
      $this->conn->close();
    }
  }

  public function prepare($sql) {
    if ($this->conn) {
      return $this->conn->prepare($sql);
    } else if ($this->conn === false) {
      http_response_code(500);
      echo json_encode([
				'message' => 'Database error: Unable to prepare statement',
			]);
      exit();
    } else {
      die("Database connection is not established.");
    }
  }

  public function ping() {
    if ($this->conn) {
      if (mysqli_ping($this->conn)) {
        echo 'Connection is active.';
      } else {
        echo 'Connection is dead.';
      }
    } else {
      echo 'Database connection is not established.';
    }
  }
}