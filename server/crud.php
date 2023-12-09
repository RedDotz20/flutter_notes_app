<?php

//? Create Task
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $data = json_decode(file_get_contents("php://input"), true);
    $title = $data["title"];

    $sql = "INSERT INTO tasks (title) VALUES ('$title')";
    $result = $conn->query($sql);

    if ($result) {
        echo json_encode(["message" => "Task created successfully"]);
    } else {
        echo json_encode(["error" => "Error creating task"]);
    }
}

//? Read Tasks
if ($_SERVER["REQUEST_METHOD"] === "GET") {
    $sql = "SELECT * FROM tasks";
    $result = $conn->query($sql);

    $tasks = [];

    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $tasks[] = $row;
        }
    }

    echo json_encode(["tasks" => $tasks]);
}

//? Update Task
if ($_SERVER["REQUEST_METHOD"] === "PUT") {
    $data = json_decode(file_get_contents("php://input"), true);
    $id = $data["id"];
    $completed = $data["completed"];

    $sql = "UPDATE tasks SET completed='$completed' WHERE id=$id";
    $result = $conn->query($sql);

    if ($result) {
        echo json_encode(["message" => "Task updated successfully"]);
    } else {
        echo json_encode(["error" => "Error updating task"]);
    }
}

//? Delete Task
if ($_SERVER["REQUEST_METHOD"] === "DELETE") {
    $data = json_decode(file_get_contents("php://input"), true);
    $id = $data["id"];

    $sql = "DELETE FROM tasks WHERE id=$id";
    $result = $conn->query($sql);

    if ($result) {
        echo json_encode(["message" => "Task deleted successfully"]);
    } else {
        echo json_encode(["error" => "Error deleting task"]);
    }
}
