use warnings;
use strict;

use App::CopyrightImage;

imgcopyright(
    image => '/home/steve02/Pictures',
    check => 1,
);
__END__
imgcopyright(
    '/home/steve02/Pictures', 
    name => 'Steve Bertrand', 
    email => 'steveb@cpan.org',
);

