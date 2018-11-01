<?php

$counter = 0;
function initializer($context) {
    global $counter;
    $counter += 1;
    echo  $counter . PHP_EOL;
}

function handler($event, $context) {
    global $counter;
    $counter += 2;
    echo  $counter . PHP_EOL;
    return $counter;
}
?>