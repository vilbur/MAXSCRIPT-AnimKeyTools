clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../ObjectControllerKeys/ObjectControllerKeys.ms" )	--"./../../ObjectControllerKeys/ObjectControllerKeys.ms"
filein( getFilenamePath(getSourceFileName()) + "/../../KeyFrameManager/KeyFrameManager.ms" )	--"./../../KeyFrameManager/KeyFrameManager.ms"
filein( getFilenamePath(getSourceFileName()) + "/../RigWrapper.ms" )	--"./../RigWrapper.ms"
filein( getFilenamePath(getSourceFileName()) + "/../../PhaseCreator/PhaseCreator.ms" )	--"./../../PhaseCreator/PhaseCreator.ms"

RigWrapper = RigWrapper_v()
PhaseCreator = PhaseCreator_v()


RigWrapper.loadRig $boy_Setup_Ctrl_MasterControl_G

undo "mirrorPhases" on

RigWrapper.mirrorPhase ( Interval 1 3 )