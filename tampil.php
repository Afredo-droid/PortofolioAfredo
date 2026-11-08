<?php
// Header CORS untuk mengizinkan Flutter Web (Chrome) & Emulator mengakses API
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");

require_once "koneksi.php";

if ($_SERVER["REQUEST_METHOD"] !== "GET") {
    responseJson(false, "Gunakan metode GET", null, 405);
}

$sql = "SELECT id, name, category, year, technology, description, image
        FROM portfolio
        ORDER BY id DESC";
$result = $conn->query($sql);

if (!$result) {
    responseJson(false, "Gagal mengambil data portofolio. Periksa tabel portfolio.", null, 500);
}

$data = [];
while ($row = $result->fetch_assoc()) {
    $row["id"] = (int) $row["id"];
    $data[] = $row;
}

echo json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
?>