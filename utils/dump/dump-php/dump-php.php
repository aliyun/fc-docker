<?php

use OSS\OssClient;

function handler($event, $context)
{
	$package_dir = $_ENV['PackageDir'];
	$filename = $_ENV['FileName'];
	$source = '/tmp/' . $filename;
	$dest = $filename;

	$cmd = sprintf('tar -cpzf %s --numeric-owner --ignore-failed-read %s', $source, $package_dir);
	exec($cmd);

	echo 'Zipping done! Uploading...' . PHP_EOL;

	$endpoint = $_ENV['OSSEndpoint'];
	$bucket = $_ENV['Bucket'];

	echo 'endpoint: ' . $endpoint . PHP_EOL;
	echo 'bucket: ' . $bucket . PHP_EOL;

	$accessKeyId = $context["credentials"]["accessKeyId"];
	$accessKeySecret = $context["credentials"]["accessKeySecret"];
	$securityToken = $context["credentials"]["securityToken"];

	$ossClient = new OssClient($accessKeyId, $accessKeySecret, $endpoint, false, $securityToken);
	$handle = fopen($source, "r");
	$contents = fread($handle, filesize($source));
	fclose($handle);
	$ossClient->putObject($bucket, $dest, $contents);

	return 'Zipping done and uploading done!';
}
