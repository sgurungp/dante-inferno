#!/usr/bin/perl -w
#======
# txt2json.pl: Convert a text file to the JSON input file format used 
#              by AWS Translate and print the results to stdout.
#
# Usage: perl txt2json.pl <inputfile>
#
use strict;
use English;

# Script takes a single argument - the name of a file to convert.
#
my $InputFile = $ARGV[0];
if (not defined $InputFile) { 
  die "Usage: $0 file\n";
}

# AWS Translate takes JSON objects as input - see 
# https://docs.aws.amazon.com/translate/latest/dg/get-started-cli.html
#
my $JSONTemplate = '
{
    "Text": "__TEXT__",
    "SourceLanguageCode": "it",
    "TargetLanguageCode": "en"
}';

# Open the file, and slurp up the whole contents in one go.
# (Canto files are only a few Kb so this is perfectly safe to do.)
# Remove newlines - AWS doesn't like them.
#
open(INPUTFILE, "<$InputFile") or die "Couldn't open $InputFile: $OS_ERROR\n";
$INPUT_RECORD_SEPARATOR = undef;
my $InputData = <INPUTFILE>;
$InputData =~ s/\R//g;
close INPUTFILE;

# Substitute the text for the placeholder in the template, 
# and print out the result.
#
$JSONTemplate =~ s/__TEXT__/$InputData/;
print $JSONTemplate;
