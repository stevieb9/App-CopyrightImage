use warnings;
use strict;

use App::CopyrightImage;

imgcopyright(
    src => 't/data/base.jpg',
#    name => 'steve',
    check => 1,
);
__END__
imgcopyright(
    '/home/steve02/Pictures', 
    name => 'Steve Bertrand', 
    email => 'steveb@cpan.org',
);

