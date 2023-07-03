package optlong;

use strict;
use warnings;

use lib 't';

use LuaTest;
use base qw[ LuaTest ];

use Lua::API;
use Test::Most;
bail_on_fail;


sub testfunc {

    my $L = shift;

    my $exp = $L->tointeger(1);
    my $def = $L->tointeger(2);
    my $num = $L->optlong( 3, $def );

    is( $num, $exp, md( 3, 'passed value' ) );
}


sub test_ok : Test( 2 ) {

    my $L = shift->{L};

    $L->pushinteger( 4 );
    $L->pushinteger( 3 );
    $L->pushinteger( 4 );

    my $ret = $L->pcall( 3, 0, 0 );
    is( $ret, 0, md 'return' );
}

sub test_nil : Test( 2 ) {

    my $L = shift->{L};

    $L->pushinteger( 3 );
    $L->pushinteger( 3 );
    $L->pushnil;
    my $ret = $L->pcall( 3, 0, 0 );
    is( $ret, 0, md 'return' );
}

sub test_nok : Test( 3 ) {

    my $L = shift->{L};

    $L->pushinteger( 3 );
    $L->pushinteger( 3 );
    $L->pushlightuserdata( {} );
    my $ret = $L->pcall( 3, 0, 0 );
    is( $ret, Lua::API::ERRRUN, md 'return' );
    is( $L->gettop, 1, md 'stack' );
    like( $L->tostring(-1), qr/bad argument #3/i, md 'message' );
    $L->pop(1);
}


1;
