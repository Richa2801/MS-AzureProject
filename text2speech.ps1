$text = "What I do remember about the final, which is that I am usually a very active guy but quite calm when it comes to living the games. And I remember that during that final it must be that as a player he didn't have the opportunity to play in 
a Champions League final. As a coach. It seemed like it was a unique opportunity, I wasn't more nervous in my life as a player or 
as a coach. I mean, I usually come."

#Add your key here
$key="9769025537904de7b0e87ce7a0a23a6c"

#You need to add your resource location if you use a Cognitive Services resource
$region="eastus2"

# Code to call Text to Speech API
$sml = "<speak version='1.0' xml:lang='en-US'>
<voice xml:lang='en-US' xml:gender='Female' name='en-US-AriaNeural'>
    $text
</voice>
</speak>"

$headers = @{}
$headers.Add( "Ocp-Apim-Subscription-Key", $key )
$headers.Add( "Content-Type","application/ssml+xml" )
$headers.Add( "X-Microsoft-OutputFormat","audio-16khz-128kbitrate-mono-mp3" )

$outputFile = "output.wav"

write-host "Synthesizing speech..."
$result = Invoke-RestMethod -Method Post `
    -Uri "https://$region.tts.speech.microsoft.com/cognitiveservices/v1" `
    -Headers $headers `
    -Body $sml `
    -OutFile $outputFile

write-host $result
write-host "Response saved in $outputFile `n"
