
<?php
require_once "koneksi.php";

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    responseJson(false, "Gunakan metode POST", null, 405);
}

$name = trim($_POST["name"] ?? "");
$category = trim($_POST["category"] ?? "");
$year = trim($_POST["year"] ?? "");
$technology = trim($_POST["technology"] ?? "");
$description = trim($_POST["description"] ?? "");

if ($name === "" || $category === "" || $year === "" ||
    $technology === "" || $description === "") {
    responseJson(false, "Semua kolom wajib diisi", null, 400);
}

$image = saveUploadedImage("image");

$stmt = $conn->prepare(
    "INSERT INTO portfolio
    (name, category, year, technology, description, image)
    VALUES (?, ?, ?, ?, ?, ?)"
);

if (!$stmt) {
    deleteImageFile($image);
    responseJson(false, "Gagal menyiapkan penyimpanan data", null, 500);
}

$stmt->bind_param(
    "ssssss",
    $name,
    $category,
    $year,
    $technology,
    $description,
    $image
);

if (!$stmt->execute()) {
    deleteImageFile($image);
    responseJson(false, "Gagal menyimpan karya", null, 500);
}

$newId = $conn->insert_id;

responseJson(true, "Portofolio berhasil ditambahkan", [
    "id" => $newId,
    "name" => $name,
    "image" => $image
], 201);

// Di dalam file tambah.php
$image = saveUploadedImage("image") ?? ""; // Jika tidak ada foto, diset string kosong