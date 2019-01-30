#!/usr/bin/perl -w
########################################################################
#
# Project: Energie converter
#
# File: econv
#
# Description: Small command prompt energy converter
#
#       Values from:
#       P. J. Mohr, B. N. Taylor, D. B. Newell, 
#           J. Phys. Chem. Ref. Data, Vol 41, No. 4 2012 043109-1
#
# Author: Dennis Barton
#
# Date: 03/17/2015
#
# Copyright © Dennis Barton 2014
# ALL RIGHTS RESERVED
#
########################################################################
use strict;
use Scalar::Util qw(looks_like_number);

# fundamental constants
my %con = (
    N_A         => 6.02214129e23    ,   #Avogardo constant
    c           => 2.99792458e8     ,   #Speed of light
    h           => 6.62606957e-34   ,   #Planck's constant
    pi          => 3.14159265359    ,   #pi
    e           => 1.602176565e-19  ,   #elementary charge
    k           => 1.3806488e-23    ,   #Boltzmann constant
    u           => 1.660538921e-27  ,   #unified atomic mass unit
    cal         => 4.184            ,   #Calories in Joule
    har         => 4.35974434e-18   ,   #atomic unit of energy
    ryd         => 2.179872e-18     ,   #Rydberg constant
);
########################################################################
# definitions of units
my @defunits=(
# Units of energy
#key    long name            short name      conversion to Joule
['J'  ,'Joule'                 ,'J'        ,1                           ],
['har','Hartree (a.u.)'        ,'a.u.'     ,$con{har}                   ],
['eV' ,'Electronvolt'          ,'eV'       ,$con{e}                     ],
['cm1','Wavenumbers'           ,'1/cm'     ,$con{h}*$con{c}*100         ],
['kjm','Kilojoule per mole'    ,'kJ/mol'   ,1e3/$con{N_A}               ],
['kcm','Kilocalories per mole' ,'kcal/mol' ,1e3*$con{cal}/$con{N_A}     ],
['ryd','Rydberg'               ,'ryd'      ,$con{ryd}                   ],
['Hz' ,'Hertz'                 ,'Hz'       ,$con{h}                     ],
['K'  ,'Kelvin'                ,'K'        ,$con{k}                     ],
);
my %units=();
foreach (@defunits) {
    $units{@$_[0]}={long=>@$_[1],short=>@$_[2],toSI=>@$_[3],fromSI=>1/@$_[3]}; 
}
########################################################################
# Show possible units
sub showunit {
    print " possible units:\n";
    foreach (sort keys %units) {
        printf "    %-7s  $units{$_}{long}\n",$_;
    }
}
########################################################################
# Show conversions
sub showconversions {
    # Convert value to Joule
    my $SI=$_[0]*$units{$_[1]}{toSI};
    printf "\n      Conversion from $_[0] $units{$_[1]}{short} to:\n";
    printf "    ------------------------------\n";
    foreach my$unit (sort keys %units) {
        if ($unit eq $_[1]) {next};
        printf "\t%-12.6G $units{$unit}{short}\n", $SI*$units{$unit}{fromSI};
    }
}
########################################################################
#
# MAIN
#
my $value;
my $unit;
if(!defined $ARGV[0]) {
    print " usage: econv <value> <unit>\n  or: econv <unit>\n\n";
    showunit();
    exit 0;
}
elsif(not looks_like_number($ARGV[0]) and !exists($units{$ARGV[0]})) {
    print "ERROR: first argument has to be a number or an unit\n";
    showunit();
    exit 0;
}
elsif(exists($units{$ARGV[0]})) {
    $value = 1;
    $unit = $ARGV[0];
}
elsif(!defined($ARGV[1])) {
    $value = $ARGV[0];
    $unit ='har';
}
elsif(!exists($units{$ARGV[1]})) {
    print "ERROR: unit $ARGV[1] not implemented yet or is crab!.\n";
    showunit();
    exit 1;
}
else{
    $value = $ARGV[0];
    $unit = $ARGV[1];
}
# Show conversions
showconversions($value,$unit);




