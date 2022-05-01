tool
extends EditorPlugin

#*******************************************************************************/
#------------------------------BEAUTIFY COMMENTS------------------------------*/
#--------------This little tool is meant to auto detect comments--------------*/
#------------- Just start commenting with "#" + "special caracter"-------------*/
#<<<<<<<<<<It will automaticallu change the text once you change line>>>>>>>>>>*/
#*******************************************************************************/



#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<SOME VARIABLES>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/

var script_editor : TextEdit
var cursor_line = -1
var myNewText = null
var beatyLines = "--------------------------------------------------------------------------------"
var argomenti = [
	"#!",
	"#£",
	"#$",
	"#|",
	"#$",
	"#%",
	"#&",
	"#/",
	"#(",
	"#)",
	"#=",
	"#?",
	"#^",
	"#@",
	"#<",
	"#>",
	"#-",
	"#+",
	"#*"]


#---------------------------CONNECTING FOCUS CHANGED---------------------------*/

func _ready():
	get_viewport().connect("gui_focus_changed",self,"_on_gui_focus_changed2")


#--------Each time focus change it disconects and reconects the signal--------*/
#-------------------It checks if the argument is a TextEdit-------------------*/

func _on_gui_focus_changed2(nodo):
	if nodo is TextEdit:
		if is_instance_valid(script_editor):
			script_editor.disconnect("cursor_changed",self,"_on_cursor_changed")
		script_editor = nodo
		script_editor.connect("cursor_changed",self,"_on_cursor_changed")



#--Check if the var cursor_line is different from the actual cursor position--*/
#-------------Calls the function stringWork to make magic happend-------------*/
#-----------------------------Updates cursor_line-----------------------------*/

func _on_cursor_changed():
	if is_instance_valid(script_editor):
		if cursor_line != script_editor.cursor_get_line():
			stringWork(cursor_line)
			cursor_line = script_editor.cursor_get_line()


#-----------------------------Makes magic Happend-----------------------------*/

func stringWork(line):
	var myString = script_editor.get_line(line)
	myString.strip_edges(true,true)
	if myString.substr(0,1) == "#":
		var whatSign = myString.substr(1,1)
		if myString.ends_with("*/"):
			return
		if argomenti.has(myString.substr(0,2)):
			myNewText = str((constructingLine(whatSign,int((beatyLines.length()-myString.length())/2),1)),myString.substr(2,myString.length()))
			var secondpart = str((constructingLine(whatSign,int((beatyLines.length()-myString.length())/2),2)))
			myNewText = str("#"+myNewText+secondpart+"*/") 
			script_editor.set_line(line,myNewText)


#----------------------Construct the new line of comment----------------------*/

func constructingLine(signn,manys,part):
	var partialLine = ""
	if part == 1:
		for i in manys:
			partialLine += signn 
	if part == 2:
		if signn == "<":
			for i in manys:
				partialLine += ">"
		elif signn == ">":
			for i in manys:
				partialLine += "<"
		elif signn == "(":
			for i in manys:
				partialLine += ")"
		elif signn == ")":
			for i in manys:
				partialLine += "("
		else:
			for i in manys:
				partialLine += signn
	return partialLine
