;start procedure addInter
procedure addInter(fin,fout,dim_time, dim_lat, dim_lon) begin
    WS10 = fout->WS10; Carga la variable WS10;get variable in fin
    U10 = fout->Uat10; Carga la variable U10;get variable in fin
    V10 = fout->Vat10; Carga la variable V10;get variable in fin

    ;Variables a necesitar algunas estan comentadas debido a innecesidad.
    ;tc = wrf_user_getvar(f,"T2C",-1)        ; T in C;get variable in fin

    print("Creating average variables...")
    u  = wrf_user_getvar(fin,"ua",-1)        ; u averaged to mass points
    v  = wrf_user_getvar(fin,"va",-1)        ; v averaged to mass points
    p  = wrf_user_getvar(fin, "pressure",-1) ; pressure is our vertical coordinate

    ;Distintos niveles de Presion
    pressure_levels =(/250, 500, 700, 850/);set variable

    ;start of variables cycle 
    ;;;;;;; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(pressure_levels)-1,1 ; This loop iterates over the variables
        print("Interpolating variables for pressure level:"+ pressure_levels(varIdx) )

        u_plane  = wrf_user_intrp3d( u,p,"h",pressure_levels(varIdx),0.,False);function to interpolate
        v_plane  = wrf_user_intrp3d( v,p,"h",pressure_levels(varIdx),0.,False);function to interpolate

        u_plane@FieldType = 104 ;;atributes
        u_plane@MemoryOrder = "XY " ;;atributes
        u_plane@description = "U at "+pressure_levels(varIdx)+" hPA" ;;atributes
        u_plane@units = "m s-1" ;;atributes
        u_plane@standard_name = "eastward_wind_"+pressure_levels(varIdx);atributes

        v_plane@FieldType = 104 ;;atributes
        v_plane@MemoryOrder = "XY " ;;atributes
        v_plane@description = "V at "+pressure_levels(varIdx)+" hPA" ;;atributes
        v_plane@units = "m s-1" ;;atributes
        v_plane@standard_name = "northward_wind_"+pressure_levels(varIdx);atributes

        ;Aqui se realizan los calculaos de velocidad a cierto nivel de presion y se convierten a km/hr

        spd = new((/dim_time,dim_lat,dim_lon/),double)
        spd = (((u_plane*u_plane + v_plane*v_plane)^(0.5))*3.6) ; km/hr
        spd!0 = "Time";atributes
        spd!1 = "Latitude";atributes
        spd!2 = "Longitude";atributes
        spd@description = "Wind Speed at "+pressure_levels(varIdx)+"Hp/Velocidad del viento a "+pressure_levels(varIdx)+"Hp";atributes
        spd@units = "km/hr";atributes
        spd@standard_name = "upward_wind_velocity_"+pressure_levels(varIdx);atributes


        ;Se guardan U,V a diferentes niveles de presion 200,500,700,850
        uVarName = "Uat"+pressure_levels(varIdx)
        vVarName = "Vat"+pressure_levels(varIdx)
        wsName = "WSat"+pressure_levels(varIdx)

        filevardef(fout, uVarName, typeof(u_plane), (/"Time","Latitude","Longitude" /) ); time dimension
        filevardef(fout, vVarName, typeof(v_plane), (/"Time","Latitude","Longitude" /) ); time dimension
        filevardef(fout, wsName, typeof(spd),(/"Time","Latitude","Longitude" /) ); time dimension

        filevarattdef(fout,uVarName,u_plane); copy u_plane attributes
        filevarattdef(fout,vVarName,v_plane); copy u_plane attributes
        filevarattdef(fout,wsName,spd); copy u_plane attributes

        fout->$uVarName$= (/u_plane/);    ;add in file fout                  
        fout->$vVarName$= (/v_plane/);    ;add in file fout                  
        fout->$wsName$= (/spd/);;add in file fout

        print("Done!")
        delete(u_plane)
        delete(v_plane)
        delete(spd)
    end do
    ;end of variables cycle 
end
;end procedure addInter

