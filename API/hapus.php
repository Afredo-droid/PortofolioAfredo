
<?php
require_once "koneksi.php";

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    responseJson(false, "Gunakan metode POST", null, 405);
}

$id = filter_var($_POST["id"] ?? null, FILTER_VALIDATE_INT);

if (!$id || $id < 1) {
    responseJson(false, "ID karya tidak valid", null, 400);
}

$stmt = $conn->prepare("SELECT image FROM portfolio WHERE id = ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();
$data = $result->fetch_assoc();

if (!$data) {
    responseJson(false, "Karya tidak ditemukan", null, 404);
}

$stmt = $conn->prepare("DELETE FROM portfolio WHERE id = ?");
$stmt->bind_param("i", $id);

if (!$stmt->execute()) {
    responseJson(false, "Gagal menghapus karya", null, 500);
}

deleteImageFile($data["image"]);

responseJson(true, "Portofolio berhasil dihapus");
