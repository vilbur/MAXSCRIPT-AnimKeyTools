clearListener(); print("Cleared in:\n"+getSourceFileName())



obj	= selection[1]

Turn_to_Poly_mod = Turn_to_Poly limitPolySize:on maxPolySize:4

addModifier obj Turn_to_Poly_mod
--deleteModifier obj Turn_to_Poly_mod

