package App::CopyrightImage;

use 5.006;
use warnings;
use strict;

use Exporter qw(import);
use File::Basename;
use File::Find::Rule;
use Image::ExifTool qw(:Public);

our @EXPORT = qw(imgcopyright);

our $VERSION = '0.01';

sub imgcopyright {
    my (%data) = @_;

    die "need an image entry!\n" if ! $data{src};

    $data{year} = (localtime(time))[5] + 1900;

    if ($data{dst} && -d $data{dst}){
        $data{basename} = $data{dst};
    }
    elsif (-d $data{src})
    {
        $data{basename} = $data{src};
    }
    else {
        $data{basename} = basename $data{src};
    }

    if (-d $data{src}){
        @{ $data{images} } = File::Find::Rule->file()
                                     ->name('*.jpg', '*.jpeg')
                                     ->maxdepth(1)
                                     ->in($data{src});
    }
    else {
        push @{ $data{images} }, $data{src};
    }

    if ($data{check}){
        return _check(\%data);
    }
    else {
        _exif(\%data);
    }
}
sub _exif {
    my $data = shift; 

    my $dst = "$data->{basename}/ci";

    if (! -d $dst){
        mkdir $dst
          or die "can't create the destination image directory $dst!: $!";
    }

    my $et = Image::ExifTool->new;
    my %errors;

    for my $img (@{ $data->{images} }){

        # original
        
        my $et = Image::ExifTool->new;
        $et->ExtractInfo($img);
        my $cp = $et->GetValue('Copyright');
        my $cr = $et->GetValue('Creator');

        if (! $data->{force}){
            my $set = "Copyright is already set;" if $cp;
            $set .= " Creator is already set;" if $cr;
            $errors{$img} = $set;
            next;
        }
        
        $et->SetNewValue('Copyright', "Copyright (C) $data->{year} by $data->{name}");
        my $creator_string = $data->{name};
        $creator_string .= " ($data->{email})" if $data->{email};

        $et->SetNewValue('Creator', $creator_string);

        my $ci_img = (fileparse($img))[0];
        $ci_img = "$dst/ci_$ci_img";
       
        # write out the new image

        $et->WriteInfo($img, $ci_img);

        # updated

        $et->ExtractInfo($ci_img);

        $errors{$img} .= "failed to add Copyright; "
          if ! $et->GetNewValue('Copyright');

        $errors{$img} .= "failed to add Creator"
          if ! $et->GetNewValue('Creator');
    }
    return %errors;
}
sub _check {
    my $data = shift;

    my $et = Image::ExifTool->new;

    for (@{ $data->{images} }){
        $et->ExtractInfo($_);
        my $cp = $et->GetValue('Copyright');
        my $cr = $et->GetValue('Creator');

        my $err_str;
        $err_str .= " missing Copyright; " if ! $cp;
        $err_str .= " missing Creator; " if ! $cr;

        print "$_: $err_str\n" if $err_str;
    }
    return ();
}

1;
__END__

=head1 NAME

App::CopyrightImage - Easily add Copyright information to your images

=head1 DESCRIPTION

This module is the API backend for the C<imgcopyright> script that it installs.

=head1 SYNOPSIS

    use App::CopyrightImage;

    imgcopyright(
        image => 'home/user/pictures', # file or dir
        name  => 'Steve Bertrand',
        email => 'steveb@cpan.org',
    );

=head1 EXPORTS

Exports C<imgcopyright> by default.

=head1 FUNCTIONS

=head2 imgcopyright(%opts)

Sets up various configurations, and then executes the EXIF changes to images
sent in.

We set the C<Copyright> EXIF tag to C<Copyright (C) YEAR by NAME>, where 
C<YEAR> is auto-generated, and C<NAME> is sent in as an option (see below).

We also set the C<Creator> EXIF tag to C<NAME (EMAIL)>. If C<EMAIL> is not
sent in as an option, it, and the parens around it will be omitted.

Returns a hash reference with the following keys: C<ok> and C<fail>. Each key
contains an array reference. The former contains a list of the image names
that succeeded, and the latter, a list of image names that failed.

Options:

=head3 image

A string containing either an image filename (including full path if not
local), or the name of a directory containing images. If the value is a
directory, we'll operate on all images in that dir.

We will, by default, create a new sub-directory named C<ci> in the directory 
found in the value, and if the directory is current working directory, we'll 
create the sub directory there.

All updated images will be copied into the new C<ci> directory with the same
filename, with a <C>ci_</c> prepended to it.

Eg: C<"/home/user/Pictures">

=head3 check

We won't make any changes, we'll simply check all images specified with the
C<image> option, and if they are missing either C<Copyright> or C<Creator>
EXIF data, we'll print this information to C<STDOUT>.

=head3 name

A string containing the name you want associated with the copyright notice. It
will be used in both the C<Copyright> and C<Creator> EXIF tags.

Eg: C<"Steve Bertrand">

=head3 email

A string containing the email address of the copyright holder. This will be
included in the C<Creator> EXIF tag if sent in.

Eg: C<"steveb@cpan.org">

=head3 dst

A string containing the name of a directory to be used to store the manipulated
images. By default, we use the path sent in with the C<image> option.

Eg: C<"/home/user/backup">

=head1 AUTHOR

Steve Bertrand, C<< <steveb at cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2016 Steve Bertrand.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.
