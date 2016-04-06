#!/usr/bin/perl
#
#   Packages and modules
#
use strict;
use warnings;
use version;   our $VERSION = qv('5.16.0');   # This is the version of Perl to be used
use Text::CSV  1.32;   # We will be using the CSV module (version 1.32 or higher)
# to parse each line
use Switch;

#
#   cis2250project.pl
#      Author(s): Dickson D'Cunha (0904177),
#                 Alejandro Lobo Mujica (0911715)
#                 Santiago Gutierrez (0895285)
#                 Henry Nguyen (0884653)
#      Project: Cis 2250's Final Deliverable
#      Date of Last Update: Tuesday March 29th, 2016
#
#      Functional Summary
#
#      Commandline Parameters: 1
#         $ARGV[0] = name of the input file containing the names
#
#      References
#         Name files from http://www.ssa.gov/OACT/babynames/limits.html
#

############
# Global Variables
#

my $TRUE        = 1;
my $FALSE       = 0;
my $NEW_LINE    = "\n";
my $SPACE       = " ";

my $startingYear    = "";
my $endingYear      = "";


############
# Running Program
#
main();


############
# Subroutines
#

sub main{
    my $template;
    my @years;
    clearScreen();
    @years = getYearRange();
    clearScreen();
    $template = startUserChoices();
    switch ($template)
    {
        case 1 {
         valMaxMin(@years);
        }
        case 2 {
         valComp(@years);
        }
        case 3 {
         valGet(@years);
        }
        case 4 {
         trend(@years);
        }
    }
    return;
}

sub startUserChoices {
    my $choice = 1;
    my $validChoice = $TRUE;



    do{
        $validChoice = $TRUE;

        printOptions();

        print "Choice?: ";
        $choice = <STDIN>;

        switch($choice){
            case 1 {
              print "One chosen".$NEW_LINE;
            }
            case 2 {
              print "Two chosen".$NEW_LINE ;
            }
            case 3 {
              print "Three chosen".$NEW_LINE ;
            }
            case 4 {
              print "Four chosen".$NEW_LINE ;
            }
            case 5 {
              print "Five chosen".$NEW_LINE ;
            }
            case 6 {
              print "Six chosen".$NEW_LINE ;
            }
            case 7 {
              print "Etc chosen".$NEW_LINE ;
            }
            else {
                $validChoice = $FALSE;
                print "Invalid choice".$NEW_LINE;
            }

        }
    }while($validChoice == $FALSE);
    return($choice);
}

sub printOptions{
    print "1. Value Max/Min [Least/Most] [deaths or [field specific]] in [field specific] between [period]".$NEW_LINE;
    print "2. Value Compare[field specific] or [field specific] has [least/most] in [field specific] in [period]".$NEW_LINE;
    print "3. Value Get [field specific], happenec with [field specific] happened with [field specific]... in [period]".$NEW_LINE;
    print "4. Trend [field specific] and [field specific] over [period]".$NEW_LINE;
    print "5. Option five".$NEW_LINE;
    print "6. Option six".$NEW_LINE;
    print "7. Etc".$NEW_LINE;
    return;
}

sub getYearRange{
    my @years;
    my $continue = $FALSE;
    print "Choose the range of years you would like to examine (Min: 1994 - Max: 2014).\n";

    do {
        print "Starting year:";
        $startingYear = <STDIN>;
        $continue = validateStartYear($startingYear);

        if($continue == $FALSE){
            print "Invalid start year. Must be in the range of 1994 to 2014.".$NEW_LINE;
        }

    } while($continue == $FALSE);
    chomp $startingYear;
    $years[0] = $startingYear;
    do {
        print "Ending year:";
        $endingYear = <STDIN>;
        $continue = validateEndYear($endingYear);

        if($continue == $FALSE){
            print "Invalid start year. Must be in the range of ".$startingYear." to 2014.".$NEW_LINE;
        }

    } while($continue == $FALSE);

    chomp $endingYear;
    $years[1] = $endingYear;
    # print $startingYear." ".$endingYear.$NEW_LINE;
    return (@endingYear);
}

sub validateStartYear{
    my $year = $_[0];

    if ($year =~ /^[0-9,.E]+$/){}
    else { return $FALSE; }

    if($year < 1994){
        return $FALSE;
    }
    elsif($year > 2014){
        return $FALSE;
    }
    else{
        return $TRUE
    }
}

sub validateEndYear{
    my $year = $_[0];

    if ($year =~ /^[0-9,.E]+$/){}
    else { return $FALSE; }

    if($year < $startingYear){
        return $FALSE;
    }
    elsif($year > 2014){
        return $FALSE;
    }  
    else{
        return $TRUE
    }
}

sub clearScreen{
    system("clear");
    return;
}




sub valMaxMin{
    my @years = $_[0];
    clearScreen();
    #todo
    return;
}

sub valComp{
    my $continue = $false;
    my @years = $_[0];
    my $fieldOneComp;
    my $fieldTwoComp;
    my $maxFlag;
    my $fieldOfComp;
    clearScreen();
    print "Please select the field for the first block";
    print "[Field specific] or [Field specific] has [least/most] in [field specific] from ".$years[0]."-".$years[1].$NEW_LINE.$NEW_LINE;
    
    return;
}

sub valGet{
    my @years = $_[0];
    clearScreen();
    #todo
    return;

}

sub trend{
    my @years = $_[0];
    clearScreen();
    #todo
    return;
}

# TODO
# Present users 
# Get user input for which template they want to use
