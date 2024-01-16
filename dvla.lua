require("process")
require("terminal")
require("dataparser")
require("stream")
require("strutil")

API_KEY="GfFkqtGlAn78ZBYGzy5mJ3ZSSJHuGXvs1fxl9md8"
REG_NUM="BJ61GBU"


function LookupVehicle(RegNum)
local json, S, str, P

json="{\"registrationNumber\": ".."\"" .. RegNum .. "\"}"
args="w x-api-key="..API_KEY.." User-Agent=MOTCheck0.1 Content-Type=application/json Content-Length=" .. string.len(json)
S=stream.STREAM("https://driver-vehicle-licensing.api.gov.uk/vehicle-enquiry/v1/vehicles", args)
S:writeln(json)
S:commit()
str=S:readdoc()

if Conf.debug == true then print(str) end

P=dataparser.PARSER("json", str)
return(P)
end

function FormatTaxStatus(P)
local str

str=P:value("taxStatus")
if str=="Taxed" then return("~gTAXED: " .. P:value("taxDueDate") .. "~0 " ) end

return("~r"..str.."~0")

end

function FormatMOTStatus(P)
local str

str=P:value("motStatus")
if str=="Valid" then return("~gMOT: " .. P:value("motExpiryDate") .. "~0 ") end

return("~r"..str.."~0")

end



function PrintHelp()
print("dvla.lua 1.0 - print DVLA info for a car");
print("")
print("usage: ")
print("     lua dvla.lua [car license plate] <-api [apikey]> <-D>")
print("")
print("options: ")
print("     -api <key>    supply api key to use")
print("     -D            print debugging")
print("     -?            this help")
print("     -h            this help")
print("     -help         this help")
print("     --help        this help")
print("")
print("environment variables: ")
print("    DVLA_API_KEY         - supply api key as environment variable")
print("    DVLA_VEHICLE_REG     - supply car registration/licence plate as environment variable")
end


function Init()
local conf={}
local i,item

conf.debug=false
conf.api_key=process.getenv("DVLA_API_KEY")
conf.reg_num=process.getenv("DVLA_VEHICLE_REG")

for i,item in ipairs(arg)
do
  if item == '-api'
  then
    conf.api_key=arg[i+1]
    arg[i+1]=""
  elseif item == '-D'
  then
    conf.debug=true
    arg[i+1]=""
  elseif item == "-?" or item == "-h" or item == "-help" or item == "--help"
  then
  	PrintHelp()
	os.exit(0)
  else 
  if conf.reg_num == nil then conf.reg_num="" end
  conf.reg_num = conf.reg_num .. "," .. arg[i]
  end
end

return conf
end

function FormatCar(P)
return(string.format("~e~c%10s~0 %20s", P:value("registrationNumber"), P:value("yearOfManufacture") .. "-" .. P:value("make") .. "-" .. P:value("fuelType")))
end


Conf=Init()
if Conf.debug == true then process.lu_set("HTTP:Debug", "Y") end
term=terminal.TERM()

toks=strutil.TOKENIZER(Conf.reg_num, ",")
item=toks:next()
while item ~= nil
do
  if string.len(item) > 0
  then
    P=LookupVehicle(item)
    term:puts(FormatCar(P) ..  " " .. FormatTaxStatus(P) .. " " .. FormatMOTStatus(P) .. "\n")
  end

item=toks:next()
end


