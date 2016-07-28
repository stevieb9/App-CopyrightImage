use warnings;
use strict;

use App::CopyrightImage;

imgcopyright(
    src => 't/build',
    name => 'steve',
);
__END__
imgcopyright(
    '/home/steve02/Pictures', 
    name => 'Steve Bertrand', 
    email => 'steveb@cpan.org',
);

