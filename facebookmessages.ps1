    Param( 
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)] 
        $messages
    ) 

$mess = Get-Content $messages
$testt = ($mess -join '`n' -split '<div class="thread">').Replace('&#064;','@')
$fullmessage = @()
$tn = $null
foreach ($thread in $testt) {
    $tn += 1
    $threadid = (($thread -split '<div class="message">')[0])
    $thread2 = ($thread -Split '<div class="message"><div class="message_header"><span class=') | Where-Object {$_ -match 'user'}
    foreach ($message in $thread2) {
        $encodedm = $message -split '</span><span class=' -split '</span></div></div>' # -replace '<p>','' -replace '</p>',''

        foreach ($line in $encodedm) {
            if ($line -match '"user">') {
                $muser = ($line -split '"user">')[-1]

            }
            if ($line -match '"meta">') {
                $mdate = (($line -split '"meta">')[1]).split(' |,')[1,2,3,-2]
                
                switch ($mdate){
                    aoÃ»t {$mdate1 = "August"}
                    avril {$mdate1 = "April"}
                    dÃ©cembre {$mdate1 = "December"}
                    fÃ©vrier {$mdate1 = "February"}
                    janvier {$mdate1 = "January"}
                    juillet {$mdate1 = "July"}
                    juin {$mdate1 = "June"}
                    mai {$mdate1 = "May"}
                    mars {$mdate1 = "March"}
                    novembre {$mdate1 = "November"}
                    octobre {$mdate1 = "October"}
                    septembre {$mdate1 = "September"}
                }
                $realdate = get-date ($mdate[0] + " " + $mdate1 +", " + $mdate[2] + " " + $mdate[-1])

            }
            if ($line -match '<p>') {
                $mtext = $line -replace '<p>','' -replace '</p>',''
            }
        }

        $fullmessage += [PSCustomObject]@{'ThreadID' = $threadid
                                          'TN' = $tn
                                          'User' = $muser
                                          'Date' = $realdate
                                          'Message' = $mtext}
    }
}