#!/usr/bin/perl -w

use lib '.';
use strict;
use Vigenere;

my $salt = "helloworld";
my $plain = "vigenerecipherisbeautiful";
my $vigenere = new Vigenere($salt);
my $cipher = $vigenere->encrypt($plain);
my $original = $vigenere->decrypt($cipher);

printf "plain=%s, salt=%s, cipher=%s\n", $plain, $salt, $cipher;
printf "cipher=%s, salt=%s, original=%s\n", $cipher, $salt, $original;
