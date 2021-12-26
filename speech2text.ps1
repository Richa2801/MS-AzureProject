#Key
$key="9769025537904de7b0e87ce7a0a23a6c"

#You need to add your resource location if you use a Cognitive Services resource
$location="eastus2"

# Code to call Speech to Text API
$wav = "./data/speech/ENG_M.wav"

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
