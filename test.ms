clearListener(); print("Cleared in:\n"+getSourceFileName())


obj = selection[1]

(
    --local obj = $Box001 -- Change this to your object name
    local targetLayerName = "MyTargetLayer" -- Change this to your layer name

    -- 1. Force the visibility track to become a Script Controller
    -- This fixes the "Unknown property in true" error
    obj.visibility = float_script() 

    -- 2. Now that it is a controller, we can assign the script code to it
    obj.visibility.script = "
        local targetLayer = LayerManager.getLayerFromName \"" + targetLayerName + "\"
        if targetLayer != undefined then 
        (
            if targetLayer.on then 1.0 else 0.0
        )
        else 1.0
    "
    
    print "Success: Visibility controller created and bound."
)