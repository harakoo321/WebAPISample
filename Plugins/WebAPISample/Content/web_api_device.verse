
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/WebAPI }
using { /UnrealEngine.com/JSON }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
web_api_device := class(creative_device):

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        Print("Web API Device Started")
        JsonString := "\{\"hoge\" : \"fuga\",\"foo\" : \"bar\"\}"
        
        #Client := MakeClient()
        #Response := Client.Get("https://api.example.com")

        if:
            Result := Parse[JsonString]
            #Print("AsString: {Result.AsString[]}") Fail
            ValueObject := Result.AsObject[]
            Print("AsObject:")
            for (Key -> Value : ValueObject):
                Print("{Key} : {Value.AsString[]}")
            <# Fail
            ValueArray := Result.AsArray[]
            Print("AsArray:")
            for (Index -> Value : ValueArray):
                Print("{Index} : {Value.AsString[]}")
            #>
        else:
            Print("Failed")

    Serialize(JsonString : string):void=
        if:
            Result := Parse[JsonString]
        else:
            Print("Failed")

    SerializeValue(Json : value) : string=
        if (String := Json.AsString[]):
            return String
        else if (Integer := Json.AsInt[]):
            return "{Integer}"
        else if (Float := Json.AsFloat[]):
            return "{Float}"
        else if (Json.AsNull[]):
            return "null"
        else if (ValueArray := Json.AsArray[]):
            return SerializeValues(ValueArray)
        else if (ValueObject := Json.AsObject[]):
            return SerializeObjects(ValueObject)
        else:
            return ""

    SerializeValues(JsonArray : []value) : string =
        if (X := JsonArray[0], Xs := JsonArray.RemoveElement[0]):
            return SerializeValue(X) + SerializeValues(Xs)
        else:
            return ""

    SerializeObjects(JsonObjects : [[]char]value) : string =
        if (X := JsonObjects[0], Xs := JsonObjects.RemoveElement[0]):
            return SerializeObject(X) + SerializeObjects(Xs)
        else:
            return ""
