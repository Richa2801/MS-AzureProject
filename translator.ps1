#Key
$key="9769025537904de7b0e87ce7a0a23a6c"

#You need to add your resource location if you use a Cognitive Services resource
$location="eastus2"

#The endpoint is global for the Translator service, DO NOT change it 
$endpoint="https://api.cognitive.microsofttranslator.com/"

# Code to call Text Analytics service to analyze sentiment in text
$headers = @{}
$headers.Add( "Ocp-Apim-Subscription-Key", $key )
$headers.Add( "Ocp-Apim-Subscription-Region", $location )
$headers.Add( "Content-Type","application/json" )

$output = Read-Host "Type any text to be translated"

$body = "[{'text': '$output'}]" 

write-host "Translating text..."
$result = Invoke-Webrequest -Method Post `
          -Uri "$endpoint/translate?api-version=3.0&from=en&to=fr" `
          -Headers $headers `
          -Body $body 

$analysis = $result.content | ConvertFrom-Json
$translated_text = $analysis.translations.text 
Write-Host ("Original Text: $output`nTranslation: $translated_text`n")