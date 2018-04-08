# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl BAS-Plex-Import.t'

#########################

use strict;
use warnings;
use Data::Dumper;

use Test::More;
use Test::Carp;
use BAS::Plex::Import;
BEGIN { use_ok('BAS::Plex::Import') };
BEGIN { use_ok('Video::Filename') };
BEGIN { use_ok('File::Path')};
BEGIN { use_ok('File::Copy')};
BEGIN { use_ok('Cwd')};
BEGIN { use_ok('Carp')};

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

diag "\nCreate Testing Object BAS::Plex::Import";
my $obj = BAS::Plex::Import->new();
isa_ok($obj, 'BAS::Plex::Import');

diag "\nCheck default Countries value\n";
ok($obj->countries() =~ m/\(UK\|US\)/, "countries is (UK|US)");

diag "Change countries to new value";
ok($obj->countries("USA") =~ m/USA/, "countries is now equal to USA");

diag "Destroy and recreate test obj with default countries values for testing purposes\n";
$obj = undef;
$obj = BAS::Plex::Import->new();

diag "\nSet Source dir and invalid source dir as well as TV Show dir";
my $sourceDir = getcwd . '/t/test-data/';
my $sourceDirInValid = $sourceDir . 't/invalid';

my $ShowDirectory = getcwd . '/t/TV Shows';

diag "Obj knows showFolder path\n";
can_ok ($obj, 'showFolder');
diag "Obj Show Folder is undefined\n";
is ($obj->showFolder, undef, "TV Show Directory is undefined as expected");
diag "Set showFolder path\n";
$obj->showFolder($ShowDirectory);
ok($obj->showFolder =~ m/$ShowDirectory/, "Destination directory as be set as expected and is valid");

diag "Check that we can handle an invalid path for TV Shows folder and returns undef\n";
my $invalidshowFolder = BAS::Plex::Import->new();
$invalidshowFolder->showFolder($sourceDirInValid);
is($invalidshowFolder->showFolder, undef, "Passed invalid path should be undef");

can_ok ($obj, 'newShowFolder');
is ($obj->newShowFolder, undef, "New TV Show download folder is undefined as expected");

diag "Set Download folder to a valid path\n";
$obj->newShowFolder($sourceDir);
ok($obj->newShowFolder =~ m/$sourceDir/, "Download path is set and is valid");

my $invalidnewDownloads = BAS::Plex::Import->new();
$invalidnewDownloads->newShowFolder($sourceDirInValid);
is($invalidnewDownloads->newShowFolder, undef, "Passed invalid path should be undef");

done_testing();
