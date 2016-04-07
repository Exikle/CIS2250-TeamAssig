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
#                 Santiago Gutierrez (0895285)(Did not even code anything, if this is still here by the time it is handed it, it is proof he didn't even look at the code)
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
my $COMMA       = q{,};


my $startingYear    = "";
my $endingYear      = "";


my $csv = Text::CSV->new({ sep_char => $COMMA});

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
    print "2. Value Compare[field specific] or [field specific] has [least/most] occurences in [field specific] in [period]".$NEW_LINE;
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
    return (@years);
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
    my $continue = $FALSE;
    my @years = $_[0];
    my $fieldOneComp;
    my $fieldTwoComp;
    my $maxFlag;
    my $fieldOfComp;
    clearScreen();
    print "Please select the field for the first block [All fields are in user manual]".$NEW_LINE;
    print "[FIELD SPECIFIC] or [Field specific] has [least/most] occurences in [general field] from ".$years[0]."-".$years[1].$NEW_LINE.$NEW_LINE;
    $fieldOneComp = getField();
    clearScreen();
    print "Please select the field for the second block [All fields are in the user manual]".$NEW_LINE;
    print "[".$fieldOneComp."]"." or [FIELDSPECIFIC] has [least/most] occurences in [general field] from ".$years[0]."-".$years[1].$NEW_LINE.$NEW_LINE;
    $fieldTwoComp = getField();
    clearScreen();
    print "Are you looking for [M]ost or [L]east?".$NEW_LINE;
    do {
        $maxFlag = <STDIN>;
        $maxFlag = lc($maxFlag);
        if (($maxFlag != "m")&&($maxFlag != "l")) {
            print "NOT A VALID CHOICE".$NEW_LINE;
        }
    } while (($maxFlag != "M")&&($maxFlag != "m")&&($maxFlag != "l")&&($maxFlag != "L"));
    print "Please select the field for the last block [All fields are in the user manual]".$NEW_LINE;
    if ($maxFlag == "m")
    {
        print "[".$fieldOneComp."]"." or [".$fieldTwoComp."] has most occurences in [GENERAL FIELD] from ".$years[0]."-".$years[1].$NEW_LINE.$NEW_LINE;
    }
    else
    {
        print "[".$fieldOneComp."]"." or [".$fieldTwoComp."] has most occurences in [GENERAL FIELD] from ".$years[0]."-".$years[1].$NEW_LINE.$NEW_LINE;
    }
    $fieldOfComp = getField();

    return;
}

sub validateField {
    my $field = $_[0];
    switch ($field) {
    case "Death:TotalNumber" { return(1) }
    case "Death:MoD" { return(1) }
    case "Death:DoW" { return(1) }
    case "Death:Age" { return(1) }
    case "Death:Sex" { return(1) }
    case "Death:Race" { return(1) }
    case "Death:MaritalStatus" { return(1) }
    case "Death:Education03" { return(1) }
    case "Death:Education89" { return(1) }
    case "Death:ResidentStatus" { return(1) }
    case "Death:PoD" { return(1) }
    case "Death:Injury" { return(1) }
    case "Death:MethodOfDisposition" { return(1) }
    case "Death:Autopsy" { return(1) }
    case "Death:ICD" { return(1) }
    case "Death:Sex:Male" { return(1) }
    case "Death:Sex:Female" { return(1) }
    case "Death:ResidentStatus:Resident" { return(1) }
    case "Death:ResidentStatus:ForeignResident" { return(1) }
    case "Death:MoD:January" { return(1) }
    case "Death:Mod:February" { return(1) }
    case "Death:Mod:March" { return(1) }
    case "Death:Mod:April" { return(1) }
    case "Death:Mod:May" { return(1) }
    case "Death:Mod:June" { return(1) }
    case "Death:Mod:July" { return(1) }
    case "Death:Mod:August" { return(1) }
    case "Death:Mod:September" { return(1) }
    case "Death:Mod:October" { return(1) }
    case "Death:Mod:November" { return(1) }
    case "Death:Mod:December" { return(1) }
    case "Death:DoW:Monday" { return(1) }
    case "Death:DoW:Tuesday" { return(1) }
    case "Death:DoW:Wednesday" { return(1) }
    case "Death:DoW:Thursday" { return(1) }
    case "Death:DoW:Friday" { return(1) }
    case "Death:DoW:Saturday" { return(1) }
    case "Death:DoW:Sunday" { return(1) }
    case "Death:MaritalStatus:Single" { return(1) }
    case "Death:MaritalStatus:Married" { return(1) }
    case "Death:MaritalStatus:Widowed" { return(1) }
    case "Death:MaritalStatus:Divorced" { return(1) }
    case "Death:Education03:8thOrLess" { return(1) }
    case "Death:Education03:9TO12Drop" { return(1) }
    case "Death:Education03:HSgrad" { return(1) }
    case "Death:Education03:CollegeNoDegree" { return(1) }
    case "Death:Education03:AssociateDegree" { return(1) }
    case "Death:Education03:BachelorDegree" { return(1) }
    case "Death:Education03:MasterDegree" { return(1) }
    case "Death:Education03:DoctorateDegree" { return(1) }
    case "Death:Education89:None" { return(1) }
    case "Death:Education89:1YearHS" { return(1) }
    case "Death:Education89:2YearHS" { return(1) }
    case "Death:Education89:3YearHS" { return(1) }
    case "Death:Education89:4YearHS" { return(1) }
    case "Death:Education89:1YearCollege" { return(1) }
    case "Death:Education89:2YearCollege" { return(1) }
    case "Death:Education89:3YearCollege" { return(1) }
    case "Death:Education89:4YearCollege" { return(1) }
    case "Death:Education89:5MoreYearCollege" { return(1) }
    case "Death:MethodOfDispositon:Burial" { return(1) }
    case "Death:MethodOfDispositon:Cremation" { return(1) }
    case "Death:MethodOfDispositon:Other" { return(1) }
    case "Death:MethodOfDispositon:Unkown" { return(1) }
    case "Death:MoD:Accident" { return(1) }
    case "Death:MoD:Suicide" { return(1) }
    case "Death:MoD:Homocide" { return(1) }
    case "Death:MoD:PendingInvestigation" { return(1) }
    case "Death:MoD:SelfInflicted" { return(1) }
    case "Death:MoD:Natural" { return(1) }
    case "Death:MoD:NotSpecified" { return(1) }
    case "Death:PoD:Home" { return(1) }
    case "Death:PoD:School" { return(1) }
    case "Death:PoD:AthleticsArea" { return(1) }
    case "Death:PoD:Street" { return(1) }
    case "Death:PoD:Industrial" { return(1) }
    case "Death:PoD:Farm" { return(1) }
    case "Death:Age:Years" { return(1) }
    case "Death:Race:White" { return(1) }
    case "Death:Race:Black" { return(1) }
    case "Death:Race:AmericanIndian" { return(1) }
    case "Death:Race:Chinese" { return(1) }
    case "Death:Race:Japanese" { return(1) }
    case "Death:Race:Hawaiian" { return(1) }
    case "Death:Race:Filipino" { return(1) }
    case "Death:Race:AsianIndian" { return(1) }
    case "Death:Race:Korean" { return(1) }
    case "Death:Race:Samoan" { return(1) }
    case "Death:Race:Vietnamese" { return(1) }
    case "Death:Race:Guamanian" { return(1) }
    case "Death:" { return(1) }
    case "Birth:Sex" { return(1) }
    case "Birth:Child:Birthweight" { return(1) }
    case "Birth:Child:TimeOfBirth" { return(1) }
    case "Birth:Child:DoW" { return(1) }
    case "Birth:Mom:Age" { return(1) }
    case "Birth:Mom:Race" { return(1) }
    case "Birth:Mom:MaritalStatus" { return(1) }
    case "Birth:Mom:Education" { return(1) }
    case "Birth:TotalBirthOrder" { return(1) }
    case "Birth:BirthInterval" { return(1) }
    case "Birth:Father:Age" { return(1) }
    case "Birth:Father:Race" { return(1) }
    case "Birth:Father:Education" { return(1) }
    case "Birth:MethodOfDelivery" { return(1) }
    case "Birth:Child:Number" { return(1) }
    case "Birth:Attendant" { return(1) }
    case "Birth:PlaceOfDelivery" { return(1) }
    case "Birth:Child:Male" { return(1) }
    case "Birth:Child:Female" { return(1) }
    case "Birth:DoW:Monday" { return(1) }
    case "Birth:DoW:Tuesday" { return(1) }
    case "Birth:DoW:Wednesday" { return(1) }
    case "Birth:DoW:Thursday" { return(1) }
    case "Birth:DoW:Friday" { return(1) }
    case "Birth:DoW:Saturday" { return(1) }
    case "Birth:DoW:Sunday" { return(1) }
    case "Birth:PlaceOfDelivery:Hospital" { return(1) }
    case "Birth:PlaceOfDelivery:FreeStandingBirthCenter" { return(1) }
    case "Birth:PlaceOfDelivery:HomeIntended" { return(1) }
    case "Birth:" { return(1) }
    case "Birth:" { return(1) }
    case "" { return(1) }
    case "" { return(1) }
    case "" { return(1) }
    case "" { return(1) }
    case "" { return(1) }






    }
    return;
}

sub getField{
    my $continue = $FALSE;
    my $INVALID_FIELD = "Not a valid field, try again.";

    do {
        $field = <STDIN>;
        if (validateField($field) == 1)
        {
            $continue = $TRUE;
        }
        else
        {
            print $INVALID_FIELD.$NEW_LINE;
        }
    } while ($continue == $FALSE);
    return($field);
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
