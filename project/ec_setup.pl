my %runNCover = (
    label       => "NCover - Run NCover",
    procedure   => "runNCover",
    description => "Integrates NCover into Electric Commander",
    category    => "Code Analysis"
);

$batch->deleteProperty("/server/ec_customEditors/pickerStep/nCover - Run NCover");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-NCover - runNCover");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/NCover - Run NCover");

@::createStepPickerSteps = (\%runNCover);

