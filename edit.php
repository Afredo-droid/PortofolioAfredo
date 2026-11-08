
<?php
require_once "koneksi.php";

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    responseJson(false, "Gunakan metode POST", null, 405);
}

$id = filter_var($_POST["id"] ?? null, FILTER_VALIDATE_INT);
$name = trim($_POST["name"] ?? "");
$category = trim($_POST["category"] ?? "");
$year = trim($_POST["year"] ?? "");
$technology = trim($_POST["technology"] ?? "");
$description = trim($_POST["description"] ?? "");

if (!$id || $id < 1) {
    responseJson(false, "ID karya tidak valid", null, 400);
}

if ($name === "" || $category === "" || $year === "" ||
    $technology === "" || $description === "") {
    responseJson(false, "Semua kolom wajib diisi", null, 400);
}

$stmt = $conn->prepare("SELECT image FROM portfolio WHERE id = ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();
$oldData = $result->fetch_assoc();

if (!$oldData) {
    responseJson(false, "Karya tidak ditemukan", null, 404);
}

$newImage = saveUploadedImage("image");
$image = $newImage ?? $oldData["image"];

$stmt = $conn->prepare(
    "UPDATE portfolio
     SET name = ?, category = ?, year = ?, technology = ?,
         description = ?, image = ?
     WHERE id = ?"
);

if (!$stmt) {
    if ($newImage) deleteImageFile($newImage);
    responseJson(false, "Gagal menyiapkan perubahan", null, 500);
}

$stmt->bind_param(
    "ssssssi",
    $name,
    $category,
    $year,
    $technology,
    $description,
    $image,
    $id
);

if (!$stmt->execute()) {
    if ($newImage) deleteImageFile($newImage);
    responseJson(false, "Gagal memperbarui karya", null, 500);
}

if ($newImage && $oldData["image"]) {
    deleteImageFile($oldData["image"]);
}

responseJson(true, "Portofolio berhasil diperbarui", [
    "id" => $id,
    "image" => $image
]);
