procedure addInter(fin,fout,dim_time, dim_lat, dim_lon) begin
    WS10 = fout->WS10; Carga la variable WS10
    U10 = fout->Uat10; Carga la variable U10
    V10 = fout->Vat10; Carga la variable V10

    ;Variables a necesitar algunas estan comentadas debido a innecesidad.
    ;tc = wrf_user_getvar(f,"T2C",-1)        ; T in C

    print("Creating average variables...")
    u  = wrf_user_getvar(fin,"ua",-1)        ; u averaged to mass points
    v  = wrf_user_getvar(fin,"va",-1)        ; v averaged to mass points
    p  = wrf_user_getvar(fin, "pressure",-1) ; pressure is our vertical coordinate

    ;Distintos niveles de Presion
    pressure_levels =(/250, 500, 700, 850/)
    do varIdx =0,dimsizes(pressure_levels)-1,1 ; This loop iterates over the variables
        print("Interpolating variables for pressure level:"+ pressure_levels(varIdx) )

        u_plane  = wrf_user_intrp3d( u,p,"h",pressure_levels(varIdx),0.,False)
        v_plane  = wrf_user_intrp3d( v,p,"h",pressure_levels(varIdx),0.,False)

        u_plane@FieldType = 104 ;
        u_plane@MemoryOrder = "XY " ;
        u_plane@description = "U at "+pressure_levels(varIdx)+" hPA" ;
        u_plane@units = "m s-1" ;
        u_plane@standard_name = "eastward_wind_"+pressure_levels(varIdx)

        v_plane@FieldType = 104 ;
        v_plane@MemoryOrder = "XY " ;
        v_plane@description = "V at "+pressure_levels(varIdx)+" hPA" ;
        v_plane@units = "m s-1" ;
        v_plane@standard_name = "northward_wind_"+pressure_levels(varIdx)

        ;Aqui se realizan los calculaos de velocidad a cierto nivel de presion y se convierten a km/hr

        spd = new((/dim_time,dim_lat,dim_lon/),double)
        spd = (((u_plane*u_plane + v_plane*v_plane)^(0.5))*3.6) ; km/hr
        spd!0 = "Time"
        spd!1 = "Latitude"
        spd!2 = "Longitude"
        spd@description = "Wind Speed at "+pressure_levels(varIdx)+"Hp/Velocidad del viento a "+pressure_levels(varIdx)+"Hp"
        spd@units = "km/hr"
        spd@standard_name = "upward_wind_velocity_"+pressure_levels(varIdx)


        ;Se guardan U,V a diferentes niveles de presion 200,500,700,850
        uVarName = "Uat"+pressure_levels(varIdx)
        vVarName = "Vat"+pressure_levels(varIdx)
        wsName = "WSat"+pressure_levels(varIdx)

        filevardef(fout, uVarName, typeof(u_plane), (/"Time","Latitude","Longitude" /) )
        filevardef(fout, vVarName, typeof(v_plane), (/"Time","Latitude","Longitude" /) )
        filevardef(fout, wsName, typeof(spd),(/"Time","Latitude","Longitude" /) )

        filevarattdef(fout,uVarName,u_plane); copy u_plane attributes
        filevarattdef(fout,vVarName,v_plane); copy u_plane attributes
        filevarattdef(fout,wsName,spd); copy u_plane attributes

        fout->$uVarName$= (/u_plane/);                      
        fout->$vVarName$= (/v_plane/);                      
        fout->$wsName$= (/spd/);                      

        print("Done!")
        delete(u_plane)
        delete(v_plane)
        delete(spd)
    end do
end

