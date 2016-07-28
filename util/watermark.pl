use warnings;
use strict;

use Image::Magick;

my $base = Image::Magick->new();
$base->Read('./updated.jpg');
my ($width, $height) = $base->Get('width', 'height');

my $watermark = Image::Magick->new();
$watermark->Set(size => "${width}x${height}");
$watermark->ReadImage('xc:white');
$watermark->Transparent( color => 'white' );
$watermark->Annotate(pointsize => 72,
                     fill      => 'white',
                     text      => '2016 (C) Steve Bertrand',
                     gravity   => 'southeast');

$watermark->Composite(image   => $base,
                      compose => 'Plus',
                      gravity => 'Center');

$watermark->Write('./composition.jpg');
#$watermark->Display;

