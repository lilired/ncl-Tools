;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;   Script para graficar el plot de precipitacion acumulada
; 
;      
;   Elaborado por
;
;   Fernando Nicolas Arellano Guerrero - fnag@atmosfera.unam.mx
;   Liliana Ayala Fuentes
;
; Ponostico CCA: Pro=1 , Dom=1,2,
;
; ncl Dom=1 Pro=1 rfile=\"/DATA/editor_graficas/work/wrf_salidas/\"  afile=\"wrfout_d01_2016-04-18_00.nc\" pcpcn_streamlines_s_prueba.ncl ; Forma de ejecutar codigo en terminal
; ncl Dom=1 Pro=1 pcpcn_streamlines_s.ncl ; Forma de ejecutar codigo en terminal

;Nota: este codigo nombre anterior pcpcn_streamlines_s_prueba_fer.ncl
;esta almacenado en /DATA/editor_graficas/work/ncl_wrf/entregables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Example of using panels with WRF data

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;----------------------------------------------------------------------------------
; Parametros particulares de cada dominio para posicion de textos, 
; archivos a leer, densidad de vectores a graficas y coordenadas de
; los subdominios.
;----------------------------------------------------------------------------------

  if ((Dom .eq. 1) .and. (Pro .eq. 1))then
    a          = addfile("variablest_1.nc","r")
  Titulo_pos = (/0.35, 0.98 , 0.63, 0.027, 0.60 /)
    n_vec=30
  else if ((Dom .eq. 2) .and. (Pro .eq. 1)) then
    a          = addfile("variablest_2.nc","r")
    Titulo_pos = (/0.35, 0.98 , 0.64-0.03, 0.03, 0.6-0.03 /)
    n_vec=20
  else
    configuracion = 999
  end if
  end if

;------------
; Archivo WRF
;------------

Dominio = Dom




Ruta_wrf= rfile ;"/home/pron_meteo/scripts/ncl/wrf_salidas/"
Arch_wrf= afile ;

ruta_com=Ruta_wrf+Arch_wrf

a_wrf = addfile(ruta_com,"r")

;------------------------
; Propiedades del grafico
;------------------------

  ; Opciones basicas de graficado

  res                = True
  res@NoHeaderFooter = True
  res@Footer         = False
  ;res@Header        = False   
  pltres             = True
  pltres@NoTitles    = True; Set to True to remove all field titles on a plot.
  res                = True
  res@NoHeaderFooter = False         ;mod
  res@Footer         = False      ;mod
  res@Header         = False  
  res@cnLineLabelsOn = False

 ; res                = True
  res@gsnFrame       = False
  res@gsnDraw        = False
  res@gsnLeftString  = ""
  res@gsnRightString = ""

;---Necessary for contours to be overlaid correctly on WRF projection
 ; res@tfDoNDCOverlay = True

  oacute  = "o~H-13V2F35~B~FV-2H3~" ;acento

  ; Detalles de la division politica
  mpres                             = True  
  mpres@mpGeophysicalLineColor      = "Black"
  mpres@mpNationalLineColor         = "Black"
  mpres@mpUSStateLineColor          = "Black"
  mpres@mpGridLineColor             = "Black"
  mpres@mpLimbLineColor             = "Black"
  mpres@mpPerimLineColor            = "Black"
  mpres@mpGeophysicalLineThicknessF = 2.0
  mpres@mpGridAndLimbOn=True
  mpres@mpDataSetName               = "Earth..4"   ; This new database contains
                                           ; divisions for other countries.
  mpres@mpDataBaseVersion           = "MediumRes"  ; Medium resolution database
  mpres@mpOutlineOn                 = True         ; Turn on map outlines
  mpres@mpOutlineSpecifiers         = (/"Mexico:states"/)
  mpres@mpFillOn                   = True         ; Turn on map fill
 mpres@mpLandFillColor        = "transparent"
  mpres@mpLandFillColor       = "white"        ; set to white  
    res@mpSpecifiedFillColors = "white"              ; area colors

  mpres@mpFillBoundarySets          = "National"
  mpres@mpFillAreaSpecifiers        = (/"Mexico:states"/)
  mpres@mpMaxLatF                   = 40          ;  South America limits
  mpres@mpMinLatF                   = 5
  mpres@mpMaxLonF                   = 320
  mpres@mpMinLonF                   = 250
  mpres@tmXBMajorOutwardLengthF     = -0.00	; set tickmarks
  mpres@mpGeophysicalLineThicknessF = 3.0
  mpres@mpLimbLineThicknessF        = 2.0
  mpres@mpNationalLineThicknessF    = 2.0
  mpres@mpUSStateLineThicknessF     = 2.0

  if Dom .eq. 3  then
     mpres@mpLimbLineThicknessF        = 3.5
     mpres@mpNationalLineThicknessF    = 3.5
     mpres@mpUSStateLineThicknessF     = 3.5 
     mpres@mpGeophysicalLineThicknessF = 4.0
  else if Dom .eq. 2 then
     mpres@mpLimbLineThicknessF        = 3.5
     mpres@mpNationalLineThicknessF    = 3.5
     mpres@mpUSStateLineThicknessF     = 3.5 
     mpres@mpGeophysicalLineThicknessF = 4.0
  end if
  end if
 
  if (Pro .eq. 2) .and. (Dom_aux .eq. 2)          
     mpres@tiMainString        = ". ~C~ .~C~ .~C~ ."
     mpres@tiMainFontColor     = "White"
  end if
  
   ;mpres@mpShapeMode  = "FreeAspect"
   mpres@vpWidthF      = 0.7
   mpres@vpHeightF     = 0.825
 
 ;res@mpShapeMode  = "FreeAspect"
 ;res@vpWidthF      = 0.513
 ;res@vpHeightF     = 0.825

;-------------------------------
; Lectura de variables a grafcar
;-------------------------------
  meses            = (/"","01","02","03","04","05","06","07","08","09","10","11","12"/)

  times            = wrf_user_list_times(a_wrf)
  ntimes           = dimsizes(times)

  preci_tot_global = a->preci_tot
   contador        = ntimes-1 


;-------------------------------
; Lectura de variables a grafcar
;-------------------------------
  u_global       = a->u10
  v_global       = a->v10

;------------------------------------------------------------------------------------------------------------------
; Inicia ciclo de tiempo
;----------------------
  do it = 0,ntimes-1;contador             
           
    if Pro .eq. 2           ;
       Dom = Dom_aux
    end if

    ; Descripcion del grafico
    nombre = ("pcpcn_streamlines_s_"+ Pro + Dom + "_"+  sprinti("%0.3i",(it*1-1)));
        
    type   = "png"
    wks     = gsn_open_wks(type,nombre)
    gsn_define_colormap(wks,"barra_precipitacion_PEMEX")

   ; Obtencion de las variables
        if Pro .eq. 1 then                 
            u_viento = u_global(it,:,:) 
            v_viento = v_global(it,:,:) 
            preci_tot = preci_tot_global(it,:,:);+0.001 ; preci_tot_global(it,:,:)
        else 
          u_viento = u_global(it,{Esquinas(0):Esquinas(1)},{Esquinas(3):Esquinas(2)}) 
          v_viento = v_global(it,{Esquinas(0):Esquinas(1)},{Esquinas(3):Esquinas(2)}) 
          preci_tot = preci_tot_global(it,{Esquinas(0):Esquinas(1)},{Esquinas(3):Esquinas(2)}) +0.001
          printVarSummary(preci_tot_global)
        end if

   ;----------------------------------------------
   ; Detalles de los contornos de precipitacion
   ;----------------------------------------------

    opts_r                           = res
    opts_r@cnLinesOn            = False
    opts_r@FieldTitle                = ""            
    opts_r@InitTime                  = False
    opts_r@cnConstFLabelOn           = False
    opts_r@cnFillOn                  = True
    opts_r@cnExplicitLabelBarLabelsOn=True
    opts_r@lbLabelStrings            =  (/" 1",""," 3",""," 5"," 10"," 15"," 20",\
                                          " 30"," 40"," 50"," 100"," 150"," 200"," 300"," 400"/)
    opts_r@cnLevelSelectionMode      = "ExplicitLevels"
    opts_r@cnLevels                  = (/ 1, 2, 3, 4, 5, 10, 15, 20, 30, \
                                        40, 50, 100, 150, 200, 300, 400 /)
    opts_r@lbLabelFontHeightF        = 0.012
    opts_r@lbOrientation              = "vertical"
    
    opts_r@lbLabelJust ="CenterLeft"
    opts_r@lbLabelOffsetF = 0.5
    opts_r@lbBottomMarginF = 0.0
    opts_r@lbTopMarginF = 0.2
    opts_r@lbLabelAlignment ="InteriorEdges"
    opts_r@lbLeftMarginF = 0.4;
    opts_r@lbRighMarginF = 0.4;
    opts_r@lbLabelOffsetF  = 0.4;
    opts_r@pmLabelBarOrthogonalPosF  = -0.1/1.5

       preci_graf             =  preci_tot;
        preci_graf@description = "Precipitacion acum. cada 1 horas" 
      

    if Pro .eq. 1                  ;
      opts_r@lbLabelOffsetF   = 0.025
    else
      if Dom_aux .eq. 1
        opts_r@lbLabelOffsetF = 0.0250
      else
        opts_r@lbLeftMarginF  = 0.35 ;asi funciona para D1 pemex
      end if
    end if

  ;  contour_tot = wrf_contour(a_wrf,wks, preci_graf, opts_r)
   ; delete(opts_r)

   contour_tot =  gsn_csm_contour(wks,preci_graf, opts_r)
    contour_tot@FieldTitle = ""
    delete(opts_r)

  resvector                 = res
  resvector@NumVectors         = n_vec
  resvector@vcMinDistanceF   = 0.02
  resvector@vcWindBarbLineThicknessF = 1.0
  resvector@cnInfoLabelOn            = False
  resvector@cnConstFLabelOn          = False
  resvector@vcMonoLineArrowColor     = True
  resvector@vcLineArrowColor         = "blue"
  resvector@gsnScalarContour         = True 
  resvector@vcRefLengthF     = 0.06  
  resvector@vcMinFracLengthF = 0.2
  resvector@vcGlyphStyle     = "CurlyVector"
  resvector@vcRefAnnoOn      = False

  ;---------------------------------
  ; Detalles de las barbas de viento
  ;---------------------------------

  opts = resvector
  ;vector = wrf_vector(a_wrf,wks,u_viento,v_viento,opts)

  vector = gsn_csm_vector(wks,u_viento,v_viento,opts)
  delete(opts)

   ;-------------------------
   ; Estructura de textos
   ;-------------------------
 
    fecha=times(it)
    fechaUTC=stringtochar(fecha)

    anio1=(fechaUTC(2:3))
    anio2=chartostring(anio1)
    anio3=stringtoint(anio2)

    mes1=(fechaUTC(5:6))
    mes2=chartostring(mes1)
    mes3=stringtoint(mes2)

    dia1=(fechaUTC(8:9))
    dia2=chartostring(dia1)
    dia3=stringtoint(dia2)

    hora1=(fechaUTC(11:12))
    hora2=chartostring(hora1)
    hora3=stringtoint(hora2)

    ; Inicia fechas

    a_anio = anio3
    a_mes  = mes3
    a_dia  = dia3
    a_time = hora3

    ; Juliano fecha actual GMT
    juli_gmt = greg2jul(a_anio,a_mes,a_dia,a_time)
    juli_local=juli_gmt-1./4

    fecha_actual=jul2greg(juli_local)
    
    l_anio =fecha_actual(0)
    l_mes  =fecha_actual(1)
    l_dia  =fecha_actual(2)
    l_time =fecha_actual(3)     ;print(fecha_actual)

    ; Datos de fechas de cambio de horario
   
     hora_inicio = 8
     dia_inicio  = (/ 6, 5, 3, 2, 1, 7, 5, 4, 3, 2, 7, 6, 5, 4, 2/)
     mes_inicio  = 4
     hora_fin    = 7
     dia_fin     = (/26,25,30,29,28,27,25,31,30,29,27,26,25,31,29/)
     mes_fin     = 10

     indice=a_anio+2000-2014

     ; Determina intervalo en el que se aplicara el cambio de horario
   
     juli_inicio = greg2jul(a_anio,mes_inicio,dia_inicio(indice),hora_inicio)
     juli_fin    = greg2jul(a_anio,mes_fin,dia_fin(indice),hora_fin)

     ; Calcula dia juliano de la fecha local actual

     juli_actual = greg2jul(a_anio,a_mes,a_dia,a_time)

     if ((juli_gmt .ge. juli_inicio) .and. (juli_gmt .le. juli_fin))
	print("si hay cambio")
	juli_local=juli_gmt-5./24
	fecha_actual=jul2greg(juli_local)
        l_anio2 =fecha_actual(0)
        l_mes2  =fecha_actual(1)
        l_dia2  =fecha_actual(2)
        l_time2 =fecha_actual(3)
     else
	;print("no hay cambio")
	l_anio2 =fecha_actual(0)
	l_mes2  =fecha_actual(1)
	l_dia2  =fecha_actual(2)
	l_time2 =fecha_actual(3)
     end if

     if (it .eq. 0)
      	t_inicio=hora1
       	d_inicio=dia1
	m_inicio=a_mes
        a_inicio=a_anio
     end if

  ;--------------------------
  ; Textos para el encabezado
  ;--------------------------

     print("Fecha GMT  : " +a_anio+"/"+a_mes+"/"+a_dia+"/"+a_time+"   "+"Fecha Local: " +l_anio+"/"+l_mes+"/"+l_dia+"/"+l_time+"   "+"Fecha Local2: " +l_anio2+"/"+l_mes2+"/"+l_dia2+"/"+l_time2)

     Titulo_info        = ("Modelo WRF      "+d_inicio+"/"+sprinti("%0.2i",m_inicio)+"/"+a_inicio+" "+t_inicio+":00 GMT")
     Titulo_info2       = (" Pron"+oacute+"stico a "+sprinti("%0.3i",(it*1))+" hrs")
     Titulo_info3       = ("  Hora Local " + \
sprinti("%0.2i",l_time2)+":00 "+sprinti("%0.2i",l_dia2)+"/"+sprinti("%0.2i",l_mes2)+ \
          "/"+sprinti("%0.2i",l_anio2))
     Titulo_variables   = ("Precipitaci"+oacute+"n acumulada cada hora (mm)")

     if Pro.eq. 1
       Titulo_variables = ("Precipitaci"+oacute+"n acumulada total (mm)")
     end if

   ;-----------------
   ; posicion de texto
   ;-----------------

    tjust               = (/"BottomLeft", "BottomRight"/)
   
    txres               = True       
    txres@txFontHeightF = 0.013                     
        
    txres@txJust        = tjust(0)
        
    gsn_text_ndc(wks, Titulo_info,Titulo_pos(0) ,Titulo_pos(2) + Titulo_pos(3) ,txres)
    gsn_text_ndc(wks, Titulo_variables ,Titulo_pos(0) ,Titulo_pos(2)  ,txres)
        
    txres@txJust         = tjust(1)
    gsn_text_ndc(wks, Titulo_info2,Titulo_pos(1),Titulo_pos(2) + Titulo_pos(3) ,txres)
    gsn_text_ndc(wks, Titulo_info3     ,Titulo_pos(1) ,Titulo_pos(2)  ,txres)
        
    txres@txJust          = tjust(1)
    gsn_text_ndc(wks, "(mm)"         ,Titulo_pos(1)-0.005,Titulo_pos(4) ,txres)
        
   ;---------------
   ; Otros dominios
   ;---------------     
        
    if Pro .eq.2                               ;
      mpres@mpLeftCornerLatF  =  Esquinas(0); 
      mpres@mpRightCornerLatF =  Esquinas(1); 
      mpres@mpLeftCornerLonF  =  Esquinas(2); 
      mpres@mpRightCornerLonF =  Esquinas(3); 
    end if      
      
   map_res               = mpres
   map_res@gsnFrame      = False
   map_res@gsnDraw       = False
   map_res@gsnLeftStringFontHeightF = 0.01
   map_res = wrf_map_resources(a_wrf,map_res)

   map = gsn_csm_map(wks,map_res)

   ; the WRF plots. 
   ;  plot    = wrf_map_overlays(a_wrf,wks,(/contour_tot,vector/),pltres,mpres)

   overlay(map,contour_tot)
   overlay(map,vector)
   
   times_sav = times(it*1)
   FirstTime = False
  
   draw(map)   ; This will draw all overlaid plots and the map
   frame(wks)
        
   ;----------------
   ; Edicion grafico 
   ;----------------     
     fname     = nombre ;+ "_" + sprinti("%0.3i",(it*1))
     print(fname)
       
     if Pro .eq. 1 then
        convierte = "convert " + fname + ".png  -trim logo_cca_2_original.jpg  -geometry +0+0 -composite " +fname + ".png"
     else if ((Pro .eq. 2) .and. (Dom .eq. 2)) then
        convierte = "convert " + fname + ".png  -trim logo_pemex.jpg  -geometry +92+60 -gravity NorthEast -composite " +fname + ".png"
     else
        convierte = "convert " + fname + ".png  -trim logo_pemex.jpg  -geometry +0+0 -composite " +fname + ".png"
     end if
     end if
     
     print(fname)
     print(convierte)
     system(convierte)     
        
     end do   

;-------------------
; Fin ciclo de tiempo
;-----------------------------------------------------------------------------------------------------------------------------
 system ("rm pcpcn_streamlines_s_"+Pro+Dom+"_-001.png ")
  ;system ("mv pcpcn_streamlines_s_*.png figuras")
end
