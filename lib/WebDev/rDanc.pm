package WebDev::rDanc;
use Dancer ':syntax';

our $VERSION = '0.1';

# Wow, how should I start?

get '/' => sub {
    template 'index';
};

true;
