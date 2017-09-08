procedure add3DVars(varNames,fin,fout,dim_time, dim_lat,dim_lon) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
        
        if varNames(varIdx) .eq. "PM05" then
           varNamesO=(/"C_PM05_GRND"/)
           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	      	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
;delete_VarAtts(newVar, (/"coordinates"/))
              newVar@long_name= "PM05" ;
	      newVar@standard_name = "PM05" ;
	end if
    


if varNames(varIdx) .eq. "PM10" then
           varNamesO=(/"C_PM10_GRND"/)
           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	      	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
;delete_VarAtts(newVar, (/"coordinates"/))

              newVar@long_name= "PM10" ;
	      newVar@standard_name = "PM10" ;
            end if


if varNames(varIdx) .eq. "PM20" then
           varNamesO=(/"C_PM20_GRND"/)
           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	      	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
     ;delete_VarAtts(newVar, (/"coordinates"/))

              newVar@long_name= "PM20" ;
	      newVar@standard_name = "PM20" ;
	end if
        if varNames(varIdx) .eq. "consentration_50" then
           varNamesO=(/"C_FL050"/)
           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
           ;delete_VarAtts(newVar, (/"coordinates"/))
     
           newVar@long_name= "consentration_50" ;
	  newVar@standard_name = "consentration_50" ;
	end if
    
if varNames(varIdx) .eq. "consentration_100" then
           varNamesO=(/"C_FL100"/)
           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
           ;delete_VarAtts(newVar, (/"coordinates"/))
     
           newVar@long_name= "consentration_100" ;
	  newVar@standard_name = "consentration_100" ;
	end if
    
if varNames(varIdx) .eq. "consentration_150" then
           varNamesO=(/"C_FL150"/)
           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
           ;delete_VarAtts(newVar, (/"coordinates"/))
     
           newVar@long_name= "consentration_150" ;
	  newVar@standard_name = "consentration_150" ;
	end if
    
if varNames(varIdx) .eq. "consentration_200" then
           varNamesO=(/"C_FL200"/)
           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
           ;delete_VarAtts(newVar, (/"coordinates"/))
     
           newVar@long_name= "consentration_200" ;
	  newVar@standard_name = "consentration_200" ;
	end if
    if varNames(varIdx) .eq. "consentration_250" then
           varNamesO=(/"C_FL250"/)
           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
           ;delete_VarAtts(newVar, (/"coordinates"/))
     
           newVar@long_name= "consentration_250" ;
	  newVar@standard_name = "consentration_250" ;
	end if
    if varNames(varIdx) .eq. "consentration_300" then
           varNamesO=(/"C_FL300"/)
           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
           ;delete_VarAtts(newVar, (/"coordinates"/))
     
           newVar@long_name= "consentration_300" ;
	  newVar@standard_name = "consentration_300" ;
	end if
    if varNames(varIdx) .eq. "consentration_350" then
           varNamesO=(/"C_FL350"/)
           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
           ;delete_VarAtts(newVar, (/"coordinates"/))
     
           newVar@long_name= "consentration_350" ;
	  newVar@standard_name = "consentration_350" ;
	end if
   
if varNames(varIdx) .eq. "consentration_400" then
           varNamesO=(/"C_FL400"/)
           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
           ;delete_VarAtts(newVar, (/"coordinates"/))
     
           newVar@long_name= "consentration_400" ;
	  newVar@standard_name = "consentration_400" ;
	end if

if varNames(varIdx) .eq. "consentration_GRND" then
           varNamesO=(/"C_GRND"/)
           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
           ;delete_VarAtts(newVar, (/"coordinates"/))
     
           newVar@long_name= "consentration_GRND" ;
	  newVar@standard_name = "consentration_GRND" ;
	end if

    
        filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time","Latitude","Longitude"/) ) ; time dimension
        filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
        fout->$varNames(varIdx)$ = (/newVar/)
        delete(newVar)
        delete(origVar)
        print("Done!")
    end do
end
