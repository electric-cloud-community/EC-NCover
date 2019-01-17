use ElectricCommander;

push (@::gMatchers,
  {
        id =>          "branchMatcher",
        pattern =>     q{Branch: (\d+,\d+)% Minimum: (\d+,\d+)%},
        action =>           q{
                              
                              my $desc = ((defined $::gProperties{"summary"}) ? $::gProperties{"summary"} : '');

                              $desc .= "Branch Coverage: $1%. Minimum: $2%. ";
                                
                              if($1 > $2){
                                  $desc .= 'Passed!';
                              }else{
                                  $desc .= 'Insufficient!';
                              }
                              
                              setProperty("summary", $desc . "\n");
                              
                             },
  },
);

push (@::gMatchers,
  {
        id =>          "symbolMatcher",
        pattern =>     q{Symbol: (\d+,\d+)% Minimum: (\d+,\d+)%},
        action =>           q{
                              
                              my $desc = ((defined $::gProperties{"summary"}) ? $::gProperties{"summary"} : '');

                              $desc .= "Symbol Coverage: $1%. Minimum: $2%. ";
                                
                              if($1 > $2){
                                  $desc .= 'Passed!';
                              }else{
                                  $desc .= 'Insufficient!';
                              }
                              
                              setProperty("summary", $desc . "\n");
                              
                             },
  },
);

push (@::gMatchers,
  {
        id =>          "methodMatcher",
        pattern =>     q{Method: (\d+,\d+)% Minimum: (\d+,\d+)%},
        action =>           q{
                              
                              my $desc = ((defined $::gProperties{"summary"}) ? $::gProperties{"summary"} : '');

                              $desc .= "Method Coverage: $1%. Minimum: $2%. ";
                                
                              if($1 > $2){
                                  $desc .= 'Passed!';
                              }else{
                                  $desc .= 'Insufficient!';
                              }
                              
                              setProperty("summary", $desc . "\n");
                              
                             },
  },
);

push (@::gMatchers,
  {
        id =>          "cyclomaticMatcher",
        pattern =>     q{Cyclomatic Complexity: (\d+,\d+)% Minimum: (\d+,\d+)%},
        action =>           q{
                              
                              my $desc = ((defined $::gProperties{"summary"}) ? $::gProperties{"summary"} : '');

                              $desc .= "Cyclomatic Complexity Coverage: $1%. Minimum: $2%. ";
                                
                              if($1 > $2){
                                  $desc .= 'Passed!';
                              }else{
                                  $desc .= 'Insufficient!';
                              }
                              
                              setProperty("summary", $desc . "\n");
                              
                             },
  },
);  
push (@::gMatchers,
  {
        id =>          "invalidExecutable",
        pattern =>     q{The executable can not be located at:(.*)},
        action =>           q{
                              
                              my $desc = ((defined $::gProperties{"summary"}) ? $::gProperties{"summary"} : '');

                              $desc .= "The executable can not be located at: $1";
                              
                              setProperty("outcome", "error" );
                              setProperty("summary", $desc . "\n");
                              
                             },
  },
);
