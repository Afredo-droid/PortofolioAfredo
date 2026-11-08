<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Accept, Authorization");
header("Access-Control-Max-Age: 86400");

if ($_SERVER["REQUEST_METHOD"] === "OPTIONS") {
    http_response_code(204);
    exit;
}

mysqli_report(MYSQLI_REPORT_OFF);

$conn = new mysqli("localhost", "root", "", "portfolio_db");

if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Koneksi database gagal: " . $conn->connect_error
    ]);
    exit;
}

$conn->set_charset("utf8mb4");

function responseJson($success, $message, $data = null, $status = 200) {
    http_response_code($status);

    $result = [
        "success" => $success,
        "message" => $message
    ];

    if ($data !== null) {
        $result["data"] = $data;
    }

    echo json_encode($result, JSON_UNESCAPED_UNICODE);
    exit;
}

function saveUploadedImage($field = "image") {
    if (!isset($_FILES[$field]) || $_FILES[$field]["error"] === UPLOAD_ERR_NO_FILE) {
        return null;
    }

    $file = $_FILES[$field];

    if ($file["error"] !== UPLOAD_ERR_OK) {
        responseJson(false, "Upload foto gagal", null, 400);
    }

    // Perbaikan: Maksimal 5 MB (5 * 1024 * 1024 bytes)
    if ($file["size"] > 5 * 1024 * 1024) {
        responseJson(false, "Ukuran foto maksimal 5 MB", null, 400);
    }

    $imageInfo = @getimagesize($file["tmp_name"]);

    if ($imageInfo === false) {
        responseJson(false, "File harus berupa gambar yang valid", null, 400);
    }

    $mime = $imageInfo["mime"] ?? "";

    $extensions = [
        "image/jpeg" => "jpg",
        "image/png" => "png",
        "image/webp" => "webp",
        "image/gif" => "gif"
    ];

    if (!isset($extensions[$mime])) {
        responseJson(false, "Format foto harus JPG, PNG, WEBP, atau GIF", null, 400);
    }

    $folder = __DIR__ . "/uploads/";

    if (!is_dir($folder) && !mkdir($folder, 0755, true)) {
        responseJson(false, "Folder uploads tidak dapat dibuat", null, 500);
    }

    $filename = bin2hex(random_bytes(16)) . "." . $extensions[$mime];

    if (!move_uploaded_file($file["tmp_name"], $folder . $filename)) {
        responseJson(false, "Foto gagal disimpan ke server", null, 500);
    }

    return $filename;
}

function deleteImageFile($filename) {
    if (!$filename) {
        return;
    }

    // Hapus hanya nama file, bukan path bebas dari permintaan pengguna.
    if (basename($filename) !== $filename) {
        return;
    }

    $path = __DIR__ . "/uploads/" . $filename;

    if (is_file($path)) {
        @unlink($path);
    }
}