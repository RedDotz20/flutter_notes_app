<?php

require_once 'index.php';

// Create Task
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $data = json_decode(file_get_contents("php://input"), true);
    $title = $data["title"];

    $stmt = $connection->prepare("INSERT INTO tasks (title) VALUES (?)");
    $stmt->bind_param("s", $title);

    if ($stmt->execute()) {
        echo json_encode(["message" => "Task created successfully"]);
    } else {
        echo json_encode(["error" => "Error creating task"]);
    }

    $stmt->close();
}

// Read Tasks
if ($_SERVER["REQUEST_METHOD"] === "GET") {
    $stmt = $connection->prepare("SELECT * FROM tasks");
    $stmt->execute();
    $result = $stmt->get_result();

    $tasks = [];

    while ($row = $result->fetch_assoc()) {
        $tasks[] = $row;
    }

    if (!empty($tasks)) {
        echo json_encode(["tasks" => $tasks]);
    }

    $stmt->close();
}


// Update Task
if ($_SERVER["REQUEST_METHOD"] === "PUT") {
    $data = json_decode(file_get_contents("php://input"), true);
    $id = $data["id"];
    $completed = $data["completed"];

    $stmt = $connection->prepare("UPDATE tasks SET completed=? WHERE id=?");
    $stmt->bind_param("ii", $completed, $id);

    if ($stmt->execute()) {
        echo json_encode(["message" => "Task updated successfully"]);
    } else {
        echo json_encode(["error" => "Error updating task"]);
    }

    $stmt->close();
}

// Delete Task
if ($_SERVER["REQUEST_METHOD"] === "DELETE") {
    $data = json_decode(file_get_contents("php://input"), true);
    $id = $data["id"];

    $stmt = $connection->prepare("DELETE FROM tasks WHERE id=?");
    $stmt->bind_param("i", $id);

    if ($stmt->execute()) {
        echo json_encode(["message" => "Task deleted successfully"]);
    } else {
        echo json_encode(["error" => "Error deleting task"]);
    }

    $stmt->close();
}
?>
