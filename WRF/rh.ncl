
;   Script para obtener el viento a 10m en 120 horas
;   con una resoluacion temporal de una hora.
;   Final 0.0


; time ncl Dom=1 Pro=1 rfile=\"/home/lili/Escritorio/repos/ncl/\"  afile=\"wrfout_d01_2016-04-18_00.nc\" pcpcn_acum.ncl


load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"


begin


;float QVAPOR(Time, bottom_top, south_north, west_east) ; QVAPOR:FieldType = 104 ; QVAPOR:MemoryOrder = "XYZ" ; QVAPOR:description = "Water vapor mixing ratio" ; QVAPOR:units = "kg kg-1" ; QVAPOR:stagger = "" ; QVAPOR:coordinates = "XLONG XLAT XTIME" ;

Ruta_wrf= rfile ;
 printVarSummary(Ruta_wrf)
Arch_wrf= afile ;
 printVarSummary(Arch_wrf)
ruta_com=Ruta_wrf+Arch_wrf
 printVarSummary(ruta_com)

a= addfile(ruta_com,"r")

 qv = a->QVAPOR
 printVarSummary(qv)
  P  = a->P                     ; perturbation
print("imprimir perturbation")
  Pb = a->PB                    ; base state pressure
print("imprimir p")  
P  = P + Pb                   ; total pressure

  theta = a->T                  ; perturbation potential temperature (theta+t0)
  theta = theta + 300

print("imprimir theta")

  TK = wrf_tk (P, theta)
  RH = wrf_rh (qv, P, TK)

  printVarSummary(RH)


return_val@description = "Relative Humidity"
return_val@units = "%" 
end
