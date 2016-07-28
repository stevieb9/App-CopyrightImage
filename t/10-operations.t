use warnings;
use strict;

use App::CopyrightImage;
use Hook::Output::Tiny;
use Image::ExifTool qw(:Public);
use Test::More;
use lib 't/';
use Testing;

my $t = Testing->new;
my $o = Hook::Output::Tiny->new;
my $e = Image::ExifTool->new;

{ # single no-copy
    my %err = imgcopyright(src => $t->base, name => 'steve');

    is keys %err, 0, "no output on check with no exif";

    my $dir = $t->build ."/ci";
    my $img = "$dir/ci_base.jpg";

    is -d $dir, 1, "ci dir created ok";
    is -f $img, 1, "ci/ci_base.jpg created ok";

    $e->ExtractInfo($img);
    like 
        $e->GetValue('Copyright'), 
        qr/Copyright \(C\) \d{4} by steve/,
        "copyright ok";

    like 
        $e->GetValue('Creator'), 
        qr/steve/, 
        "creator ok";

    my @files = glob "$dir/*";
    is @files, 1, "only one file when copyrighting a single file";

    $t->clean;
}

{ # multi copy + no-copy

    my %err = imgcopyright(src => $t->build, name => 'steve');

    is keys %err, 1, "single line of output with one already copy file";
    like $err{$t->build .'/copyr.jpg'}, qr/Copyright/, "copyright already added ok";
    like $err{$t->build .'/copyr.jpg'}, qr/Creator/, "creator already added ok";

    my $dir = $t->build ."/ci";
    my $img = "$dir/ci_base.jpg";

    is -d $dir, 1, "ci dir created ok";
    is -f $img, 1, "ci/ci_base.jpg created ok";

    $e->ExtractInfo($img);
    like 
        $e->GetValue('Copyright'), 
        qr/Copyright \(C\) \d{4} by steve/,
        "copyright ok";

    like 
        $e->GetValue('Creator'), 
        qr/steve/, 
        "creator ok";

    my @files = glob "$dir/*";
    is @files, 1, "only one file when copyrighting a single file";

    $t->clean;
}



done_testing();
