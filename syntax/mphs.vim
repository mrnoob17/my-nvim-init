syn keyword Morphus_Constant NEXT Interacted_Summon Interacted_Character Player Narrator Primordial_Mage Received_Item Morphed_Name Morphed_Cap_Name Generic_Topic Taken_Item Item_Quantity Special_Narrator Interacted_Unit
syn keyword Morphus_Header Name End Start_Lines Traits lambda 
syn keyword Morphus_Conditionals if else_if !if !else_if else end_if
syn match Morphus_Identifier "@.*$"
syn match Morphus_String "\".*$" contains=Morphus_Constant
syn match Morphus_Command /^\s*\w\+/ contains=Morphus_Header,Morphus_Constant,Morphus_Conditionals
syn match Morphus_Comment "#.*$"
syn match Morphus_Number '\d\+'
syn match Morphus_Number '[-+]\d\+'

hi def link Morphus_Comment Comment
hi def link Morphus_Command Statement
hi def link Morphus_Conditionals Type
hi def link Morphus_Number Number
hi def link Morphus_String String
hi def link Morphus_Identifier Type
hi def link Morphus_Constant PreProc
hi def link Morphus_Header Type
