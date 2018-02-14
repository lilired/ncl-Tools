load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

load "/LUSTRE/OPERATIVO/scripts/ncl/wrf/procesados/recursos.ncl"

;
;Notas
;
; Por eliminar comentarios
; Renombrar variables temp_2 y temp_3 por nombres apropiados ya que son las variables que contienen la informacion de alertas
;

;
; Forma de ejecutarlo 
;
; ncl Dom=2 arch=\"/LUSTRE/OPERATIVO/EXTERNO-salidas/WRF/2018/01_enero/wrfout_d02_2018-01-23_00.nc\" var_met=\"temp\" indice_f=0 alertas.ncl 
;
;srun -N1 -n1 --exclusive ncl Dom=$Dom arch=\"${SALIDA_WRF}\" arch_alerta=\"${SALIDA_ALERTA}\" var_met=\"${variable}\" indice_f=$ij $RAIZ_SISTEMA/scripts/ncl/wrf/paralelo/alertas.ncl > parallel_${ij}.log &
;


begin

;cmap = (/(/250,250,250/),(/0,0,0/), (/120, 0, 90/),\
;                 (/148, 0,   211/), \
;                 (/134, 205,   249/),\
;                 (/250, 250,   250/), \
;                 (/250, 250,   0/),\
;                 (/250, 187,   0/),\
;                 (/250, 0,   0/)/)/250.

;Fernandos-MBP:Downloads huracan$ vi seaice_2.txt 

;  1 # r   g   b
;  2   0   0 139
;  3   9  47 175
;  4  25 122 237
;  5 134 205 249
;  6  30 250 160
;  7 173 255  47
;  8 250 250   0
;  9 250 187   0
; 10 250 125   0
; 11 250   0   0
; 12 165  42  42
; 13 120   0  90
; 14 148   0 211
; 15 186  85 211
               

cmap = (/(/250,250,250/),(/0,0,0/),(/ 58,   0, 176/),\; (/9,47,145/),\
                 (/25,122,237/), \
                 (/ 134, 205, 249/),\
                 (/250, 250,   250/), \
                 (/250, 250,   0/),\
                 (/250, 187,   0/),\
                 (/250, 0,   0/)/)/250.


;-----------------------------------------------------------------------
; Archivo del modelo WRF a analizar...
;-----------------------------------------------------------------------

; Tomar archivo WRF para referencia del tiempo

    a    = addfile(arch,"r")

    Ruta_datos = "/LUSTRE/HOME/fernando/operativo/owgis/Alertas/2018/01_enero/"

    
    ; Si se desea hacer un zoom modificar la variable limits
    
    ;;;;; DEFINIR MES DE SESGO
    
    Xtimes = a->XTIME
    stime  = cd_string(Xtimes, "%D/%N/%Y %H:%M")  
    ltime  = cd_string(Xtimes, "%Y-%N-%D %H:%M")
    
    it=0
    fecha_p =   hora_local(ltime(it))
  
    l_dia2  = fecha_p[0]
    l_mes2  = fecha_p[1]
    
    mes_sesgo = fecha_p[1]
    
    Dominio = Dom    
    
    if var_met.eq."T2"
    
        Variable_indice="T2"
        bar_name = "temperatura"
    
    else
    
        Variable_indice="VIENTO"
        bar_name = "viento"
    end if
    
    
    archivo =  addfile(arch_alerta,"r") ; addfile( Ruta_datos + Variable_indice + "_dom" + Dominio + "_2018-01-22.nc","r") 
    
    
print(archivo)
    
    
;----------------------------------------------------------------------
;Definicion de constantes
;-----------------------------------------------------------------------

    times  = wrf_user_list_times(a)
    ;ntimes = dimsizes(times)
  
;-----------------------------------------------------------------------
;Empieza el loop del tiempo
;-----------------------------------------------------------------------

    lat2 = wrf_user_getvar(a,"lat",0)
    lon2 = wrf_user_getvar(a,"lon",0)

    lat = lat2(:,1)
    lon = lon2(1,:)
    
    sesgo_matrix  = archivo->$Variable_indice$

       
times_in_file = a->Times
   
do it = fig_i(indice_f),fig_f(indice_f) ;  indice_f,indice_f ;            ; Loop de tiempo

;--------------------------------------------------------------------------
; Estructura de textos
;----------------------------------------------------------------------------
    print(it)
    
    printVarSummary(sesgo_matrix)
    
    sesgo = sesgo_matrix(it,:,:)
    
    Xtimes = a->XTIME
    stime  = cd_string(Xtimes, "%D/%N/%Y %H:%M")  
    ltime  = cd_string(Xtimes, "%Y-%N-%D %H:%M")
    
    fecha_p = hora_local(ltime(it))
  
    l_dia2  = fecha_p[0]
    l_mes2  = fecha_p[1]
    l_anio2 = fecha_p[2]
    l_time2 = fecha_p[3]    

    ; Etiquetas de encabezados

    Titulo_info      = "Modelo WRF      " + stime(0) + " GMT"
    Titulo_info2     = "                     Pron" + oacute + "stico a " + sprinti("%0.3i",(it*1)) + " hrs"
    Titulo_info3     = "Hora Local CDMX " + l_time2 + ":00 " + l_dia2 + "/" + l_mes2 + "/" + l_anio2
    Titulo_variables = ("Indice de alerta para " + bar_name + " en superficie")

;-------------------------------------------------------------------------
; Obtencion de las variables
;-------------------------------------------------------------------------

    slp = wrf_user_getvar(a,"slp",it)      ; Get slp
	wrf_smooth_2d( slp, 3 )                ; Smooth slp
                            
    t2 = wrf_user_getvar(a,"T2",it)                   ; Get T2 (deg K)
	temp_2 = t2-273.16                              ; Convert to deg C
    
    printVarSummary(temp_2)
    
    slp@lat       := wrf_user_getvar(a,"XLAT",it)   ; latitude/longitude
    slp@lon       := wrf_user_getvar(a,"XLONG",it)  ; required for plotting
    slp!0         = "lat"
    slp!1         = "lon"
    slp@units     := ""
    slp@long_name := ""
    slp&lat       = lat
    slp&lon       = lon
    slp&lat@units = "degrees_north"
    slp&lon@units = "degrees_east"
    
    temp_2@lat       := wrf_user_getvar(a,"XLAT",it)   ; latitude/longitude
    temp_2@lon       := wrf_user_getvar(a,"XLONG",it)  ; required for plotting
    temp_2!0         = "lat"
    temp_2!1         = "lon"
    temp_2@units     := ""
    temp_2@long_name := ""
    temp_2@units     := Titulo_info2 + "~C~" +Titulo_info3       
    temp_2@long_name := Titulo_info  + "~C~" +  Titulo_variables
    temp_2&lat       = lat
    temp_2&lon       = lon
    temp_2&lat@units = "degrees_north"
    temp_2&lon@units = "degrees_east"
    
;-------------------------------------------------------------------------------
;   Descripcion del grafico
;-------------------------------------------------------------------------------
        
    nombre = ("d"+Dom+"_alerta_"+var_met+"_"+sprinti("%0.3i",(it*1))) ;Estructura el nombre del grafico "DOM1_120H_Viento10m_(Tiempo de pronostico)"

    type   = "png"
    wks    = gsn_open_wks(type,nombre)
    gsn_define_colormap(wks,"barra_temperatura_PEMEX_2")

;-----------------------------------------------------------------------
;   Detalles de los contornos de rapidez
;------------------------------------------------------------------------
  
    ;temp_res@lbTitleOn        = True                  ; turn on title
    temp_res@lbTitleString    = "Indice de alerta para " + bar_name + " en superficie"
    temp_res@lbTitleFontHeightF= .009 
    
    temp3 =sesgo
    
    ;temp3 =temp_2-sesgo
    
;    temp3 =temp_2

    ;temp3 =(sesgo*1); +20
    
    copy_VarMeta(temp_2,temp3)
    copy_VarCoords(temp_2,temp3)  
    
     limits = (/-118.0 ,-86.0, 14.0, 33.0/)
     
     Dominio = 2
     
     if Dominio .eq. 2
     
          limits = (/min(lon) ,max(lon), min(lat),max(lat)/)
    end if
     
    ; print(temp3)
     
     ;temp_res@cnLevelSelectionMode := "ManualLevels"
   ;temp_res@cnLevels    := (/0.01, 0.1,1,95.0,99.0,99.9/)   ; set levels
    temp_res@cnLevels    := (/0.1, 1.0,5.0,95.0,99.0,99.9/)   ; set levels
 
    ;temp_res@cnLevelSpacingF := 1
    ;temp_res@cnMinLevelValF  := -2
    ;temp_res@cnMaxLevelValF  := 2
    temp_res@cnLinesOn                := True           ; turn off contour lines
    ;temp_res@lbLabelStrings       := ispan(-2,2,1)
    ;gsn_define_colormap(wks,"NCV_jaisnd")
    ;gsn_define_colormap(wks,"temp_diff_18lev")
    ;gsn_define_colormap(wks,"nrl_sirkes_nowhite")
  gsn_define_colormap(wks,cmap)
    
    ;printVarSummary(temp3)
    
    ;temp3@_FillValue = 0
    temp_res@cnFillMode            = "CellFill"
    temp_res@cnMissingValFillColor = -1
    
    temp_res@cnLineLabelsOn  = False
    temp_res@cnLinesOn            = False
    
    ;temp_res@lbLabelPosition  = "Center"             ; label position
    ;temp_res@lbLabelAlignment = "BoxCenters"         ; label orientation
   ; temp_res@lbLabelStrings :=  (/"-3","-2","-1","1","2","3"/)
    ;temp_res@lbLabelStrings :=  (/"0.01","0.1","1.0","95.0","99.0","99.9"/)
     temp_res@lbLabelStrings :=  (/"0.1","1.0","5.0","95.0","99.0","99.9"/)

   ;  temp_res@cnFillPalette        = "BlWhRe"            ; set color map

    ;printVarSummary(temp3)
    
    ;print(max(temp3))
    ;print(min(temp3))
  gsn_define_colormap(wks,cmap);(::-1,::-1,::-1))
    
    contour = gsn_csm_contour_map(wks,temp3,temp_res)

;-----------------------------------------------------------------------
;   Detalles de los contornos de SLP
;------------------------------------------------------------------------
     
    contour_psl = gsn_csm_contour(wks,slp,slp_res)

;-----------------------------------------------------------------------
; Crear el grafico
;------------------------------------------------------------------------

       ; frame(wks)
	
     ;overlay(contour,contour_psl)
        draw(contour)   ; This will draw all overlaid plots and the map
	    frame(wks)

        delete(wks)

        fname=nombre
        convierte = "convert -trim " + fname + ".png " +fname + ".jpg"
	   
	   system(convierte)  
        
  end do    

        print("termina graficado")
        
end


/;

; ===========================================
; conLev_4.ncl
;
; Concepts illustrated:
;   - Explicitly setting contour levels
;   - Explicitly setting the fill colors for contours
;   - Reordering an array
;   - Removing the mean
;   - Drawing color-filled contours over a cylindrical equidistant map
;   - Turning off contour line labels
;   - Turning off contour lines
;   - Turning off map fill
;   - Turning on map outlines
;
; ===========================================
;
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl" 
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 

begin
  f      = addfile ("b003_TS_200-299.nc", "r")
  x      = f->TS(:,:,:)       ; Grab lowest sigma level (=17)
  newx   = dim_rmvmean_n_Wrap(x,0)

  wks = gsn_open_wks("png","conLev")       ; send graphics to PNG file
  gsn_define_colormap(wks,"BlRe")

  res             = True
  res@gsnMaximize = True                        ; maximize plot in frame
  res@mpFillOn    = False                       ; turn map fill off
  res@mpOutlineOn = True                        ; turn the map outline on
  res@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
  res@cnLevels    = (/ -12, -10.,-8.,-6.,-4.,-2.,-1.,1.,2.,4.,6.,8.,10.,12./)   ; set levels
  res@cnFillOn    = True                        ; turn on color fill
  res@cnLinesOn   = False                       ; turn off the contour lines
  res@cnFillColors = (/ 3,13,23,30,36,41,45,-1,59,63,68,74,81,91,96/)  ; set the colors to be used
  res@cnLineLabelsOn = False                    ; turn the line labels off

  plot = gsn_csm_contour_map(wks,newx(0,:,:),res)    
end     


;/


