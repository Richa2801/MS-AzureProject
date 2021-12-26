#Key
$key="9769025537904de7b0e87ce7a0a23a6c"

#You need to add your resource location if you use a Cognitive Services resource
$location="eastus2"

# Code to call Speech to Text API
$name = Read-Host "Enter the file name to be translated"
$wav = "./data/speech/$name"

$headers = @{}
$headers.Add( "Ocp-Apim-Subscription-Key", $key )
$headers.Add( "Content-Type","audio/wav" )

write-host "Analyzing audio..."
$result = Invoke-RestMethod -Method Post `
          -Uri "https://$location.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=en-US" `
          -Headers $headers `
          -InFile $wav

$output = $result.DisplayText
Write-Host ("`nThe audio said '$output'")

#The endpoint is global for the Translator service, DO NOT change it 
$endpoint="https://api.cognitive.microsofttranslator.com/"

# Code to call Text Analytics service to analyze sentiment in text
$headers = @{}
$headers.Add( "Ocp-Apim-Subscription-Key", $key )
$headers.Add( "Ocp-Apim-Subscription-Region", $location )
$headers.Add( "Content-Type","application/json" )

$body = "[{'text': '$output'}]" 
$lang = Read-Host "Enter the language to be translated to`nType fr for french, de for deutsche, it for italian"
if ($lang -eq "fr")
{
    $audio_language = 'fr-FR-DeniseNeural'
}
if ($lang -eq "de")
{
    $audio_language = 'de-DE-KatjaNeural'
}
if ($lang -eq "it")
{
    $audio_language = 'it-IT-IsabellaNeural'
}
write-host "Translating text..."
$result = Invoke-Webrequest -Method Post `
          -Uri "$endpoint/translate?api-version=3.0&from=en&to=$lang" `
          -Headers $headers `
          -Body $body 

$analysis = $result.content | ConvertFrom-Json
$translated_text = $analysis.translations.text 
Write-Host ("Original Text: $output`n`nTranslation: $translated_text`n")

$text = $translated_text

#You need to add your resource location if you use a Cognitive Services resource
$region="eastus2"

#The endpoint is global for the Translator service, DO NOT change it 
$endpoint="https://api.cognitive.microsofttranslator.com/"

$sml = "<speak version='1.0' xml:lang='en-US'><voice name='$($audio_language)'>
    $text
</voice>
</speak>"

$headers = @{}
$headers.Add( "Ocp-Apim-Subscription-Key", $key )
$headers.Add( "Content-Type","application/ssml+xml" )
$headers.Add( "X-Microsoft-OutputFormat","audio-16khz-128kbitrate-mono-mp3" )

$outputFile = "output.wav"

write-host "Synthesizing speech from translated text..."
$result = Invoke-RestMethod -Method Post `
    -Uri "https://$region.tts.speech.microsoft.com/cognitiveservices/v1" `
    -Headers $headers `
    -Body $sml `
    -OutFile $outputFile

write-host $result
write-host "Response saved in $outputFile `n"