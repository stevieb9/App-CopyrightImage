use warnings;
use strict;

use feature 'say';

use Data::Dumper;
use Image::ExifTool qw(:Public);

my $et = Image::ExifTool->new;

my $img = 'base.jpg';
$et->SetNewValue('Copyright', 'Copyright (C) 2016 by Steve Bertrand');
$et->SetNewValue('Creator', 'Steve Bertrand (steve.bertrand@gmail.com)');
$et->WriteInfo($img, 'updated.jpg');

$et->ExtractInfo('updated.jpg');

say $et->GetValue('Copyright');
say $et->GetValue('Creator');
