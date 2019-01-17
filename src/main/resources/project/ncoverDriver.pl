use warnings;
use strict; 
$|=1;

use ElectricCommander;

#### Constants

use constant LOG_LEVEL_VERBOSE => 'verbose';
use constant LOG_LEVEL_NORMAL => 'normal';
use constant LOG_LEVEL_NONE  => 'none';

use constant REPORT_TYPE_XML => 'xml';
use constant REPORT_TYPE_HTML => 'html';
use constant REPORT_TYPE_DEFAULT => 'default';


#### Global Variables

my $ec = new ElectricCommander();
$ec->abortOnError(0);
  
$::gNCoverDir                    = ($ec->getProperty( "ncoverdir" ))->findvalue('//value')->string_value;
$::gTarget                       = ($ec->getProperty( "target" ))->findvalue('//value')->string_value;
$::gReportName                   = ($ec->getProperty( "outputreportname" ))->findvalue('//value')->string_value;
$::gCollectMethodVisits          = ($ec->getProperty( "collectmethodvisits" ))->findvalue('//value')->string_value;
$::gCollectSymbols               = ($ec->getProperty( "collectsymbols" ))->findvalue('//value')->string_value;
$::gCollectBranch                = ($ec->getProperty( "collectbranch" ))->findvalue('//value')->string_value;
$::gCollectCyclomaticComplexity  = ($ec->getProperty( "collectcyclomatic" ))->findvalue('//value')->string_value;
$::gRequiredBranch               = ($ec->getProperty( "requiredbranch" ))->findvalue('//value')->string_value;
$::gRequiredCyclomaticComplexity = ($ec->getProperty( "requiredcyclomatic" ))->findvalue('//value')->string_value;
$::gRequiredMethodVisits         = ($ec->getProperty( "requiredmethodvisits" ))->findvalue('//value')->string_value;
$::gRequiredSymbols              = ($ec->getProperty( "requiredsymbols" ))->findvalue('//value')->string_value;
$::gExcludedFiles                = ($ec->getProperty( "excludedfiles" ))->findvalue('//value')->string_value;
$::gExcludedMethods              = ($ec->getProperty( "excludedmethods" ))->findvalue('//value')->string_value;
$::gIISCoverage                  = ($ec->getProperty( "iiscoverage" ))->findvalue('//value')->string_value;
$::gProjectName                  = ($ec->getProperty( "projectname" ))->findvalue('//value')->string_value;
$::gLogLevel                     = ($ec->getProperty( "loglevel" ))->findvalue('//value')->string_value;
$::gBuildID                      = ($ec->getProperty( "buildid" ))->findvalue('//value')->string_value;
$::gAdditionalConsoleCommands    = ($ec->getProperty( "additionalconsolecommands" ))->findvalue('//value')->string_value;
$::gAdditionalReportingCommands  = ($ec->getProperty( "additionalreportingcommands" ))->findvalue('//value')->string_value;
$::gTargetParams                 = ($ec->getProperty( "targetparams" ))->findvalue('//value')->string_value;


########################################################################
# main - contains the whole process to be done by the plugin, it builds 
#        the command line, sets the properties and the working directory
#
# Arguments:
#   none
#
# Returns:
#   none
#
########################################################################
sub main() {
    
    # create args arrays
    my @args = ();
    my @reportingArgs = ();
    
    #executable to use for each program
    my $executable = 'NCover.Console';
    my $reportingExecutable = 'NCover.Reporting';
    
    
    if($::gNCoverDir && $::gNCoverDir ne '') {
        $executable = $::gNCoverDir . $executable;
        $reportingExecutable = $::gNCoverDir . $reportingExecutable;
    }
    
    #insert program to invoke
    push(@args, qq{"$executable"});
    push(@reportingArgs, qq{"$reportingExecutable"});  
    
    if($::gReportName eq ''){
        $::gReportName = 'coverage.xml';
    }
    
    push(@args, '//x "' . $::gReportName . '"');
    push(@reportingArgs, '"' . $::gReportName . '"');    
    
    #additional commands for each program
    
    if($::gAdditionalConsoleCommands  && $::gAdditionalConsoleCommands  ne '') {
        foreach my $command (split(' +', $::gAdditionalConsoleCommands)) {
	    	push(@args, $command);
		}
    }

    if($::gAdditionalReportingCommands  && $::gAdditionalReportingCommands  ne '') {
        foreach my $command (split(' +', $::gAdditionalReportingCommands)) {
	    	push(@reportingArgs, $command);
		}
    }

    if($::gIISCoverage && $::gIISCoverage ne '') {
        push(@args, '//iis');
    }
    
    my $coverageMetric = '';
    my $minimumCoverage = '';
    
    if($::gCollectBranch && $::gCollectBranch ne '') {
        $coverageMetric .= 'Branch,';
        push(@reportingArgs, '//mc BranchCoverage:' . $::gRequiredBranch);
    }    

    if($::gCollectCyclomaticComplexity && $::gCollectCyclomaticComplexity ne '') {
        $coverageMetric .= 'CyclomaticComplexity,';
        push(@reportingArgs, '//mc CyclomaticComplexity:' . $::gRequiredCyclomaticComplexity);
    }  
    
    if($::gCollectSymbols && $::gCollectSymbols ne '') {
        $coverageMetric .= 'Symbol,';
        push(@reportingArgs, '//mc SymbolCoverage:' . $::gRequiredSymbols);
    }  
    
    if($::gCollectMethodVisits && $::gCollectMethodVisits ne '') {
        $coverageMetric .= 'MethodVisits,';
        push(@reportingArgs, '//mc MethodCoverage:' . $::gRequiredMethodVisits);
    }
    
    if($coverageMetric ne '') {
        chop($coverageMetric);
        push(@args, '//ct "' . $coverageMetric . '"');
    }   
    
    if($::gExcludedFiles && $::gExcludedFiles ne ''){
        push(@args, '//exclude-files "' . $::gExcludedFiles . '"');
    }    
    
    if($::gExcludedMethods && $::gExcludedMethods ne ''){
        push(@args, '//exclude-methods "' . $::gExcludedMethods . '"');
    }
    
    if($::gProjectName && $::gProjectName ne ''){
        push(@args, '//project-name "' . $::gProjectName . '"');
    }
    
    if($::gLogLevel && $::gLogLevel ne ''){
        push(@args, '//ll ' . $::gLogLevel);
    }
    
    if($::gBuildID && $::gBuildID ne ''){
        push(@args, '//bi "' . $::gBuildID . '"');
    }
    
    if($::gTarget && $::gTarget ne ''){
        push(@args, '"' . $::gTarget . '"')
    }    
    
    #add params for the target app
    if($::gTargetParams  && $::gTargetParams  ne '') {
        foreach my $command (split(' +', $::gTargetParams)) {
	    	push(@args, $command);
		}
    }  
    
    if($::gReportName && $::gReportName ne ""){
        registerReports();
    }
    
    #register properties
    $ec->setProperty("/myCall/consoleCommandLine", join(" ",@args));
    $ec->setProperty("/myCall/reportingCommandLine", join(" ",@reportingArgs));
    
}

########################################################################
# registerReports - creates a link for registering the generated report
# in the job step detail
#
# Arguments:
#   none
#
# Returns:
#   none
#
########################################################################
sub registerReports(){
 
    # get an EC object
    my $ec = new ElectricCommander();
    $ec->abortOnError(0);
 
    $ec->setProperty("/myJob/artifactsDirectory", "");
    
    my $fileName = '';
    my $fileIndex = rindex($::gReportName, '/');
    
    if($fileIndex == -1){
       $fileIndex = (rindex($::gReportName, '\\'));
    }
    
    if($fileIndex == -1){
       $fileName = $::gReportName;
    }else{
       $fileName = substr($::gReportName, $fileIndex+1, length($::gReportName)-$fileIndex);
    }
    
    $ec->setProperty("/myJob/report-urls/NCover Coverage Result", 
          "jobSteps/$[jobStepId]/" . $fileName);

}

main();

