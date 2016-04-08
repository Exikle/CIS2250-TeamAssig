#!/user/bin/perl
use strict;
use warnings;
use version;   our $VERSION = qv('5.16.0');
use Statistics::R;

my $fileName;
my $pdfFileName;

if ($#ARGV != 1) {
    print "Usage: plotter.pl <input file name. <pdf file name>\n" or
        die "Print failure\n";
    exit;   

} else {
    $fileName = $ARGV[0];
    $pdfFileName = $ARGV[1];
}
my $R = Statistics::R->new();
$R ->run(qq`pdf("$pdfFileName" , paper = "letter")`);
$R ->run(q`library(ggplot2)`);
$R ->run(qq`data <- read.csv("$fileName",sep = ",")`);

if ($fileName eq "grapher/comp.txt") {
    $R->run(q`ggplot(data, aes(x =fieldComp, y=fieldTotalValue, fill = fieldComp)) + geom_bar(colour = "black", stat="identity") + guides(fill = FALSE) + xlab("Field of comparison") + ylab("Total Number of occurrences") + ggtitle("Comparison of Given fields");`);
}

elsif ($fileName eq "grapher/maxMin.txt") {
	$R->run(q`ggplot(data, aes(x =fieldName, y=fieldTotalValue, fill = fieldName)) + geom_bar(colour = "black", stat="identity") + guides(fill = FALSE) + xlab("Stat") + ylab("Total Number of occurrences") + ggtitle("Comparison of given fields");`);
}

elsif ($fileName eq "grapher/getVal") {

}
$R->run(q`dev.off()`);
$R->stop();
