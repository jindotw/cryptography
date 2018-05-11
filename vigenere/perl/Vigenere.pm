package Vigenere;

my %alpha = (
	a => 1,  b => 2,  c => 3,  d => 4,  e => 5,
	f => 6,  g => 7,  h => 8,  i => 9,  j => 10,
	k => 11, l => 12, m => 13, n => 14, o => 15,
	p => 16, q => 17, r => 18, s => 19, t => 20,
	u => 21, v => 22, w => 23, x => 24, y => 25,
	z => 26
);

# initialize the alpha array with the first element being a place holder
my @alpha = ('');
# populate the alpha array by referring to the alpha hash
map { $alpha[$alpha{$_}] = $_; } keys %alpha;

# alpha array will look like this
#my @alpha = (
#	'', #placeholder as the alpha array is index 1-based
#	'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
#	'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
#);

sub new {
	my $class = shift;
	my $salt = shift;
	my $self = {};

	bless $self, $class;
	$self->setSalt($salt);

	return $self;
}

sub setSalt {
	my $self = shift;
	my $salt = shift;

	my $saltArr = &__salt__($salt);
	if (defined $saltArr) {
		$self->{saltArr} = $saltArr;
		return 1;
	}

	return 0;
}

sub __salt__ {
	my $text = shift;

	# sanity check
	return undef unless defined $text && length($text)>0;
	croak("$text contains non-alpha character") unless ($text =~ m/^[a-zA-Z]+$/);
	$text =~ tr/A-Z/a-z/;

	my @saltArr = ();
	foreach my $char (split(//, $text)) {
		my $idx = $alpha{$char};
		push(@saltArr, $alpha{$char});
	}

	return \@saltArr;
}

sub encrypt {
	my $self = shift;
	my $plainText = shift;

	croak("only alpha characters are permitted") unless ($plainText =~ m/^[a-zA-Z]+$/);
	$plainText =~ tr/A-Z/a-z/;

	# the -1 operation is due to the @alpha array being 1-based index
	my $alphaLen = scalar(@alpha) - 1;
	my $saltLen = scalar(@{$self->{saltArr}});
	my $pos = 0;
	my @cipher = ();
	foreach my $char (split(//, $plainText)) {
		my $currPos = $alpha{$char};
		my $shiftBy = $self->{saltArr}->[$pos];
		my $newPos = $currPos + $shiftBy;
		$newPos = $newPos > $alphaLen ? $newPos - $alphaLen : $newPos;
		my $newChar = $alpha[$newPos];
		push(@cipher, $newChar);

		#printf "curr=%d, shift=%d, newPos=%d, origChar=%s, newchar=%s\n", $currPos, $shiftBy, $newPos, $char, $newChar;

		$pos = 0 if (++$pos >= $saltLen);
	}

	return join("", @cipher);
}

sub decrypt {
	my $self = shift;
	my $cipher = shift;

	croak("only alpha characters are permitted") unless ($cipher =~ m/^[a-zA-Z]+$/);
	$cipher =~ tr/A-Z/a-z/;
	# the -1 operation is due to the @alpha array being 1-based index
	my $alphaLen = scalar(@alpha) - 1;
	my $saltLen = scalar(@{$self->{saltArr}});
	my $pos = 0;
	my @plain = ();

	foreach my $char (split(//, $cipher)) {
		my $currPos = $alpha{$char};
		my $shiftBy = $self->{saltArr}->[$pos];
		my $newPos = $currPos - $shiftBy;
		$newPos = $newPos < 0 ? $alphaLen + $newPos : $newPos;
		my $newChar = $alpha[$newPos];
		push(@plain, $newChar);

		#printf "curr=%d, shift=%d, newPos=%d, origChar=%s, newchar=%s\n", $currPos, $shiftBy, $newPos, $char, $newChar;

		$pos = 0 if (++$pos >= $saltLen);
	}

	return join("", @plain);
}

1;
