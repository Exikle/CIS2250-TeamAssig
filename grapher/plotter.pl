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
    $R->run(q`ggplot(data, aes(x =fieldComp, y=fieldTotalValue)) + geom_bar(stat="identity")`);

if ($fileName eq "comp.txt") {
    #$R->run(q`ggplot(data, aes(x=fieldOneComp, y=fieldOneTotalValue, fill=fieldOneComp))+ geom_bar(colour="black", stat = identity") + guides(fill = FALSE)`);
}

elsif ($fileName eq "maxMin.txt") {

}

elsif ($fileName eq "getVal") {

}
$R->run(q`dev.off()`);
$R->stop();
