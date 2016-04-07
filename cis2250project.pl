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
my $COMMA       = q{,};
my $INVALID_FIELD = "Not a valid field, try again.";



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
        $choice = readInput();

        switch($choice){
            print $choice;
            case 1 {
              print "One chosen".$NEW_LINE;
            }
            case "1"{
              print "One1 chosen".$NEW_LINE;
            }
            case '1'{
              print "One2 chosen".$NEW_LINE;
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
    my $RANGE_PROMPT = "Choose the range of years you would like to examine (Min: 1994 - Max: 2014).\n";
    my $YEAR_START_PROMPT = "Starting year:";
    my $YEAR_END_PROMPT = "Ending year:"
    my $INVALID_YEAR_PROMPT = "Invalid start year. Must be in the range of 1994 to 2014."
    my $INVALID_RANGE_PROMPT_X = "Invalid start year. Must be in the range of ";
    my $INVALID_RANGE_PROMPT_Y = " to 2014.";

    my @years;
    my $continue = $FALSE;


    print $RANGE_PROMPT;

    do {
        print $YEAR_START_PROMPT;
        $startingYear = readInput();
        $continue = validateStartYear($startingYear);

        if($continue == $FALSE){
            print $INVALID_YEAR_PROMPT.$NEW_LINE;
        }

    } while($continue == $FALSE);
    chomp $startingYear;
    $years[0] = $startingYear;
    do {
        print $YEAR_END_PROMPT;
        $endingYear = readInput();
        $continue = validateEndYear($endingYear);

        if($continue == $FALSE){
            print $INVALID_RANGE_PROMPT_X.$startingYear.$INVALID_RANGE_PROMPT_Y.$NEW_LINE;
        }

    } while($continue == $FALSE);

    chomp($endingYear);
    $years[1] = $endingYear;
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
    
    # ask first specific
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
        $maxFlag = lc(readInput());
        # $maxFlag = lc($maxFlag); # changes string to lower case
        if (($maxFlag != "m")&&($maxFlag != "l")) {
            print $INVALID_FIELD.$NEW_LINE;
        }
    } while (($maxFlag != "M")&&($maxFlag != "m")&&($maxFlag != "l")&&($maxFlag != "L"));

    print "Please select the field for the last block [All fields are in the user manual]".$NEW_LINE;
    if ($maxFlag == "m"){
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
    case "Death:TotalNumber" { return($TRUE) }
    case "Death:MoD" { return($TRUE) }
    case "Death:DoW" { return($TRUE) }
    case "Death:Age" { return($TRUE) }
    case "Death:Sex" { return($TRUE) }
    case "Death:Race" { return($TRUE) }
    case "Death:MaritalStatus" { return($TRUE) }
    case "Death:Education03" { return($TRUE) }
    case "Death:Education89" { return($TRUE) }
    case "Death:ResidentStatus" { return($TRUE) }
    case "Death:PoD" { return($TRUE) }
    case "Death:Injury" { return($TRUE) }
    case "Death:MethodOfDisposition" { return($TRUE) }
    case "Death:Autopsy" { return($TRUE) }
    case "Death:ICD" { return($TRUE) }
    case "Death:Sex:Male" { return($TRUE) }
    case "Death:Sex:Female" { return($TRUE) }
    case "Death:ResidentStatus:Resident" { return($TRUE) }
    case "Death:ResidentStatus:ForeignResident" { return($TRUE) }
    case "Death:MoD:January" { return($TRUE) }
    case "Death:Mod:February" { return($TRUE) }
    case "Death:Mod:March" { return($TRUE) }
    case "Death:Mod:April" { return($TRUE) }
    case "Death:Mod:May" { return($TRUE) }
    case "Death:Mod:June" { return($TRUE) }
    case "Death:Mod:July" { return($TRUE) }
    case "Death:Mod:August" { return($TRUE) }
    case "Death:Mod:September" { return($TRUE) }
    case "Death:Mod:October" { return($TRUE) }
    case "Death:Mod:November" { return($TRUE) }
    case "Death:Mod:December" { return($TRUE) }
    case "Death:DoW:Monday" { return($TRUE) }
    case "Death:DoW:Tuesday" { return($TRUE) }
    case "Death:DoW:Wednesday" { return($TRUE) }
    case "Death:DoW:Thursday" { return($TRUE) }
    case "Death:DoW:Friday" { return($TRUE) }
    case "Death:DoW:Saturday" { return($TRUE) }
    case "Death:DoW:Sunday" { return($TRUE) }
    case "Death:MaritalStatus:Single" { return($TRUE) }
    case "Death:MaritalStatus:Married" { return($TRUE) }
    case "Death:MaritalStatus:Widowed" { return($TRUE) }
    case "Death:MaritalStatus:Divorced" { return($TRUE) }
    case "Death:Education03:8thOrLess" { return($TRUE) }
    case "Death:Education03:9TO12Drop" { return($TRUE) }
    case "Death:Education03:HSgrad" { return($TRUE) }
    case "Death:Education03:CollegeNoDegree" { return($TRUE) }
    case "Death:Education03:AssociateDegree" { return($TRUE) }
    case "Death:Education03:BachelorDegree" { return($TRUE) }
    case "Death:Education03:MasterDegree" { return($TRUE) }
    case "Death:Education03:DoctorateDegree" { return($TRUE) }
    case "Death:Education89:None" { return($TRUE) }
    case "Death:Education89:1YearHS" { return($TRUE) }
    case "Death:Education89:2YearHS" { return($TRUE) }
    case "Death:Education89:3YearHS" { return($TRUE) }
    case "Death:Education89:4YearHS" { return($TRUE) }
    case "Death:Education89:1YearCollege" { return($TRUE) }
    case "Death:Education89:2YearCollege" { return($TRUE) }
    case "Death:Education89:3YearCollege" { return($TRUE) }
    case "Death:Education89:4YearCollege" { return($TRUE) }
    case "Death:Education89:5MoreYearCollege" { return($TRUE) }
    case "Death:MethodOfDispositon:Burial" { return($TRUE) }
    case "Death:MethodOfDispositon:Cremation" { return($TRUE) }
    case "Death:MethodOfDispositon:Other" { return($TRUE) }
    case "Death:MethodOfDispositon:Unkown" { return($TRUE) }
    case "Death:MoD:Accident" { return($TRUE) }
    case "Death:MoD:Suicide" { return($TRUE) }
    case "Death:MoD:Homocide" { return($TRUE) }
    case "Death:MoD:PendingInvestigation" { return($TRUE) }
    case "Death:MoD:SelfInflicted" { return($TRUE) }
    case "Death:MoD:Natural" { return($TRUE) }
    case "Death:MoD:NotSpecified" { return($TRUE) }
    case "Death:PoD:Home" { return($TRUE) }
    case "Death:PoD:School" { return($TRUE) }
    case "Death:PoD:AthleticsArea" { return($TRUE) }
    case "Death:PoD:Street" { return($TRUE) }
    case "Death:PoD:Industrial" { return($TRUE) }
    case "Death:PoD:Farm" { return($TRUE) }
    case "Death:Age:Years" { return($TRUE) }
    case "Death:Race:White" { return($TRUE) }
    case "Death:Race:Black" { return($TRUE) }
    case "Death:Race:AmericanIndian" { return($TRUE) }
    case "Death:Race:Chinese" { return($TRUE) }
    case "Death:Race:Japanese" { return($TRUE) }
    case "Death:Race:Hawaiian" { return($TRUE) }
    case "Death:Race:Filipino" { return($TRUE) }
    case "Death:Race:AsianIndian" { return($TRUE) }
    case "Death:Race:Korean" { return($TRUE) }
    case "Death:Race:Samoan" { return($TRUE) }
    case "Death:Race:Vietnamese" { return($TRUE) }
    case "Death:Race:Guamanian" { return($TRUE) }
    case "Birth:TotalNumber" { return($TRUE) }
    case "Birth:Sex" { return($TRUE) }
    case "Birth:Child:Birthweight" { return($TRUE) }
    case "Birth:Child:TimeOfBirth" { return($TRUE) }
    case "Birth:Child:Month" { return($TRUE) }
    case "Birth:Child:DoW" { return($TRUE) }
    case "Birth:Mom:Age" { return($TRUE) }
    case "Birth:Mom:Race" { return($TRUE) }
    case "Birth:Mom:MaritalStatus" { return($TRUE) }
    case "Birth:Mom:Education" { return($TRUE) }
    case "Birth:TotalBirthOrder" { return($TRUE) }
    case "Birth:BirthInterval" { return($TRUE) }
    case "Birth:Father:Age" { return($TRUE) }
    case "Birth:Father:Race" { return($TRUE) }
    case "Birth:Father:Education" { return($TRUE) }
    case "Birth:MethodOfDelivery" { return($TRUE) }
    case "Birth:Child:Number" { return($TRUE) }
    case "Birth:Attendant" { return($TRUE) }
    case "Birth:PlaceOfDelivery" { return($TRUE) }
    case "Birth:Child:Male" { return($TRUE) }
    case "Birth:Child:Female" { return($TRUE) }
    case "Birth:DoW:Monday" { return($TRUE) }
    case "Birth:DoW:Tuesday" { return($TRUE) }
    case "Birth:DoW:Wednesday" { return($TRUE) }
    case "Birth:DoW:Thursday" { return($TRUE) }
    case "Birth:DoW:Friday" { return($TRUE) }
    case "Birth:DoW:Saturday" { return($TRUE) }
    case "Birth:DoW:Sunday" { return($TRUE) }
    case "Birth:PlaceOfDelivery:Hospital" { return($TRUE) }
    case "Birth:PlaceOfDelivery:FreeStandingBirthCenter" { return($TRUE) }
    case "Birth:PlaceOfDelivery:HomeIntended" { return($TRUE) }
    case "Birth:Mom:Race:White" { return($TRUE) }
    case "Birth:Mom:Race:Black" { return($TRUE) }
    case "Birth:Mom:Race:AIAN" { return($TRUE) }
    case "Birth:Mom:Race:Asian" { return($TRUE) }
    case "Birth:Mom:Race:NHOPI" { return($TRUE) }
    case "Birth:Mom:MaritalStatus:Married" { return($TRUE) }
    case "Birth:Mom:MaritalStatus:Unmarried" { return($TRUE) }
    case "Birth:Mom:Education:8thOrElse" { return($TRUE) }
    case "Birth:Mom:Education:9TO12Drop" { return($TRUE) }
    case "Birth:Mom:Education:HSgrad" { return($TRUE) }
    case "Birth:Mom:Education:SomeCollege" { return($TRUE) }
    case "Birth:Mom:Education:BachelorDegree" { return($TRUE) }
    case "Birth:Mom:Education:MasterDegree" { return($TRUE) }
    case "Birth:Mom:Education:Doctorate" { return($TRUE) }
    case "Birth:Father:Race:White" { return($TRUE) }
    case "Birth:Father:Race:Black" { return($TRUE) }
    case "Birth:Father:Race:AIAN" { return($TRUE) }
    case "Birth:Father:Race:Asian" { return($TRUE) }
    case "Birth:Father:Race:NHOPI" { return($TRUE) }
    case "Birth:Father:MaritalStatus:Married" { return($TRUE) }
    case "Birth:Father:MaritalStatus:Unmarried" { return($TRUE) }
    case "Birth:Father:Education:8thOrElse" { return($TRUE) }
    case "Birth:Father:Education:9TO12Drop" { return($TRUE) }
    case "Birth:Father:Education:HSgrad" { return($TRUE) }
    case "Birth:Father:Education:SomeCollege" { return($TRUE) }
    case "Birth:Father:Education:BachelorDegree" { return($TRUE) }
    case "Birth:Father:Education:MasterDegree" { return($TRUE) }
    case "Birth:Father:Education:Doctorate" { return($TRUE) }
    }
    return;
}

sub getField{
    my $continue = $FALSE;
    my $field = "";

    do {
        $field = readInput(); 
        if (validateField($field) == 1)
        {
            $continue = $TRUE;
        }
        else{
            print $INVALID_FIELD.$NEW_LINE;
        }
    } while ($continue == $FALSE);
    return($field);
}

sub valGet{
    my @years = $_[0];
    my $yearsTotal = $years[1] - $years[0];
    my @fields;
    my $fieldCount = 0;
    my $total = 0;
    my $continue = $FALSE;

    clearScreen();
    print "Please select the field(s) for the first block [All fields are in user manual]".$NEW_LINE;
    print "[Field specific] that happened with [Field specific] (no limit to # of field specific) from ".$years[0]."-".$years[1].$NEW_LINE.$NEW_LINE;
    do {
        print "Field specific: ".$NEW_LINE;
        $fields[fieldCount] = <STDIN>;
        if (validateField($fieldOneComp) == 1)
        {
            $fieldCount++;
        }
        else
        {
            print "NOT A VALID FIELD".$NEW_LINE;
        }

        print "Add new field specifc? (y)es or (n)o.".$NEW_LINE;

        if(<STDIN> == "n") {
            $continue = $TRUE;
        }
        
    } while ($continue == $FALSE);

    }

    for my $i ( 0..$yearsTotal-1 ) {
        total += openFile($years[0]+$i, @fields, $fieldCount);
    }

    #todo
    return;

}

sub openFile{
    my $year = $_[0];
    my @fields = $_[1];
    my $fieldCount = $_[2];
    my $record_count = 0;
    my $total = 0;

    open my $year_fh, '<', "$year".".txt"
       or die "Unable to open file\n";

    my @records = <$names_fh>;

    close $year_fh or
       die "Unable to close\n";

    foreach my $year_record ( @records ) {
       if ( $csv->parse($year_record) ) {
          my @master_fields = $csv->fields();
          $record_count++;
          for my $i ( 0..$fieldCount ){
            if ($master_fields[] eq $fields[$i]) { #### get this resolved
                $total++;
            }
          }
       } else {
          warn "Line/record could not be parsed\n";
       }
    }

    return $total;
}

sub trend{
    my @years = $_[0];
    clearScreen();
    #todo
    return;
}

sub readInput{
    my $input = <STDIN>;
    chomp($input);
    return $input;
}

# TODO
# Present users 
# Get user input for which template they want to use
