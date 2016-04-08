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
my $EMPTY = q{};
my $INVALID_FIELD = "Not a valid field, try again.";
my $INVALID_CHOICE = "Not a valid choice, try again.";
my $DIVIDER = "==========================================";
my $HEADER = "BIG BANG CDC Death/ Birth statistics program".$NEW_LINE.$DIVIDER.$NEW_LINE;
my $QUITTING_PROMPT = "Quitting. Thanks for using.";
my $ENTER_CONTINUE = "Press any key to continue.";

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
    my @years;
    
    clearScreen();
    @years = getYearRange();

    clearScreen();
    manualReminder();
    
    clearScreen();
    startUserChoices($years[0], $years[1]);
    
    system("clear");
    return;
}

sub manualReminder{
    print "Don't forget to take a look at the manual to get the fields required! ".$ENTER_CONTINUE.$NEW_LINE;
    <STDIN>;
    return;
}

sub startUserChoices {
    my @years;
    $years[0] = $_[0];
    $years[1] = $_[1];
    my $CHOICE_PROMPT = "Choice: ";

    my $choice = 1;
    my $validChoice = $TRUE;

    do{
        $validChoice = $TRUE;

        printOptions();
        print $CHOICE_PROMPT;
        $choice = readInput();

        switch($choice){
            case 1 {
                valMaxMin($years[0], $years[1]);
            }
            case 2 {
                valComp($years[0], $years[1]);
            }
            case 3 {
                valGet(@years);
            }
            case 4 {
                trend(@years);
            }
            case 5 {
                print $QUITTING_PROMPT.$NEW_LINE;
            }
            else {
                $validChoice = $FALSE;
                print $INVALID_CHOICE.$NEW_LINE;
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
    print "5. Quit (or type quit)".$NEW_LINE;
    return;
}

sub getYearRange{
    my $RANGE_PROMPT = "Choose the range of years you would like to examine (Min: 1994 - Max: 2014).\n";
    my $YEAR_START_PROMPT = "Starting year: ";
    my $YEAR_END_PROMPT = "Ending year: ";
    my $INVALID_YEAR_PROMPT = "Invalid start year. Must be in the range of 1994 to 2014.";
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
    $years[0] = $startingYear;
    do {
        print $YEAR_END_PROMPT;
        $endingYear = readInput();
        $continue = validateEndYear($endingYear);

        if($continue == $FALSE){
            print $INVALID_RANGE_PROMPT_X.$startingYear.$INVALID_RANGE_PROMPT_Y.$NEW_LINE;
        }

    } while($continue == $FALSE);
    $years[1] = $endingYear;
    return (@years);
}

sub isNotAlpha{
    if ($_[0] =~ /^[0-9,.E]+$/){
        return  $TRUE;
    }
    else {
        return $FALSE;
    }
}

sub validateStartYear{
    my $year = $_[0];

    if (isNotAlpha($year)){}
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

    if (isNotAlpha($year)){}
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
    print $HEADER;
    return;
}



# Value Max/Min [Least/Most] [deaths or [field specific]] in [field] between [period]

# bar graph
sub valMaxMin{
    my @years;    
    my $mostOf = 0;
    my $isDeathStats = 0;
    my $validField;
    my $fieldInp;
    my $statLoc = 0;


    $years[0] = $_[0];
    $years[1] = $_[1];

    clearScreen();

    # print "RUN VALMAXMIN";
    do{
        if($isDeathStats != 0){
            print $INVALID_CHOICE.$NEW_LINE;
        }

        print "Did you want to find out:".$NEW_LINE;
        print "1. Death statistics".$NEW_LINE;
        print "2. Birth statistics".$NEW_LINE;
        print "Choice: ";
        $isDeathStats = readInput();

    }while($isDeathStats != 1 && $isDeathStats != 2);

    clearScreen();
    if($isDeathStats == $TRUE){
        print "Death statistics selected of ".$years[0]." to ".$years[1].$NEW_LINE;
    }
    else {
        print "Birth statistics selected. ".$NEW_LINE
    }

    do{
        if($mostOf != 0){
            print $INVALID_CHOICE.$NEW_LINE;
        }
        print "Did you want to find:".$NEW_LINE;
        print "1. The most of a specific statistic".$NEW_LINE;
        print "2. The least of a specific statistic".$NEW_LINE;
        print "Choice: ";
        $mostOf = readInput();

        clearScreen();
    }while($mostOf != 1 && $mostOf != 2);

    # Get the field
    do{
        if($FALSE == $validField){
            print $INVALID_FIELD.$NEW_LINE;
        }
        print "Field: ";
        $fieldInp = readInput();
        $validField = validateField($fieldInp);
    }while($validField == $FALSE);

    $statLoc = getFieldLocation($fieldInp);
    # 
    #todo
    return;
}

sub valComp{
    my $continue = $FALSE;
    my @years;
    my @records;
    my $fileName = $EMPTY;
    my $currentYear;
    $years[0] = $_[0];
    $years[1] = $_[1];
    my $fieldOneComp;
    my $fieldOneCompValue; #This is the value for the field (EXAMPLE: 1 is male in the Sex field)
    my $fieldOneLocation;
    my $fieldOneTotalValue = 0;
    my @fieldOneArray;
    my $fieldTwoComp;
    my $fieldTwoCompValue;
    my $fieldTwoLocation;
    my $fieldTwoTotalValue = 0;
    my @fieldTwoArray;
    my $maxFlag;
    my $fieldOfComp;
    my $record_count = -1;
    $currentYear = $years[0];
    clearScreen();
    
    # ask first specific

    print "Please select the field for the first block (Refer to user manual)".$NEW_LINE;
    print "[FIELD ONE] or [FIELD TWO] has [LEAST/ MOST] occurences in [GENERAL FIELD] from ".$years[0]." to ".$years[1].$NEW_LINE.$NEW_LINE;
    
    $fieldOneComp = getField();
    $fieldOneCompValue = getFieldValue($fieldOneComp);
    $fieldOneLocation = getFieldLocation($fieldOneComp);
    clearScreen();
    
    print "Please select the field for the second block (Refer to user manual)".$NEW_LINE;
    print "[".$fieldOneComp."]"." or [FIELDSPECIFIC] has [LEAST/ MOST] occurences in [GENERAL FIELD] from ".$years[0]."-".$years[1].$NEW_LINE.$NEW_LINE;
    
    do {
        $fieldTwoComp = getField();
        $fieldTwoCompValue = getFieldValue($fieldTwoComp);
        $fieldTwoLocation = getFieldLocation($fieldTwoComp);
        if ($fieldOneLocation != $fieldTwoLocation) {
            print $INVALID_FIELD." Make sure the field specific you choose belongs to the same as the first one you chose.".$NEW_LINE;
        }
    } while ($fieldOneLocation != $fieldTwoLocation);
    clearScreen();

    print "Are you looking for [M]ost or [L]east?".$NEW_LINE;
    do {
        $maxFlag = lc(readInput());
        if (($maxFlag ne "m")&&($maxFlag ne "l")) {
            print $INVALID_FIELD.$NEW_LINE;
        }
    } while (($maxFlag ne "M")&&($maxFlag ne "m")&&($maxFlag ne "l")&&($maxFlag ne "L"));

    print "Please select the field for the last block [All fields are in the user manual]".$NEW_LINE;
    if ($maxFlag eq "m"){
        print "[".$fieldOneComp."]"." or [".$fieldTwoComp."] has most occurences in [GENERAL FIELD] from ".$years[0]."-".$years[1].$NEW_LINE.$NEW_LINE;
    }
    else
    {
        print "[".$fieldOneComp."]"." or [".$fieldTwoComp."] has most occurences in [GENERAL FIELD] from ".$years[0]."-".$years[1].$NEW_LINE.$NEW_LINE;
    }
    do {
        $fieldOfComp = getField();
        if  (($fieldOfComp ne "Death:TotalNumber")&&($fieldOfComp ne "Birth:TotalNumber")){
            print $INVALID_FIELD." User either Death:TotalNumber or Birth:TotalNumber".$NEW_LINE;
        }
    }while (($fieldOfComp ne "Death:TotalNumber")&&($fieldOfComp ne "Birth:TotalNumber"));
    clearScreen();
    while ($currentYear <= $years[1]) {
        if ($fieldOfComp eq "Death:TotalNumber") {
            $fileName = "Data/Death/".$currentYear."/deaths".$currentYear.".txt";
        }
        else {
            $fileName = "Data/Birth/".$currentYear."/births".$currentYear.".txt"; 
        }
        open my $file_fh, '<', $fileName
            or die "Unable to open names file: $fileName\n";
        @records = <$file_fh>;
        close $file_fh or
            die "Unable to close: $fileName\n";
        foreach my $file_record ( @records ) {
            if ($csv -> parse($file_record)){
                my @master_fields = $csv->fields();
                $record_count++;
                if (($master_fields[$fieldOneLocation] eq "")||($master_fields[$fieldTwoLocation] eq "")) {
                    print "Data fields chosen are not compatible with years chosen, restart the program to try again".$NEW_LINE;
                    die;
                }
                $fieldOneArray[$record_count] = $master_fields[$fieldOneLocation];
                $fieldTwoArray[$record_count] = $master_fields[$fieldTwoLocation];
            } else {
                warn "Line could not be prepared";
            }
        }
        for my $i (0..$record_count) {
            if ($fieldOneArray[$i] == $fieldOneCompValue)
            {
                $fieldOneTotalValue++;
            }
            if ($fieldTwoArray[$i] == $fieldTwoCompValue)
            {
                $fieldTwoTotalValue++;
            }
        }
        
        $currentYear++;
    }
    print $fieldOneTotalValue."                  ".$fieldTwoTotalValue;
    <STDIN>;
    return;
}

sub getFieldLocation {
    my $field = $_[0];
    switch($field) {
    case "Death:MoD" { return(1) }
    case "Death:DoW" { return(2) }
    case "Death:Age" { return(3) }
    case "Death:Sex" { return(4) }
    case "Death:Race" { return(5) }
    case "Death:MaritalStatus" { return(6) }
    case "Death:Education03" { return(8) }
    case "Death:Education89" { return(7) }
    case "Death:ResidentStatus" { return(9) }
    case "Death:PoD" { return(10) }
    case "Death:Injury" { return(11) }
    case "Death:MethodOfDisposition" { return(13) }
    case "Death:Autopsy" { return(14) }
    case "Death:ICD" { return(15) }
    case "Death:Sex:Male" { return(4) }
    case "Death:Sex:Female" { return(4) }
    case "Death:ResidentStatus:Resident" { return(9) }
    case "Death:ResidentStatus:ForeignResident" { return(9) }
    case "Death:MoD:January" { return(1) }
    case "Death:MoD:February" { return(1) }
    case "Death:MoD:March" { return(1) }
    case "Death:MoD:April" { return(1) }
    case "Death:MoD:May" { return(1) }
    case "Death:MoD:June" { return(1) }
    case "Death:MoD:July" { return(1) }
    case "Death:MoD:August" { return(1) }
    case "Death:MoD:September" { return(1) }
    case "Death:MoD:October" { return(1) }
    case "Death:MoD:November" { return(1) }
    case "Death:MoD:December" { return(1) }
    case "Death:DoW:Monday" { return(2) }
    case "Death:DoW:Tuesday" { return(2) }
    case "Death:DoW:Wednesday" { return(2) }
    case "Death:DoW:Thursday" { return(2) }
    case "Death:DoW:Friday" { return(2) }
    case "Death:DoW:Saturday" { return(2) }
    case "Death:DoW:Sunday" { return(2) }
    case "Death:MaritalStatus:Single" { return(6) }
    case "Death:MaritalStatus:Married" { return(6) }
    case "Death:MaritalStatus:Widowed" { return(6) }
    case "Death:MaritalStatus:Divorced" { return(6) }
    case "Death:Education03:8thOrLess" { return(8) }
    case "Death:Education03:9TO12Drop" { return(8) }
    case "Death:Education03:HSgrad" { return(8) }
    case "Death:Education03:CollegeNoDegree" { return(8) }
    case "Death:Education03:AssociateDegree" { return(8) }
    case "Death:Education03:BachelorDegree" { return(8) }
    case "Death:Education03:MasterDegree" { return(8) }
    case "Death:Education03:DoctorateDegree" { return(8) }
    case "Death:Education89:None" { return(7) }
    case "Death:Education89:1YearHS" { return(7) }
    case "Death:Education89:2YearHS" { return(7) }
    case "Death:Education89:3YearHS" { return(7) }
    case "Death:Education89:4YearHS" { return(7) }
    case "Death:Education89:1YearCollege" { return(7) }
    case "Death:Education89:2YearCollege" { return(7) }
    case "Death:Education89:3YearCollege" { return(7) }
    case "Death:Education89:4YearCollege" { return(7) }
    case "Death:Education89:5MoreYearCollege" { return(7) }
    case "Death:MethodOfDispositon:Burial" { return(13) }
    case "Death:MethodOfDispositon:Cremation" { return(13) }
    case "Death:MethodOfDispositon:Other" { return(13) }
    case "Death:MethodOfDispositon:Unkown" { return(13) }
    case "Death:MannerOfDeath:Accident" { return(12) }
    case "Death:MannerOfDeath:Suicide" { return(12) }
    case "Death:MannerOfDeath:Homocide" { return(12) }
    case "Death:MannerOfDeath:PendingInvestigation" { return(12) }
    case "Death:MannerOfDeath:SelfInflicted" { return(12) }
    case "Death:MannerOfDeath:Natural" { return(12) }
    case "Death:MannerOfDeath:NotSpecified" { return(12) }
    case "Death:PoD:Home" { return(10) }
    case "Death:PoD:School" { return(10) }
    case "Death:PoD:AthleticsArea" { return(10) }
    case "Death:PoD:Street" { return(10) }
    case "Death:PoD:Industrial" { return(10) }
    case "Death:PoD:Farm" { return(10) }
    case "Death:Age:Years" { return(3) }
    case "Death:Race:White" { return(5) }
    case "Death:Race:Black" { return(5) }
    case "Death:Race:AmericanIndian" { return(5) }
    case "Death:Race:Chinese" { return(5) }
    case "Death:Race:Japanese" { return(5) }
    case "Death:Race:Hawaiian" { return(5) }
    case "Death:Race:Filipino" { return(5) }
    case "Death:Race:AsianIndian" { return(5) }
    case "Death:Race:Korean" { return(5) }
    case "Death:Race:Samoan" { return(5) }
    case "Death:Race:Vietnamese" { return(5) }
    case "Death:Race:Guamanian" { return(5) }
    case "Birth:Child:Sex" { return(9) }
    case "Birth:Child:Birthweight" { return(10) }
    case "Birth:Child:TimeOfBirth" { return(4) }
    case "Birth:Child:Month" { return(3) }
    case "Birth:Child:DoW" { return(5) }
    case "Birth:Mom:Age" { return(12) }
    case "Birth:Mom:Race" { return(13) }
    case "Birth:Mom:MaritalStatus" { return(14) }
    case "Birth:Mom:Education" { return(15) }
    case "Birth:TotalBirthOrder" { return(16) }
    case "Birth:BirthInterval" { return(17) }
    case "Birth:Father:Age" { return(18) }
    case "Birth:Father:Race" { return(19) }
    case "Birth:Father:Education" { return(20) }
    case "Birth:MethodOfDelivery" { return(7) }
    case "Birth:Child:Number" { return(11) }
    case "Birth:Attendant" { return(8) }
    case "Birth:PlaceOfDelivery" { return(6) }
    case "Birth:Child:Male" { return(9) }
    case "Birth:Child:Female" { return(9) }
    case "Birth:DoW:Monday" { return(5) }
    case "Birth:DoW:Tuesday" { return(5) }
    case "Birth:DoW:Wednesday" { return(5) }
    case "Birth:DoW:Thursday" { return(5) }
    case "Birth:DoW:Friday" { return(5) }
    case "Birth:DoW:Saturday" { return(5) }
    case "Birth:DoW:Sunday" { return(5) }
    case "Birth:PlaceOfDelivery:Hospital" { return(6) }
    case "Birth:PlaceOfDelivery:FreeStandingBirthCenter" { return(6) }
    case "Birth:PlaceOfDelivery:HomeIntended" { return(6) }
    case "Birth:Mom:Race:White" { return(13) }
    case "Birth:Mom:Race:Black" { return(13) }
    case "Birth:Mom:Race:AIAN" { return(13) }
    case "Birth:Mom:Race:Asian" { return(13) }
    case "Birth:Mom:Race:NHOPI" { return(13) }
    case "Birth:Mom:MaritalStatus:Married" { return(14) }
    case "Birth:Mom:MaritalStatus:Unmarried" { return(14) }
    case "Birth:Mom:Education:8thOrElse" { return(15) }
    case "Birth:Mom:Education:9TO12Drop" { return(15) }
    case "Birth:Mom:Education:HSgrad" { return(15) }
    case "Birth:Mom:Education:SomeCollege" { return(15) }
    case "Birth:Mom:Education:BachelorDegree" { return(15) }
    case "Birth:Mom:Education:MasterDegree" { return(15) }
    case "Birth:Mom:Education:Doctorate" { return(15) }
    case "Birth:Father:Race:White" { return(18) }
    case "Birth:Father:Race:Black" { return(18) }
    case "Birth:Father:Race:AIAN" { return(18) }
    case "Birth:Father:Race:Asian" { return(18) }
    case "Birth:Father:Race:NHOPI" { return(18) }
    case "Birth:Father:Education:8thOrElse" { return(20) }
    case "Birth:Father:Education:9TO12Drop" { return(20) }
    case "Birth:Father:Education:HSgrad" { return(20) }
    case "Birth:Father:Education:SomeCollege" { return(20) }
    case "Birth:Father:Education:BachelorDegree" { return(20) }
    case "Birth:Father:Education:MasterDegree" { return(20) }
    case "Birth:Father:Education:Doctorate" { return(20) }
    }
}

sub getFieldValue {
    my $field = $_[0];
    switch($field) {
    case "Death:Sex:Male" { return(1) }
    case "Death:Sex:Female" { return(2) }
    case "Death:ResidentStatus:Resident" { return(1) }
    case "Death:ResidentStatus:ForeignResident" { return(4) }
    case "Death:MoD:January" { return(01) }
    case "Death:MoD:February" { return(02) }
    case "Death:MoD:March" { return(03) }
    case "Death:MoD:April" { return(04) }
    case "Death:MoD:May" { return(05) }
    case "Death:MoD:June" { return(06) }
    case "Death:MoD:July" { return(07) }
    case "Death:MoD:August" { return("08") }
    case "Death:MoD:September" { return("09") }
    case "Death:MoD:October" { return(10) }
    case "Death:MoD:November" { return(11) }
    case "Death:MoD:December" { return(12) }
    case "Death:DoW:Monday" { return(2) }
    case "Death:DoW:Tuesday" { return(3) }
    case "Death:DoW:Wednesday" { return(4) }
    case "Death:DoW:Thursday" { return(5) }
    case "Death:DoW:Friday" { return(6) }
    case "Death:DoW:Saturday" { return(7) }
    case "Death:DoW:Sunday" { return(1) }
    case "Death:MaritalStatus:Single" { return(1) }
    case "Death:MaritalStatus:Married" { return(1) }
    case "Death:MaritalStatus:Widowed" { return(1) }
    case "Death:MaritalStatus:Divorced" { return(1) }
    case "Death:Education03:8thOrLess" { return(1) }
    case "Death:Education03:9TO12Drop" { return(2) }
    case "Death:Education03:HSgrad" { return(3) }
    case "Death:Education03:CollegeNoDegree" { return(4) }
    case "Death:Education03:AssociateDegree" { return(5) }
    case "Death:Education03:BachelorDegree" { return(6) }
    case "Death:Education03:MasterDegree" { return(7) }
    case "Death:Education03:DoctorateDegree" { return(8) }
    case "Death:Education89:None" { return(00) }
    case "Death:Education89:1YearHS" { return("09") }
    case "Death:Education89:2YearHS" { return(10) }
    case "Death:Education89:3YearHS" { return(11) }
    case "Death:Education89:4YearHS" { return(12) }
    case "Death:Education89:1YearCollege" { return(13) }
    case "Death:Education89:2YearCollege" { return(14) }
    case "Death:Education89:3YearCollege" { return(15) }
    case "Death:Education89:4YearCollege" { return(16) }
    case "Death:Education89:5MoreYearCollege" { return(17) }
    case "Death:MethodOfDispositon:Burial" { return("B") }
    case "Death:MethodOfDispositon:Cremation" { return("C") }
    case "Death:MethodOfDispositon:Other" { return("O") }
    case "Death:MethodOfDispositon:Unkown" { return("U") }
    case "Death:MannerOfDeath:Accident" { return(1) }
    case "Death:MannerOfDeath:Suicide" { return(2) }
    case "Death:MannerOfDeath:Homocide" { return(3) }
    case "Death:MannerOfDeath:PendingInvestigation" { return(4) }
    case "Death:MannerOfDeath:SelfInflicted" { return(6) }
    case "Death:MannerOfDeath:Natural" { return(7) }
    case "Death:MannerOfDeath:NotSpecified" { return() }
    case "Death:PoD:HospitalInpatient" { return(1) }
    case "Death:PoD:HospitalOutpatient" { return(2) }
    case "Death:PoD:HospitalDeadOnArrival" { return(3) }
    case "Death:PoD:Home" { return(4) }
    case "Death:PoD:HospiceFacility" { return(5) }
    case "Death:PoD:NursingHome" { return(6) }
    case "Death:Age:Years" { return(1) }
    case "Death:Race:White" { return(01) }
    case "Death:Race:Black" { return(02) }
    case "Death:Race:AmericanIndian" { return(03) }
    case "Death:Race:Chinese" { return(04) }
    case "Death:Race:Japanese" { return(05) }
    case "Death:Race:Hawaiian" { return(06) }
    case "Death:Race:Filipino" { return(07) }
    case "Death:Race:AsianIndian" { return(18) }
    case "Death:Race:Korean" { return(28) }
    case "Death:Race:Samoan" { return(38) }
    case "Death:Race:Vietnamese" { return(48) }
    case "Death:Race:Guamanian" { return(58) }
    case "Birth:Child:Sex:Male" { return("M") }
    case "Birth:Child:Sex:Female" { return("F") }
    case "Birth:DoW:Monday" { return(2) }
    case "Birth:DoW:Tuesday" { return(3) }
    case "Birth:DoW:Wednesday" { return(4) }
    case "Birth:DoW:Thursday" { return(5) }
    case "Birth:DoW:Friday" { return(6) }
    case "Birth:DoW:Saturday" { return(7) }
    case "Birth:DoW:Sunday" { return(1) }
    case "Birth:PlaceOfDelivery:Hospital" { return(1) }
    case "Birth:PlaceOfDelivery:FreeStandingBirthCenter" { return(2) }
    case "Birth:PlaceOfDelivery:HomeIntended" { return(3) }
    case "Birth:Mom:Race:White" { return(1) }
    case "Birth:Mom:Race:Black" { return(2) }
    case "Birth:Mom:Race:AIAN" { return(3) }
    case "Birth:Mom:Race:Asian" { return(4) }
    case "Birth:Mom:Race:NHOPI" { return(5) }
    case "Birth:Mom:MaritalStatus:Married" { return(1) }
    case "Birth:Mom:MaritalStatus:Unmarried" { return(2) }
    case "Birth:Mom:Education:8thOrElse" { return(1) }
    case "Birth:Mom:Education:9TO12Drop" { return(2) }
    case "Birth:Mom:Education:HSgrad" { return(3) }
    case "Birth:Mom:Education:SomeCollege" { return(4) }
    case "Birth:Mom:Education:BachelorDegree" { return(6) }
    case "Birth:Mom:Education:MasterDegree" { return(7) }
    case "Birth:Mom:Education:Doctorate" { return(8) }
    case "Birth:Father:Race:White" { return(1) }
    case "Birth:Father:Race:Black" { return(2) }
    case "Birth:Father:Race:AIAN" { return(3) }
    case "Birth:Father:Race:Asian" { return(4) }
    case "Birth:Father:Race:NHOPI" { return(5) }
    case "Birth:Father:Education:8thOrElse" { return(1) }
    case "Birth:Father:Education:9TO12Drop" { return(2) }
    case "Birth:Father:Education:HSgrad" { return(3) }
    case "Birth:Father:Education:SomeCollege" { return(4) }
    case "Birth:Father:Education:BachelorDegree" { return(6) }
    case "Birth:Father:Education:MasterDegree" { return(7) }
    case "Birth:Father:Education:Doctorate" { return(8) }
    }
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
        case "Death:MoD:February" { return($TRUE) }
        case "Death:MoD:March" { return($TRUE) }
        case "Death:MoD:April" { return($TRUE) }
        case "Death:MoD:May" { return($TRUE) }
        case "Death:MoD:June" { return($TRUE) }
        case "Death:MoD:July" { return($TRUE) }
        case "Death:MoD:August" { return($TRUE) }
        case "Death:MoD:September" { return($TRUE) }
        case "Death:MoD:October" { return($TRUE) }
        case "Death:MoD:November" { return($TRUE) }
        case "Death:MoD:December" { return($TRUE) }
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
        case "Death:MannerOfDeath:Accident" { return($TRUE) }
        case "Death:MannerOfDeath:Suicide" { return($TRUE) }
        case "Death:MannerOfDeath:Homocide" { return($TRUE) }
        case "Death:MannerOfDeath:PendingInvestigation" { return($TRUE) }
        case "Death:MannerOfDeath:SelfInflicted" { return($TRUE) }
        case "Death:MannerOfDeath:Natural" { return($TRUE) }
        case "Death:MannerOfDeath:NotSpecified" { return($TRUE) }
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
        case "Birth:Father:Education:8thOrElse" { return($TRUE) }
        case "Birth:Father:Education:9TO12Drop" { return($TRUE) }
        case "Birth:Father:Education:HSgrad" { return($TRUE) }
        case "Birth:Father:Education:SomeCollege" { return($TRUE) }
        case "Birth:Father:Education:BachelorDegree" { return($TRUE) }
        case "Birth:Father:Education:MasterDegree" { return($TRUE) }
        case "Birth:Father:Education:Doctorate" { return($TRUE) }
    }
    return $FALSE;
}

sub getField{
    my $continue = $FALSE;
    my $field;

    do {
        $field = readInput(); 
        if (validateField($field) == $TRUE){
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

    my $userInput;

    clearScreen();

    # print "Please select the field(s) for the first block [All fields are in user manual]".$NEW_LINE;
    # print "[Field specific] that happened with [Field specific] (no limit to # of field specific) from ".$years[0]."-".$years[1].$NEW_LINE.$NEW_LINE;
    # do {
    #     print "Field specific: ".$NEW_LINE;
    #     $userInput = readInput();

    #     $fields[fieldCount] = $userInput;
    #     if (validateField($fieldOneComp) == $TRUE){
    #         $fieldCount++;
    #     }
    #     else{$
    #         print $INVALID_FIELD.$NEW_LINE;
    #     }

    #     print "Add new field specifc? (y)es or (n)o.".$NEW_LINE;
    #     userInput = readInput();
    #     if(userInput == "n") {
    #         $continue = $TRUE;
    #     }
        
    # } while ($continue == $FALSE);

    # for my $i ( 0..$yearsTotal-1 ) {
    #     total += openFile($years[0]+$i, @fields, $fieldCount);
    # }

    #todo
    return;
}

sub openFile{
    my $year = $_[0];
    my @fields = $_[1];
    my $fieldCount = $_[2];
    my $record_count = 0;
    my $total = 0;

    # open my $year_fh, '<', "$year".".txt"
    #    or die "Unable to open file\n";

    # my @records = <$names_fh>;

    # close $year_fh or
    #    die "Unable to close\n";

    # foreach my $year_record ( @records ) {
    #    if ( $csv->parse($year_record) ) {
    #       my @master_fields = $csv->fields();
    #       $record_count++;
    #       for my $i ( 0..$fieldCount ){
    #         if ($master_fields[] eq $fields[$i]) { #### get this resolved
    #             $total++;
    #         }
    #       }
    #    }
    #    else {
    #       warn "Line/record could not be parsed\n";
    #    }
    # }

    return $total;
}

# Icebox
# sub trend{ 
#     # my @years = $_[0];

#     clearScreen();
    
#     print "running Trends code.";
#     #todo
#     return 
# }

sub readInput{
    my $input = <STDIN>;
    chomp($input);
    if(lc($input) eq "quit"){
        print $QUITTING_PROMPT.$SPACE.$ENTER_CONTINUE.$NEW_LINE;
        <STDIN>;
        system("clear");
        exit();
    }
    return $input;
}
