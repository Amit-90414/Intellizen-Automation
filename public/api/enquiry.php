<?php

$company = [
  'name' => 'Intellizen Automation Solutions',
  'inbox' => 'sales@intellizen.co.in',
  'sender' => 'sales@intellizen.co.in',
  'phone' => '+91 86992 01062',
  'site' => 'https://intellizen.co.in',
  'address' => 'Hansa Industrial Park, Derabassi, Punjab',
];

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store');

function reply(int $code, array $body): void
{
  http_response_code($code);
  echo json_encode($body);
  exit;
}

function clean(mixed $value, int $max): string
{
  $text = is_string($value) ? trim($value) : '';
  $text = str_replace(["\r\n", "\r"], "\n", $text);
  $text = preg_replace('/[^\P{C}\n\t]/u', '', $text) ?? '';
  return mb_substr($text, 0, $max);
}

function oneLine(string $text): string
{
  return trim(preg_replace('/\s+/', ' ', $text) ?? '');
}

function header_encode(string $text): string
{
  return '=?UTF-8?B?' . base64_encode($text) . '?=';
}

function send(string $to, string $subject, string $body, string $from, string $fromName, string $replyTo = ''): bool
{
  $headers = [
    'MIME-Version: 1.0',
    'Content-Type: text/plain; charset=UTF-8',
    'Content-Transfer-Encoding: 8bit',
    'From: ' . header_encode($fromName) . " <$from>",
  ];
  if ($replyTo !== '') $headers[] = "Reply-To: $replyTo";
  return mail($to, header_encode($subject), $body, implode("\r\n", $headers), "-f$from");
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') reply(405, ['ok' => false, 'error' => 'method']);

$input = json_decode(file_get_contents('php://input') ?: '', true);
if (!is_array($input)) $input = $_POST;

if (clean($input['website'] ?? '', 200) !== '') reply(200, ['ok' => true]);

$name = oneLine(clean($input['name'] ?? '', 120));
$org = oneLine(clean($input['company'] ?? '', 160));
$phone = oneLine(clean($input['phone'] ?? '', 40));
$email = oneLine(clean($input['email'] ?? '', 160));
$product = oneLine(clean($input['product'] ?? '', 120));
$message = clean($input['message'] ?? '', 4000);

if ($name === '' || $message === '' || strlen(preg_replace('/\D/', '', $phone) ?? '') < 10) reply(422, ['ok' => false, 'error' => 'fields']);
if ($email !== '' && !filter_var($email, FILTER_VALIDATE_EMAIL)) reply(422, ['ok' => false, 'error' => 'email']);

$ip = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
$limitFile = sys_get_temp_dir() . '/intellizen-enquiry-' . md5($ip);
$recent = array_filter(array_map('intval', @file($limitFile, FILE_IGNORE_NEW_LINES) ?: []), fn ($t) => $t > time() - 3600);
if (count($recent) >= 5) reply(429, ['ok' => false, 'error' => 'limit']);
$recent[] = time();
@file_put_contents($limitFile, implode("\n", $recent));

$interest = $product !== '' ? $product : 'Not specified';
$when = date('d M Y, H:i');

$notice = implode("\n", [
  "New enquiry from the website ($when)",
  '',
  "Name: $name",
  'Company: ' . ($org !== '' ? $org : '-'),
  "Phone: $phone",
  'Email: ' . ($email !== '' ? $email : '-'),
  "Interested in: $interest",
  '',
  'Message:',
  $message,
  '',
  $email !== '' ? 'Reply to this email to answer the customer directly.' : 'The customer did not give an email address. Please call them.',
]);

$sent = send($company['inbox'], "Website enquiry: $interest - $name", $notice, $company['sender'], $company['name'] . ' website', $email);

$logDir = dirname($_SERVER['DOCUMENT_ROOT'] ?: __DIR__) . '/enquiries';
if (is_dir($logDir) || @mkdir($logDir, 0750, true)) {
  $row = [$when, $name, $org, $phone, $email, $interest, str_replace("\n", ' / ', $message), $ip];
  $handle = @fopen($logDir . '/enquiries.csv', 'a');
  if ($handle) {
    fputcsv($handle, $row);
    fclose($handle);
  }
}

if (!$sent) reply(500, ['ok' => false, 'error' => 'mail']);
reply(200, ['ok' => true]);
